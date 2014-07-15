case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshenv.darwin ]; then . $HOME/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshenv.linux ]; then . $HOME/.zshenv.linux; fi
    ;;
esac

export LANG=ja_JP.UTF-8

# default path
PATH=/usr/local/bin:$HOME/bin:$PATH
export PATH
#eval "$(rbenv init -)"

