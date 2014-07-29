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

VIMDIRS:=\
    ftdetect\
    indent\
    plugin\
    syntax\
    colors\

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
	mkdir -p $(PREFIX)/.vim
	mkdir -p $(PREFIX)/.vim/bundle
	mkdir -p $(PREFIX)/.vim/tmp
	ln -Fs $(foreach vimdir,$(VIMDIRS),$(PWD)/.vim/$(vimdir)) $(PREFIX)/.vim
	git clone https://github.com/Shougo/neobundle.vim $(PREFIX)/.vim/bundle/neobundle.vim

uninstall:
	rm -f $(foreach dotfile,$(DOTFILES),$(PREFIX)/$(dotfile))
	rm -fr $(PREFIX)/.vim
