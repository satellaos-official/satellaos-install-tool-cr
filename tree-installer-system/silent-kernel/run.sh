#!/usr/bin/env bash

echo "Silent The Kernel Messsages"

set -euo pipefail

CONF="/etc/sysctl.d/99-silent-kernel.conf"

echo "kernel.printk = 1 4 1 7" | sudo tee "$CONF" >/dev/null

sudo sysctl --system