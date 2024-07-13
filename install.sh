#!/bin/bash
set -e

# This used to setup github codespaces
# see https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles

files_array=$(ls -A common-dotfiles)

for file in ${files_array}
do
    if [ -f ${HOME}/${file} ]; then
          echo "Creating backup: ${HOME}/${file}.copy"
          mv ${HOME}/${file} ${HOME}/${file}.copy
    fi

    file_dir=$(eval "cd common-dotfiles;pwd")
    filepath="${file_dir}/${file}"
    echo "symlinking: ${filepath} to ${HOME}/.${file}"
    ln -fs ${filepath} ${HOME}/.${file}
done

# Set global gitignore file
# https://stackoverflow.com/questions/18393498/gitignore-all-the-ds-store-files-in-every-folder-and-subfolder
git config --global core.excludesfile ~/.gitignore