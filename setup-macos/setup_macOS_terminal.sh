#!/usr/bin/env bash

# Disclaimer: copied & adapted parts of https://github.com/ghaiklor/iterm-fish-fisherman-osx/blob/master/install.sh
# https://github.com/bhilburn/powerlevel9k/wiki/Show-Off-Your-Config
# looks like: https://gist.github.com/kevin-smets/8568070
# https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c

set -e
trap on_sigterm SIGKILL SIGTERM

TEMP_DIR=$(mktemp -d)
GITHUB_REPO_URL_BASE="https://github.com/ghaiklor/iterm-fish-fisherman-osx/"
HOMEBREW_INSTALLER_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"
COLOR_SCHEME_URL="https://raw.githubusercontent.com/MartinSeeler/iterm2-material-design/master/material-design-colors.itermcolors"
OH_MY_ZSH_URL="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
RESET_COLOR="\033[0m"
RED_COLOR="\033[0;31m"
GREEN_COLOR="\033[0;32m"
BLUE_COLOR="\033[0;34m"

function reset_color() {
    echo -e "${RESET_COLOR}\c"
}

function red_color() {
    echo -e "${RED_COLOR}\c"
}

function green_color() {
    echo -e "${GREEN_COLOR}\c"
}

function blue_color() {
    echo -e "${BLUE_COLOR}\c"
}

function separator() {
    green_color
    echo "#=============================STEP FINISHED=============================#"
    reset_color
}

function hello() {
    green_color
    echo "                                              "
    echo "           iTerm + zsh + Oh-my-Zsh            "
    echo "                 by @timvink                  "
    echo "                                              "
    echo "                                              "

    blue_color
    echo "This script will guide you through installing all the required dependencies for a nice terminal setup"
    echo "It will not install anything, without your direct agreement"
    echo "Make sure to run this script from the default Terminal.app"

    green_color
    read -p "Do you want to proceed with installation? (y/N) " -n 1 answer
    echo
    if [ ${answer} != "y" ]; then
        exit 1
    fi

    reset_color
}

function install_command_line_tools() {
    blue_color
    echo "Trying to detect installed Command Line Tools..."

    if ! [ $(xcode-select -p) ]; then
        blue_color
        echo "You don't have Command Line Tools installed"
        echo "They are required to proceed with installation"

        green_color
        read -p "Do you agree to install Command Line Tools? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing Command Line Tools..."
        echo "Please, wait until Command Line Tools will be installed, before continue"
        echo "I can't wait for its installation from the script, so continue..."

        xcode-select --install
    else
        blue_color
        echo "Seems like you have installed Command Line Tools, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_homebrew() {
    blue_color
    echo "Trying to detect installed Homebrew..."

    if ! [ $(which brew) ]; then
        blue_color
        echo "Seems like you don't have Homebrew installed"
        echo "We need it for completing the installation of your awesome terminal environment"

        green_color
        read -p "Do you agree to proceed with Homebrew installation? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing Homebrew..."

        ruby -e "$(curl -fsSL ${HOMEBREW_INSTALLER_URL})"
        brew update
        brew upgrade

        green_color
        echo "Homebrew installed!"
    else
        blue_color
        echo "You already have Homebrew installed, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_iTerm2() {
    blue_color
    echo "Trying to find installed iTerm..."

    if ! [ $(ls /Applications/ | grep iTerm.app) ]; then
        blue_color
        echo "I can't find installed iTerm"

        green_color
        read -p "Do you agree to install it? (y/N) " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        fi

        blue_color
        echo "Installing iTerm2..."

        brew cask install iterm2

        green_color
        echo "iTerm2 installed!"
    else
        blue_color
        echo "Found installed iTerm.app, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_color_scheme() {
    green_color
    read -p "Do you want to install material color scheme for iTerm? (y/N) " -n 1 answer
    echo
    if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
        blue_color
        echo "Downloading color scheme in ${TEMP_DIR}..."

        cd ${TEMP_DIR}
        curl -fsSL ${COLOR_SCHEME_URL} > ./material-design.itermcolors

        blue_color
        echo "iTerm will be opened in 5 seconds, asking to import color scheme (in case, you installed iTerm)"
        echo "Close iTerm when color scheme will be imported"
        sleep 5
        open -W ./material-design.itermcolors

        green_color
        echo "Color Scheme is installed!"
    else
        blue_color
        echo "Skipping Material Color Scheme installation..."
    fi

    reset_color
    separator
    sleep 1
}

