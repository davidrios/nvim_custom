#!/bin/sh
set -e

if test -z "$BASH" && ! sh -c 'function aa { echo; }' 2>/dev/null; then
  bash "$0" "$@"
  exit
fi

BIN_PATH="$HOME/.local/bin"
BINDOWN="$BIN_PATH/nvim._download"

function show_error() {
  echo "Error executing script at line $1, aborting!"
  rm -f "$BINDOWN"
}
trap 'show_error $LINENO' ERR

download=$( (which curl && echo " -f -L") || (which wget && echo " -O-") || echo err)
if test "$download" == "err"; then
  echo "Error: no curl or wget installed."
  exit 1
fi

if ! which git >/dev/null; then
  echo "git is required, please install it first."
  exit 1
fi

echo $PATH | grep -q "$BIN_PATH" || NOPATH=1
export PATH="$BIN_PATH:$PATH"
! test -f "/etc/alpine-release" || ISALPINE=1

if ! which nvim >/dev/null; then
  if test "$(uname -m)" != "x86_64"; then
    echo "Current arch can't be set up automatically, please install neovim manually and run the script again."
    exit 1
  fi

  if test -n "$ISALPINE"; then
    if ! test "$(id -u)" -eq 0; then
      echo "Please install neovim manually running 'apk add neovim' as root and try again."
      exit 1
    fi

    apk add --no-cache neovim
  else
    echo "Neovim not found, installing AppImage..."
    mkdir -p "$BIN_PATH"
    $download 'https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage' > "$BINDOWN"
    chmod +x "$BINDOWN"
    sleep 1  # workaround for text file busy error
    if "$BINDOWN" --help 2>&1 | grep -iq fuse; then
      mkdir -p "$HOME/.local/opt"
      cd "$HOME/.local/opt"
      "$BINDOWN" --appimage-extract &>/dev/null
      mv squashfs-root nvim
      ln -sf "../opt/nvim/usr/bin/nvim" "$BIN_PATH/nvim"
      rm "$BINDOWN"
    else
      mv "$BINDOWN" "$BIN_PATH/nvim"
    fi
  fi
fi

if ! test -f "$HOME/.config/nvim/lua/custom/init.lua"; then
  mkdir -p "$HOME/.config"
  git clone 'https://github.com/NvChad/NvChad' "$HOME/.config/nvim" --depth 1
  git clone 'https://github.com/davidrios/nvim_custom' "$HOME/.config/nvim/lua/custom" --depth 1
  nvim

  test -z "$NOPATH" || echo "Add '$BIN_PATH' to your \$PATH to be able to call 'nvim', eg: echo 'export PATH=$BIN_PATH:\$PATH' >> ~/.bashrc"
fi

