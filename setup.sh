#!/bin/bash

# =============================================================================
# Log System
# =============================================================================

LOG_DIR="$HOME/.satellaos-install/logs"
MASTER_LOG="$LOG_DIR/install.log"
FAILED_STEPS=()

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$MASTER_LOG"
}

run_step() {
    local step_num="$1"
    local step_name="$2"
    local cmd="$3"
    local optional="${4:-false}"
    local step_log="$LOG_DIR/${step_num}-${step_name}.log"

    log "--------------------------------------------------------------"
    log "START  >> Step $step_num: $step_name"

    if (set -o pipefail; eval "$cmd" 2>&1 | tee "$step_log"); then
        log "OK     >> Step $step_num: $step_name"
    else
        local exit_code=$?
        log "FAILED >> Step $step_num: $step_name (exit code: $exit_code)"
        log "         Log: $step_log"

        if [ "$optional" = "true" ]; then
            log "INFO   >> Step $step_num is optional, continuing..."
        else
            FAILED_STEPS+=("$step_num-$step_name")
            log "ERROR  >> Non-optional step failed. Aborting."
            log "--------------------------------------------------------------"
            print_summary
            exit 1
        fi
    fi
}

print_summary() {
    log "=============================================================="
    log "INSTALL SUMMARY"
    log "=============================================================="
    if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
        log "STATUS: All steps completed successfully."
    else
        log "STATUS: Installation failed."
        log "Failed steps:"
        for step in "${FAILED_STEPS[@]}"; do
            log "  - $step"
        done
    fi
    log "Master log : $MASTER_LOG"
    log "Step logs  : $LOG_DIR/"
    log "=============================================================="
}

# =============================================================================
# Main
# =============================================================================

log "=============================================================="
log "Installing The SatellaOS System"
log "=============================================================="

Base=$HOME/satellaos-install-tool-cr/tree-installer-system

# =============================================================================
# Steps
# optional=true  → failure is logged but install continues
# optional=false → failure aborts the install (default)
# =============================================================================

run_step "01" "dependencies"              "bash    $Base/dependencies/run.sh"
run_step "02" "update-adduser"            "bash    $Base/update-adduser/run.sh"
run_step "03" "install-network-manager"   "bash    $Base/install-network-manager/run.sh"
run_step "04" "wifi-translator"           "python3 $Base/wifi-translator/run.py"          "true"
run_step "05" "clean-network-interfaces"  "bash    $Base/clean-network-interfaces/run.sh"
run_step "06" "update-apt-sources"        "bash    $Base/update-apt-sources/run.sh"
run_step "07" "core"                      "bash    $Base/core/run.sh"
run_step "08" "flatpak"                   "bash    $Base/flatpak/run.sh"
run_step "09" "update-os-release"         "bash    $Base/update-os-release/run.sh"
run_step "10" "silent-kernel"             "bash    $Base/silent-kernel/run.sh"
run_step "11" "grub-settings"             "bash    $Base/grub-settings/run.sh"
run_step "12" "grub-theme"                "bash    $Base/grub-theme/run.sh"
run_step "13" "lightdm-settings"          "bash    $Base/lightdm-settings/run.sh"
run_step "14" "user-settings"             "bash    $Base/user-configuration-settings/run.sh"
run_step "15" "skel-settings"             "bash    $Base/skel-configuration-settings/run.sh"
run_step "16" "bashrc-changer"            "bash    $Base/bashrc-changer/run.sh"
run_step "17" "pictures"                  "bash    $Base/pictures/run.sh"
run_step "18" "themes"                    "bash    $Base/themes/run.sh"
run_step "19" "fastfetch"                 "bash    $Base/fastfetch/run.sh"
run_step "20" "uca-creator"               "bash    $Base/uca-creator/run.sh"
run_step "21" "driver-creator"            "bash    $Base/driver-installer/run.sh"
run_step "22" "program-installer"         "bash    $Base/program-installer/run.sh"

print_summary
