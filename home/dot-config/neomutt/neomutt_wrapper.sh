#!/bin/bash

set -euo pipefail

neomutt "$@"
mbsync -a -V
