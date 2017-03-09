SHELL:=/bin/bash
PREFIX:=$(HOME)
OSRELEASE=$(shell cat /proc/sys/kernel/osrelease 2>/dev/null)
UNAME_S=$(shell uname -s)

DOTFILES:=\
    .inputrc\
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

# VSCode import/export settings
ifeq ($(UNAME_S),Darwin)
  VSCODE_SETTINGS_DIR=$(HOME)/Library/Application\ Support/Code/User
  VSCODE_LOCALE_IDENTIFIER="darwin"
endif
ifeq ($(UNAME_S),Linux)
  VSCODE_SETTINGS_DIR="$(HOME)/.config/Code/User"
  VSCODE_LOCALE_IDENTIFIER="linux"
endif

VSCODE_DOTFILES_DIR:="$(PWD)/vscode"

VSCODE_SETTING_FILES:=\
    locale.json

VSCODE_LOCALED_JSONS:=\
    settings\
    keybindings

all: help

.PHONY: \
	all \
	help \
	install \
	update \
	dotfiles \
	vim \
	uninstall \
	export-vscode \
	import-vscode

help:
	@echo "Usage:"
	@echo "  make install       ... install dotfilesat $(HOME)"
	@echo "  make update        ... update dotfiles"
	@echo "  make uninstall     ... remove symlinks from $(HOME)"
	@echo "  make export-vscode (USERNAME=[Username])"
	@echo "                     ... export VSCode settings from dotfiles"
	@echo "  make import-vscode (USERNAME=[Username])"
	@echo "                     ... import VSCode settings to dotfiles"

install: dotfiles vim

update:
	git pull --rebase

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


#
# VSCode import/export settings
#

import-vscode:
ifndef VSCODE_DOTFILES_DIR
	$(error VSCODE_DOTFILES_DIR is not set)
endif
ifneq (, $(findstring Microsoft,$(OSRELEASE)))
	@while [ -z "$$USERNAME" ]; do \
		read -r -p "Input Windows Username: " USERNAME;\
	done && \
	( \
		FROM_DIR="/mnt/c/Users/$$USERNAME/AppData/Roaming/Code/User"; \
		TO_DIR=$(VSCODE_DOTFILES_DIR); \
		if [ -e "$$FROM_DIR" ]; then \
			for filename in $(VSCODE_SETTING_FILES); do \
				FROM_PATH="$$FROM_DIR/$$filename"; \
				TO_PATH="$$TO_DIR/$$filename"; \
				if [ -e "$$FROM_PATH" ]; then \
					echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
					cp "$$FROM_PATH" "$$TO_PATH"; \
				fi \
			done; \
			for json in $(VSCODE_LOCALED_JSONS); do \
				FROM_PATH="$$FROM_DIR/$$json.json"; \
				TO_PATH="$$TO_DIR/$$json.win.json"; \
				if [ -e "$$FROM_PATH" ]; then \
					echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
					cp "$$FROM_PATH" "$$TO_PATH"; \
				fi \
			done \
		else \
			echo -e "\033[1;31m[FATAL]\033[0m Target directory $$FROM_DIR not found."; \
			exit 1; \
		fi \
	)
else
ifndef VSCODE_SETTINGS_DIR
	$(error VSCODE_SETTINGS_DIR is not set)
endif
ifndef VSCODE_LOCALE_IDENTIFIER
	$(error VSCODE_LOCALE_IDENTIFIER is not set)
endif
	@FROM_DIR=$(VSCODE_SETTINGS_DIR); \
	TO_DIR=$(VSCODE_DOTFILES_DIR); \
	if [ -e "$$FROM_DIR" ]; then \
		for filename in $(VSCODE_SETTING_FILES); do \
			FROM_PATH="$$FROM_DIR/$$filename"; \
			TO_PATH="$$TO_DIR/$$filename"; \
			if [ -e "$$FROM_PATH" ]; then \
				echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
				cp "$$FROM_PATH" "$$TO_PATH"; \
			fi \
		done; \
		for json in $(VSCODE_LOCALED_JSONS); do \
			FROM_PATH="$$FROM_DIR/$$json.json"; \
			TO_PATH="$$TO_DIR/$$json.$(VSCODE_LOCALE_IDENTIFIER).json"; \
			if [ -e "$$FROM_PATH" ]; then \
				echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
				cp "$$FROM_PATH" "$$TO_PATH"; \
			fi \
		done \
	else \
		echo -e "\033[1;31m[FATAL]\033[0m Target directory $$FROM_DIR not found."; \
		exit 1; \
	fi
endif


export-vscode:
	@# for Bash on Ubuntu on Windows
