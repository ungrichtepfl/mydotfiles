#!/bin/bash

set -euo pipefail

DISPATCHER=/etc/NetworkManager/dispatcher.d/10_sync_mail.sh

echo "We need your root password to create \"$DISPATCHER\"."

sudo mkdir -p "$(dirname "$DISPATCHER")"

echo -e '#!/bin/sh\n'                                                      | sudo tee    "$DISPATCHER" > /dev/null
echo "if [ \"\$2\" = \"up\" ]; then"                                       | sudo tee -a "$DISPATCHER" > /dev/null
echo "  sudo -u $USER bash -c \"goimapnotify &\"" | sudo tee -a "$DISPATCHER" > /dev/null
echo "elif [ \"\$2\" = \"down\" ]; then"                                       | sudo tee -a "$DISPATCHER" > /dev/null
echo "  sudo -u $USER bash -c \"pkill goimapnotify\"" | sudo tee -a "$DISPATCHER" > /dev/null
echo "fi"                                                                  | sudo tee -a "$DISPATCHER" > /dev/null

sudo chmod 700 "$DISPATCHER"
sudo chown root:root "$DISPATCHER"
