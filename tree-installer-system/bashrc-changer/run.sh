#!/bin/bash

Base=$HOME/satellaos-install-tool-cr/tree-installer-system/bashrc-changer

echo "Changing is bash.bashrc file"

sudo cp $Base/bash.bashrc /etc/bash.bashrc

echo "bash.bashrc Changing is completed."