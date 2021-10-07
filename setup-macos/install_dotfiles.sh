#!/bin/bash
set -e

files_array=$(ls -A dotfiles)

for file in ${files_array}
do
    if [ -f ${HOME}/${file} ]; then
        read -p "File ${HOME}/${file} already exists. Do you want to keep a backup? (y/N)" -n 1 answer
        if [[ ${answer} == "y" || ${answer} == "Y" ]]; then
          echo "Creating backup: ${HOME}/${file}.copy"
          mv ${HOME}/${file} ${HOME}/${file}.copy
        fi
        rm ${HOME}/${file}
    fi

    file_dir=$(eval "cd files;pwd")
    filepath="${file_dir}/${file}"
    echo "symlinking: ${filepath} to ${HOME}/.${file}"
    ln -fs ${filepath} ${HOME}/.${file}
done

# Set global gitignore file
# https://stackoverflow.com/questions/18393498/gitignore-all-the-ds-store-files-in-every-folder-and-subfolder
git config --global core.excludesfile ~/.gitignore_global

echo "Installed dotfiles. Make sure to commit changes when you make them."

echo "todo: symlink common-dotfiles/"