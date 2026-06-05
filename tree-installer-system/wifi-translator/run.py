#!/usr/bin/env python3
"""
wifi_setup.py — WiFi Setup Tool for SatellaOS Sirius
Reads /etc/network/interfaces, installs NetworkManager if needed,
and connects to WiFi. Supports raw TTY environments.

Commands requiring elevated privileges use sudo individually.
"""

import os
import sys
import subprocess
import re
import shutil
import time
import termios
import tty

# ─── ANSI color constants ──────────────────────────────────────────────────────
RESET  = "\033[0m"
BOLD   = "\033[1m"
DIM    = "\033[2m"
RED    = "\033[31m"
GREEN  = "\033[32m"
YELLOW = "\033[33m"
CYAN   = "\033[36m"
WHITE  = "\033[97m"

def supports_color() -> bool:
    if not hasattr(sys.stdout, "fileno"):
        return False
    try:
        return os.isatty(sys.stdout.fileno())
    except Exception:
        return False

USE_COLOR = supports_color()

def c(code: str, text: str) -> str:
    return f"{code}{text}{RESET}" if USE_COLOR else text

# ─── TTY helpers ───────────────────────────────────────────────────────────────
def clear_screen():
    os.system("clear" if os.name == "posix" else "cls")

def print_header():
    clear_screen()
    print(c(CYAN + BOLD, "╔══════════════════════════════════════════════════╗"))
    print(c(CYAN + BOLD, "║") + c(WHITE + BOLD, "      WiFi Setup Tool — SatellaOS Sirius          ") + c(CYAN + BOLD, "║"))
    print(c(CYAN + BOLD, "╚══════════════════════════════════════════════════╝"))
    print()

def print_step(step: int, total: int, msg: str):
    print(f"{c(CYAN, f'[{step}/{total}]')} {c(BOLD, msg)}")

def print_ok(msg: str):
    print(f"  {c(GREEN, '✔')}  {msg}")

def print_warn(msg: str):
    print(f"  {c(YELLOW, '⚠')}  {msg}")

def print_err(msg: str):
    print(f"  {c(RED, '✘')}  {msg}", file=sys.stderr)

def print_info(msg: str):
    print(f"  {c(DIM, '·')}  {c(DIM, msg)}")

def prompt(label: str, default: str = "", secret: bool = False) -> str:
    default_hint = f" [{c(DIM, default)}]" if default and not secret else ""
    sys.stdout.write(f"  {c(CYAN, '▸')} {label}{default_hint}: ")
    sys.stdout.flush()

    if secret:
        try:
            fd = sys.stdin.fileno()
            old = termios.tcgetattr(fd)
            tty.setraw(fd)
            chars = []
            while True:
                ch = sys.stdin.read(1)
                if ch in ("\n", "\r"):
                    break
                elif ch in ("\x7f", "\x08"):
                    if chars:
                        chars.pop()
                        sys.stdout.write("\b \b")
                        sys.stdout.flush()
                elif ch == "\x03":
                    raise KeyboardInterrupt
                else:
                    chars.append(ch)
                    sys.stdout.write("*")
                    sys.stdout.flush()
            termios.tcsetattr(fd, termios.TCSADRAIN, old)
            print()
            return "".join(chars)
        except (termios.error, AttributeError):
            import getpass
            return getpass.getpass("")
    else:
        value = input().strip()
        return value if value else default

def confirm(question: str, default: bool = True) -> bool:
    hint = c(DIM, "[Y/n]" if default else "[y/N]")
    sys.stdout.write(f"  {c(CYAN, '▸')} {question} {hint}: ")
    sys.stdout.flush()
    ans = input().strip().lower()
    if ans == "":
        return default
    return ans in ("y", "yes")

def spinner(msg: str, seconds: float = 1.5):
    frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
    end_time = time.time() + seconds
    i = 0
    while time.time() < end_time:
        frame = c(CYAN, frames[i % len(frames)])
        sys.stdout.write(f"\r  {frame}  {c(DIM, msg)}  ")
        sys.stdout.flush()
        time.sleep(0.1)
        i += 1
    sys.stdout.write("\r" + " " * (len(msg) + 10) + "\r")
    sys.stdout.flush()

# ─── Privilege helper ──────────────────────────────────────────────────────────
def run_privileged(cmd: list, **kwargs) -> subprocess.CompletedProcess:
    """
    Run a command. Prepends sudo only when not already root.
    Callers never need to handle privilege themselves.
    """
    if os.geteuid() != 0:
        cmd = ["sudo"] + cmd
    return subprocess.run(cmd, **kwargs)

