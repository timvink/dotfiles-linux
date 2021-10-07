#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine

# Credits: Partly adapted from https://gist.github.com/codeinthehole/26b37efa67041e1307db
#
# This should be idempotent so it can be run multiple times.
#
echo "Starting setup of macOS"

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
#brew tap homebrew/dupes
brew install coreutils
#brew install gnu-sed --with-default-names
#brew install gnu-tar --with-default-names
#brew install gnu-indent --with-default-names
#brew install gnu-which --with-default-names
#brew install gnu-grep --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# The much faster `ag` command
brew install the_silver_searcher

# The very cool `exa`, a colorized `ls`
# Note I have an alias setup in my .zshrc file but not in .bashrc
brew install exa

# We need vim with clipboard brew install vim --with-client-serversupport
brew install vim --with-client-server

# Install some brew packages
echo "Installing packages..."
PACKAGES=(
  bash
  bash-completion
  zsh
  git
  jq
  tmux
  tree
  wget
  bat
)
brew install ${PACKAGES[@]}
brew install freetype # R package sysfonts needs this C library
brew install libxml2 # R tidyverse dependency
brew install reattach-to-user-namespace # Copy/paste in tmux

echo "Cleaning up..."
brew cleanup

# Get homebrew cask
brew tap homebrew/cask

# Cask programs
CASKS=(
    visual-studio-code
    dropbox
    flux
    iterm2
    shiftit
    spotify
    typora
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

# Install R
# Install as cask to prevent compiling packages from source
# See https://github.com/adamhsparks/setup_macOS_for_R
brew cask install r

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
    font-roboto
    font-clear-sans
    font-fira-code
)
brew cask install ${FONTS[@]}

echo "Configuring OSX..."

# Require password as soon as screensaver or sleep mode starts
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Make sure to not get those annoying .DS_Store files everywhere
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles YES

# Setup my workspace folder
# echo "Creating ~/workspace structure..."
# [[ ! -d workspace ]] && mkdir workspace

# Change computer name
# sudo scutil --set ComputerName timvink_MBP

# Some repo's I want cloned locally
# echo "... Done."

# Google chrome extensions
# j k  navigations
# Setup https://github.com/infokiller/google-search-navigator

# System Preferences
#   - General
#     - Use dark menubar and doc
#   - Dock
#     - Automatically hide and show the dock
#   - Mission Control
#     - no Automatically rearrange spaces based on recent use
#  - Keyboard
#     - Modifier Keys
#         - Set caps lock to control
#   - Date & Time
#     - Clock
#       - Show date

# Menu Bar
#   - Battery Icon
#     - Show Percentage

# App store
# - Next Meeting


# VS Code
# executing line by line:
# https://github.com/Microsoft/vscode-python/issues/480 
# python & atom one dark theme extensions