function install_nerd_font() {
    green_color
    read -p "Do you want to install Meslo Nerd Font? (y/N) " -n 1 answer
    echo
    if [[ ${answer} == "y" || ${answer} == "Y" ]]; then

	brew tap homebrew/cask-fonts
        brew cask install font-meslo-for-powerline

        green_color
        echo "Nerd Font is successfully installed!"
    else
        blue_color
        echo "Skipping Nerd Font installation..."
    fi

    reset_color
    separator
    sleep 1
}

function install_oh_my_zsh() {
    blue_color
    echo "Trying to find installed oh my zsh..."

    if [ ! -e ~/.oh-my-zsh ]; then
        blue_color
        echo "I can't find installed oh my zsh"

        green_color
        read -p "Do you agree to install it? (y/N) " -n 1 answer
        echo
        if [ ${answer} == "n" ]; then
           red_color
           echo "oh-my-zsh is required, exiting"
           exit 1
        fi

        blue_color
        echo "Installing oh my zsh..."

        sh -c "$(curl -fsSL ${OH_MY_ZSH_URL})"

        green_color
        echo "oh my zsh installed!"
    else
        blue_color
        echo "Found installed oh my zsh, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_powerlevel9k() {
    blue_color
    echo "Trying to find installed oh my zsh theme powerlevel9k..."

    if [ ! -e ~/.oh-my-zsh/custom/themes/powerlevel9k ]; then
        blue_color
        echo "I can't find installed oh my zsh theme powerlevel9k"

        green_color
        read -p "Do you agree to install it? (y/N) " -n 1 answer
        echo
        if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
          blue_color
          echo "Installing powerlevel9k theme..."

          git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

          green_color
          echo "oh my zsh installed!"
        else
          blue_color
          echo "Skipping powerlevel9k installation..."
        fi

    else
        blue_color
        echo "Found installed powerlevel9k theme, so skipping..."
    fi

    reset_color
    separator
    sleep 1
}

function install_zsh_plugins() {
  green_color
  read -p "Do you want to install several zsh plugins? (y/N) " -n 1 answer
  echo
  if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
      blue_color
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
      echo "Installed zsh-syntax-highlighting into ~/.oh-my-zsh/custom/plugins."
      echo ""

      git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
      echo "Installed zsh-autosuggestions into ~/.oh-my-zsh/custom/plugins."
      echo ""

      echo "zsh plugins successfully installed!"
  else
      blue_color
      echo "Skipping zsh plugins installation..."
  fi

  reset_color
  separator
  sleep 1
}

function install_vim_vundle() {
  green_color
  read -p "Do you want to install Vundle plugin manager for vim? (y/N) " -n 1 answer
  echo
  if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
      blue_color
      git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
      echo "Installed Vundle into ~/.vim/bundle/Vundle.vim."
      echo ""
  else
      blue_color
      echo "Skipping Vundle installation..."
  fi

  reset_color
  separator
  sleep 1
}
function copy_zshrc() {
  green_color
  read -p "Do you want to replace the default .zshrc with Tim's? (recommend) (y/N) " -n 1 answer
  echo
  if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
      blue_color
      cp files/zshrc ~/.zshrc
      echo "Installed .zshrc to ~/.zshrc !"
  else
      blue_color
      echo "Skipping .zshrc installation, please enable plugins yourself"
  fi

  reset_color
  separator
  sleep 1
}


function post_install() {
    green_color
    echo
    echo "also install tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo
    echo "install tmuxinator"
    sudo gem install tmuxinator
    echo
    echo "setup was successfully done"
    echo "do not forgot to make some simple, but manual things:"
    echo
    echo "1) open iterm -> preferences -> profiles -> colors -> presets and apply material color preset"
    echo "2) open iterm -> preferences -> profiles -> text -> font and apply font (f.e. meslo mono) (for non-ascii as well)"
    echo "2) open iterm -> preferences -> profiles -> windows -> styles = no title bar"
    echo "3) by default, word jumps (option + → or ←) and word deletions (option + backspace) do not work. to enable these, go to 'iterm → preferences → profiles → keys → load preset... → natural text editing → boom! head explodes'"
    echo "4) open ~/.zshrc and customize based on your current ~/.bashrc. pay attention to the path variable."
    echo "also iterm > preferences > general > check applications in terminal may access clipboard"
    echo
    echo "happy coding!"

    reset_color
    exit 0
}

function on_sigterm() {
    red_color
    echo
    echo -e "Wow... Something serious happened!"
    reset_color
    exit 1
}

hello
install_command_line_tools
install_homebrew
install_iTerm2
install_color_scheme
install_nerd_font
install_oh_my_zsh
install_powerlevel9k
install_zsh_plugins
install_vim_vundle
copy_zshrc
post_install