# ─── /etc/network/interfaces parser ───────────────────────────────────────────
def parse_interfaces(path: str = "/etc/network/interfaces") -> dict:
    if not os.path.isfile(path):
        raise FileNotFoundError(f"File not found: {path}")

    result = {
        "interface": None,
        "ssid":      None,
        "psk":       None,
        "dhcp":      True,
        "address":   None,
        "netmask":   None,
        "gateway":   None,
    }

    current_iface = None

    iface_re = re.compile(r"^(?:iface|allow-hotplug|auto)\s+(\S+)")
    ssid_re  = re.compile(r"^\s+wpa-ssid\s+(\S+)")
    psk_re   = re.compile(r"^\s+wpa-psk\s+(\S+)")
    dhcp_re  = re.compile(r"^\s*iface\s+\S+\s+inet\s+(dhcp|static)")
    addr_re  = re.compile(r"^\s+address\s+(\S+)")
    mask_re  = re.compile(r"^\s+netmask\s+(\S+)")
    gw_re    = re.compile(r"^\s+gateway\s+(\S+)")

    # Read via sudo cat so normal users don't hit a PermissionError
    read_cmd = (["sudo", "cat", path] if os.geteuid() != 0 else ["cat", path])
    proc = subprocess.run(read_cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        raise PermissionError(
            f"Cannot read {path}: {proc.stderr.strip() or 'permission denied'}"
        )
    lines = proc.stdout.splitlines()

    for line in lines:
            m = iface_re.match(line)
            if m and m.group(1) not in ("lo",):
                current_iface = m.group(1)

            if current_iface:
                for pattern, key in [(ssid_re, "ssid"), (psk_re, "psk"),
                                     (addr_re, "address"), (mask_re, "netmask"),
                                     (gw_re, "gateway")]:
                    m = pattern.match(line)
                    if m:
                        result[key] = m.group(1)
                        if key == "ssid":
                            result["interface"] = current_iface

                m = dhcp_re.match(line)
                if m:
                    result["dhcp"] = (m.group(1) == "dhcp")

    return result

# ─── Detect real Wi-Fi interfaces ─────────────────────────────────────────────
def get_wifi_interfaces() -> list[str]:
    """
    Returns a list of wireless interface names by checking
    /sys/class/net/<iface>/wireless or using 'iw dev'.
    Does not rely on nmcli device type detection.
    """
    wifi_ifaces = []

    # Method 1: sysfs — most reliable on bare TTY
    try:
        for iface in os.listdir("/sys/class/net"):
            if os.path.isdir(f"/sys/class/net/{iface}/wireless"):
                wifi_ifaces.append(iface)
    except OSError:
        pass

    # Method 2: iw dev — fallback
    if not wifi_ifaces and shutil.which("iw"):
        result = subprocess.run(["iw", "dev"], capture_output=True, text=True)
        for line in result.stdout.splitlines():
            m = re.match(r"\s+Interface\s+(\S+)", line)
            if m:
                wifi_ifaces.append(m.group(1))

    return list(dict.fromkeys(wifi_ifaces))  # deduplicate, preserve order

# ─── NetworkManager installation ──────────────────────────────────────────────
def install_network_manager():
    # Check nmcli presence first — if found, nothing to do
    if shutil.which("nmcli"):
        print_ok("nmcli found — NetworkManager is already installed.")
        return

    print_warn("nmcli not found. Installing NetworkManager…")
    env = os.environ.copy()
    env["DEBIAN_FRONTEND"] = "noninteractive"

    # Use exactly: sudo apt install --no-install-recommends -y network-manager
    cmd = ["apt", "install", "--no-install-recommends", "-y", "network-manager"]
    result = run_privileged(cmd, capture_output=True, text=True, env=env)
    if result.returncode != 0:
        raise RuntimeError(
            f"apt install failed:\n{result.stderr.strip() or result.stdout.strip()}"
        )

    print_ok("NetworkManager installed.")
    run_privileged(["systemctl", "enable", "--now", "NetworkManager"],
                   capture_output=True)
    time.sleep(2)

# ─── WiFi connection ───────────────────────────────────────────────────────────
def connect_wifi(ssid: str, psk: str, iface: str) -> bool:
    # Remove stale connection profile with the same SSID if present
    run_privileged(["nmcli", "connection", "delete", ssid],
                   capture_output=True)

    cmd = ["nmcli", "device", "wifi", "connect", ssid,
           "password", psk, "ifname", iface]

    spinner("Connecting to Wi-Fi…", seconds=4)

    result = run_privileged(cmd, capture_output=True, text=True, timeout=30)

    if result.returncode == 0:
        return True

    err = (result.stdout + result.stderr).strip()
    raise RuntimeError(err if err else "Unknown nmcli error")

# ─── IP verification ───────────────────────────────────────────────────────────
def get_ip(iface: str) -> str | None:
    result = subprocess.run(
        ["ip", "-4", "addr", "show", iface],
        capture_output=True, text=True
    )
    m = re.search(r"inet\s+([\d.]+)/", result.stdout)
    return m.group(1) if m else None

# ─── Main flow ─────────────────────────────────────────────────────────────────
def main():
    TOTAL = 4
    print_header()

    # ── Initial prompt: ask if user wants to connect via WiFi ────────────────
    W = 54  # inner width (between │ and │)
    def box_line(text="", bold=False):
        style = YELLOW + BOLD if bold else YELLOW
        padded = text.ljust(W)
        print(c(style, "│") + padded + c(style, "│"))

    print(c(YELLOW + BOLD, "┌" + "─" * 4 + " WiFi Setup " + "─" * (W - 16) + "┐"))
    box_line()
    box_line("  Would you like to set up WiFi?", bold=True)
    box_line()
    box_line("  Traditional Debian systems manage WiFi through")
    box_line("  /etc/network/interfaces. This method can cause")
    box_line("  problems down the line: conflicts with Network-")
    box_line("  Manager, no GUI control, broken DNS, and more.")
    box_line("  Proceeding here will migrate your connection to")
    box_line("  NetworkManager safely.")
    box_line()
    box_line("  If you installed over a wired connection, you")
    box_line("  can safely skip this step by answering N.")
    box_line()
    print(c(YELLOW + BOLD, "└" + "─" * W + "┘"))
    print()
    if not confirm("Do you want to proceed with WiFi setup?", default=True):
        print_info("WiFi setup skipped. Exiting.")
        sys.exit(0)
    print()

    # ── Step 1: Parse interfaces file ────────────────────────────────────────
    print_step(1, TOTAL, "Reading /etc/network/interfaces…")
    try:
        cfg = parse_interfaces()
        print_ok(f"Interface : {c(WHITE, cfg['interface'] or '(not found)')}")
        print_ok(f"SSID      : {c(WHITE, cfg['ssid']      or '(not found)')}")
        print_ok(f"PSK       : {c(DIM, '****** (hidden)')}")
    except FileNotFoundError as e:
        print_warn(str(e))
        cfg = {"interface": None, "ssid": None, "psk": None, "dhcp": True,
               "address": None, "netmask": None, "gateway": None}
    print()

    # ── Step 2: Validate / override credentials ───────────────────────────────
    print_step(2, TOTAL, "Verifying connection details…")

    if cfg["ssid"]:
        if not confirm(f"Use '{c(WHITE + BOLD, cfg['ssid'])}' as SSID?"):
            cfg["ssid"] = prompt("Enter new SSID")
    else:
        cfg["ssid"] = prompt("WiFi SSID")

    if not cfg["ssid"]:
        print_err("SSID cannot be empty. Aborting.")
        sys.exit(1)

    if cfg["psk"]:
        if not confirm("Use the existing password?"):
            cfg["psk"] = prompt("New WiFi password", secret=True)
    else:
        cfg["psk"] = prompt("WiFi password", secret=True)

    if not cfg["psk"]:
        print_err("Password cannot be empty. Aborting.")
        sys.exit(1)

    print()

    # ── Step 3: Detect Wi-Fi interface ───────────────────────────────────────
    print_step(3, TOTAL, "Detecting Wi-Fi interface…")

    wifi_ifaces = get_wifi_interfaces()

    if not wifi_ifaces:
        print_err("No wireless interfaces found on this system.")
        print_info("Make sure your Wi-Fi adapter is recognized by the kernel.")
        sys.exit(1)

    # Prefer the interface from interfaces file if it's actually wireless
    chosen_iface = None
    if cfg["interface"] and cfg["interface"] in wifi_ifaces:
        chosen_iface = cfg["interface"]
        print_ok(f"Using interface from config: {c(WHITE, chosen_iface)}")
    elif len(wifi_ifaces) == 1:
        chosen_iface = wifi_ifaces[0]
        if cfg["interface"] and cfg["interface"] != chosen_iface:
            print_warn(
                f"'{cfg['interface']}' in config is not a Wi-Fi device. "
                f"Using detected interface: {c(WHITE, chosen_iface)}"
            )
        else:
            print_ok(f"Detected interface: {c(WHITE, chosen_iface)}")
    else:
        # Multiple Wi-Fi interfaces — let the user pick
        print_info("Multiple Wi-Fi interfaces detected:")
        for idx, iface in enumerate(wifi_ifaces, 1):
            print(f"    {c(CYAN, str(idx))}. {iface}")
        while True:
            raw = prompt(f"Select interface [1-{len(wifi_ifaces)}]")
            if raw.isdigit() and 1 <= int(raw) <= len(wifi_ifaces):
                chosen_iface = wifi_ifaces[int(raw) - 1]
                break
            print_warn("Invalid selection, try again.")

    # ── Step 4: Install NM + connect ─────────────────────────────────────────
    print()
    print_step(4, TOTAL, "Installing NetworkManager & connecting…")

    try:
        install_network_manager()
    except RuntimeError as e:
        print_err(f"Could not install NetworkManager: {e}")
        sys.exit(1)

    try:
        connect_wifi(cfg["ssid"], cfg["psk"], chosen_iface)
    except (RuntimeError, subprocess.TimeoutExpired) as e:
        print_err(f"Connection failed: {e}")
        print_info("Check your SSID / password and try again.")
        sys.exit(1)

    # Verify
    time.sleep(2)
    ip = get_ip(chosen_iface)
    print()
    if ip:
        print(c(GREEN + BOLD, "  ══════════════════════════════════════════"))
        print(c(GREEN + BOLD, f"  ✔  Connected successfully!   IP: {ip}"))
        print(c(GREEN + BOLD, "  ══════════════════════════════════════════"))
    else:
        print_warn("nmcli reported success but no IP address yet.")
        print_info("Run 'ip addr' to check interface status.")
    print()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        print_warn("Aborted by user.")
        sys.exit(130)
