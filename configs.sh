#!/bin/sh

set -e


# setup aliases
if [ -f "$HOME/.custom/aliases.sh" ]; then
  sh "$HOME/.custom/aliases.sh"
fi
