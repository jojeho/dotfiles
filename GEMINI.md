## Project Overview

This repository contains a set of dotfiles for configuring a development environment, primarily on macOS. The setup is heavily customized for a productive and visually appealing experience, with a focus on command-line tools and Neovim. The author, Josean, provides extensive documentation, including blog posts and YouTube videos, to guide users through the setup process.

The core components of this development environment are:

*   **Shell:** Zsh, configured with Powerlevel10k, zsh-autosuggestions, and zsh-syntax-highlighting.
*   **Terminal:** WezTerm, with a custom color scheme and font.
*   **Multiplexer:** Tmux, with plugins for session management and navigation.
*   **Editor:** Neovim, with a comprehensive set of plugins managed by `lazy.nvim`.
*   **Window Manager:** Yabai and Aerospace for tiling window management on macOS.
*   **Menu Bar:** Sketchybar for a customized menu bar on macOS.
*   **CLI Tools:** A collection of modern and efficient CLI tools, including `fzf`, `fd`, `bat`, `delta`, `eza`, `tldr`, and `thefuck`.

## Building and Running

This is not a traditional code project with a build process. Instead, it's a collection of configuration files that are "installed" by creating symbolic links to the appropriate locations in the user's home directory.

The `install.sh` script automates the installation process. To set up the environment, you can run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jojeho/dotfiles/main/install.sh)"
```

This command will:

1.  Clone the dotfiles repository to `~/.dotfiles`.
2.  Install necessary build tools.
3.  Install Homebrew (if not already installed).
4.  Install a list of packages using Homebrew.
5.  Use `stow` to create symbolic links for the dotfiles.

**NOTE:** The `install.sh` script is designed for macOS and may require modifications to work on other operating systems.

## Development Conventions

The dotfiles in this repository follow a set of conventions that promote consistency and readability.

*   **Modular Configuration:** The Neovim configuration is broken down into multiple files, organized by functionality (e.g., options, keymaps, plugins). This makes it easier to manage and customize the configuration.
*   **Well-documented:** The `README.md` file provides a comprehensive overview of the project, with links to external resources for further information. The configuration files themselves are also well-commented, explaining the purpose of each setting.
*   **Extensive Use of Plugins:** The Neovim setup relies on a large number of plugins to provide a rich and feature-full editing experience. The plugins are managed by `lazy.nvim`, which simplifies the process of installing and updating them.
*   **Custom Keybindings:** The environment includes a set of custom keybindings for common tasks, such as navigating between windows, managing tabs, and running commands. These keybindings are designed to be efficient and ergonomic.

Overall, this repository provides a well-structured and highly customized development environment that can serve as a great source of inspiration for anyone looking to improve their own setup.
