case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshenv.darwin ]; then . $HOME/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshenv.linux ]; then . $HOME/.zshenv.linux; fi
    ;;
esac

if [ -f $HOME/.zshenv.local ]; then . $HOME/.zshenv.local; fi

export LANG=ja_JP.UTF-8

# default path
PATH=/usr/local/bin:$HOME/bin:$PATH
export PATH

# rbenv
if [ -d $HOME/.rbenv ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
# first time 
#  $ git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
#  $ rbenv install
fi

