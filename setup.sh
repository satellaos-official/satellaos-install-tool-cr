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

Repo=$HOME/satellaos-install-tool-cr
Base=$HOME/satellaos-install-tool-cr/tree-installer-system

# Repository update
log "--------------------------------------------------------------"
log "Checking repository..."
if [ -d "$Repo/.git" ]; then
    log "Repository found, updating..."
    git -C "$Repo" pull --rebase 2>&1 | tee -a "$MASTER_LOG"
else
    log "Repository not found, cloning..."
    git clone "https://github.com/satellaos-official/satellaos-install-tool-cr.git" "$Repo" 2>&1 | tee -a "$MASTER_LOG"
fi

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
run_step "08" "update-os-release"         "bash    $Base/update-os-release/run.sh"
run_step "09" "silent-kernel"             "bash    $Base/silent-kernel/run.sh"
run_step "10" "grub-settings"             "bash    $Base/grub-settings/run.sh"
run_step "11" "grub-theme"                "bash    $Base/grub-theme/run.sh"
run_step "12" "lightdm-settings"          "bash    $Base/lightdm-settings/run.sh"
run_step "13" "pictures"                  "bash    $Base/pictures/run.sh"
run_step "14" "themes"                    "bash    $Base/themes/run.sh"
run_step "15" "uca-creator"               "bash    $Base/uca-creator/run.sh --cli"
run_step "16" "fastfetch"                 "bash    $Base/fastfetch/run.sh"

print_summary
