case $OSTYPE in
  darwin*)
    if [ -f $HOME/.zshenv.darwin ]; then . $HOME/.zshenv.darwin; fi
    ;;
  linux*)
    if [ -f $HOME/.zshenv.linux ]; then . $HOME/.zshenv.linux; fi
    ;;
esac

export LANG=ja_JP.UTF-8

# play2 framework
export PATH=$PATH:/usr/local/play/play-2.2.3

# default path
PATH=/usr/local/bin:$HOME/bin:$PATH
export PATH
if [ -d $HOME/.rbenv ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
# first time 
#  $ git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
#  $ rbenv install
fi

