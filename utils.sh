#!/bin/sh
BIN_PATH="$HOME/.local/bin"
OPT_PATH="$HOME/.local/opt"
echo $PATH | grep -q "$BIN_PATH" || NOPATH=1

function warn_path() {
  test -z "$NOPATH" || echo "Please add '$BIN_PATH' to your \$PATH, eg: echo 'export PATH=$BIN_PATH:\$PATH' >> ~/.bashrc"
}

download=$( (which curl && echo " -fsL") || (which wget && echo "--progress=dot -O-") || echo err)