ifneq (, $(findstring Microsoft,$(OSRELEASE)))
	@while [ -z "$$USERNAME" ]; do \
		read -r -p "Input Windows Username: " USERNAME;\
	done && \
	( \
		FROM_DIR=$(VSCODE_DOTFILES_DIR); \
		TO_DIR="/mnt/c/Users/$$USERNAME/AppData/Roaming/Code/User"; \
		if [ -e "$$TO_DIR" ]; then \
			for filename in $(VSCODE_SETTING_FILES); do \
				FROM_PATH="$$FROM_DIR/$$filename"; \
				TO_PATH="$$TO_DIR/$$filename"; \
				if [ -e "$$FROM_PATH" ]; then \
					if [ -e "$$TO_PATH" ]; then \
						while true; do \
							read -p "Are you overwrite $$TO_PATH ? (Default Yes) [Y/n]" is_overwrite; \
							case $$is_overwrite in \
								'' | [Yy]* ) \
									echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
									cp "$$FROM_PATH" "$$TO_PATH"; \
									break; \
									;; \
								[Nn]* ) \
									break; \
									;; \
								* ) \
									echo "Please answer YES or NO."; \
							esac \
						done \
					else \
						echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
						cp "$$FROM_PATH" "$$TO_PATH"; \
					fi \
				fi \
			done; \
			for json in $(VSCODE_LOCALED_JSONS); do \
				FROM_PATH="$$FROM_DIR/$$json.win.json"; \
				TO_PATH="$$TO_DIR/$$json.json"; \
				if [ -e "$$FROM_PATH" ]; then \
					if [ -e "$$TO_PATH" ]; then \
						while true; do \
							read -p "Are you overwrite $$TO_PATH ? (Default Yes) [Y/n]" is_overwrite; \
							case $$is_overwrite in \
								'' | [Yy]* ) \
									echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
									cp "$$FROM_PATH" "$$TO_PATH"; \
									break; \
									;; \
								[Nn]* ) \
									break; \
									;; \
								* ) \
									echo "Please answer YES or NO."; \
							esac \
						done \
					else \
						echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
						cp "$$FROM_PATH" "$$TO_PATH"; \
					fi \
				fi \
			done \
		else \
			echo -e "\033[1;31m[FATAL]\033[0m Target directory $$TO_DIR not found."; \
			exit 1; \
		fi \
	)
else
ifndef VSCODE_SETTINGS_DIR
	$(error VSCODE_SETTINGS_DIR is not set)
endif
ifndef VSCODE_LOCALE_IDENTIFIER
	$(error VSCODE_LOCALE_IDENTIFIER is not set)
endif
	@FROM_DIR=$(VSCODE_DOTFILES_DIR); \
	TO_DIR=$(VSCODE_SETTINGS_DIR); \
	if [ -e "$$TO_DIR" ]; then \
		for filename in $(VSCODE_SETTING_FILES); do \
			FROM_PATH="$$FROM_DIR/$$filename"; \
			TO_PATH="$$TO_DIR/$$filename"; \
			if [ -e "$$FROM_PATH" ]; then \
				if [ -e "$$TO_PATH" ]; then \
					while true; do \
						read -p "Are you overwrite $$TO_PATH ? (Default Yes) [Y/n]" is_overwrite; \
						case $$is_overwrite in \
							'' | [Yy]* ) \
								echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
								cp "$$FROM_PATH" "$$TO_PATH"; \
								break; \
								;; \
							[Nn]* ) \
								break; \
								;; \
							* ) \
								echo "Please answer YES or NO."; \
						esac \
					done \
				else \
					echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
					cp "$$FROM_PATH" "$$TO_PATH"; \
				fi \
			fi \
		done; \
		for json in $(VSCODE_LOCALED_JSONS); do \
			FROM_PATH="$$FROM_DIR/$$json.$(VSCODE_LOCALE_IDENTIFIER).json"; \
			TO_PATH="$$TO_DIR/$$json.json"; \
			if [ -e "$$FROM_PATH" ]; then \
				if [ -e "$$TO_PATH" ]; then \
					while true; do \
						read -p "Are you overwrite $$TO_PATH ? (Default Yes) [Y/n]" is_overwrite; \
						case $$is_overwrite in \
							'' | [Yy]* ) \
								echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
								cp "$$FROM_PATH" "$$TO_PATH"; \
								break; \
								;; \
							[Nn]* ) \
								break; \
								;; \
							* ) \
								echo "Please answer YES or NO."; \
						esac \
					done \
				else \
					echo "Copying... $$FROM_PATH >> $$TO_PATH"; \
					cp "$$FROM_PATH" "$$TO_PATH"; \
				fi \
			fi \
		done \
	else \
		echo -e "\033[1;31m[FATAL]\033[0m Target directory $$TO_DIR not found."; \
		exit 1; \
	fi
endif
