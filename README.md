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

## UPDATE

```sh
make update
```

## UNINSTALL

```sh
make uninstall
```

## Requirements

* coreutils
* gcc
* git
* make

## Paku...Inspired from

https://github.com/etheriqa/dotfiles

## Switch to zsh shell

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

