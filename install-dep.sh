#!/bin/bash

# Prompt and install libtool-ltdl-devel
echo "Installing libtool-ltdl-devel..."
dnf install -y -q libtool-ltdl-devel

# Prompt and install ctags-etags
echo "Installing ctags-etags..."
dnf install -y -q ctags-etags

# Prompt and install emacs
echo "Installing emacs..."
dnf install -y -q emacs

# Prompt and install doxygen
echo "Installing doxygen..."
dnf install -y -q doxygen

# Prompt and install python3-devel
echo "Installing python3-devel..."
dnf install -y -q python3-devel

# Prompt and install ncurses-devel
echo "Installing ncurses-devel..."
dnf install -y -q ncurses-devel

echo "All packages have been installed."
