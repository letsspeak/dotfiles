.PHONY: update install uninstall dotfiles vim

PREFIX:=$(HOME)

DOTFILES:=\
    .vimrc\
    .zshenv\
    .zshenv.darwin\
    .zshenv.linux\
    .zshrc\
    .zshrc.darwin\
    .zshrc.linux\

update:
	git pull --rebase

install: dotfiles vim

dotfiles:
	ln -Fs $(foreach dotfile,$(DOTFILES),$(PWD)/$(dotfile)) $(PREFIX)
	touch $(PREFIX)/.gitconfig.local
	touch $(PREFIX)/.vimrc.local
	touch $(PREFIX)/.zshenv.local
	touch $(PREFIX)/.zshrc.local

vim:
	mkdir -p $(PREFIX)/.vim/bundle
	mkdir -p $(PREFIX)/.vim/tmp
	git clone https://github.com/Shougo/neobundle.vim $(PREFIX)/.vim/bundle/neobundle.vim

uninstall:
	rm -f $(foreach dotfile,$(DOTFILES),$(PREFIX)/$(dotfile))
	rm -fr $(PREFIX)/.vim
