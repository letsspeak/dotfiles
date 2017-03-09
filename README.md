# Requirements

* coreutils
* gcc
* git
* make

# Usage

## Install

```sh
curl https://raw.githubusercontent.com/letsspeak/dotfiles/master/bootstrap.sh | PREFIX=PATH_TO_DIR bash
```

or

```sh
git clone git@github.com:letsspeak/dotfiles
cd dotfiles
make install
```

## Update

```sh
make update
```

## Uninstall

```sh
make uninstall
```

## Visual Studio Code setting files

```sh
# Import Visual Studio Code setting files to dotfiles
make import-vscode

# Export Visual Studio Code setting files from dotfiles
make export-vscode
```

# Other

## Switch to zsh

```sh
$ cat /etc/shells
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.

/bin/bash
/bin/csh
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh

$ chsh -s /bin/zsh

```

