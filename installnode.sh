#!/bin/sh
set -e

if test -z "$BASH" && ! sh -c 'function aa { echo; }' 2>/dev/null; then
  bash "$0" "$@"
  exit
fi

if which node &>/dev/null; then
  exit 0
fi

test -n "$1" || echo "Needs node, installing it..."

. "$CUSTOM_DIR/utils.sh"

if test -e "$BIN_PATH/node"; then
  echo 'Node is already installed but is not in your PATH'
  warn_path
  exit 1
fi

mkdir -p "$OPT_PATH/node"
$download 'https://nodejs.org/dist/v18.17.1/node-v18.17.1-linux-x64.tar.gz' | tar xz --strip-components=1 -C "$OPT_PATH/node"
ln "$OPT_PATH/node/bin"/* "$BIN_PATH/"

echo Done!
