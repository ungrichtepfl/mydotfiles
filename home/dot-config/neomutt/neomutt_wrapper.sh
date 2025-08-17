#!/bin/bash

set -euo pipefail

neomutt "$@"
echo "Syncing IMAP accounts..."
mbsync -a -V
