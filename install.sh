ln -s ~/utils/dotfiles/.vimrc ~/.vimrc
ln -s ~/utils/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/utils/dotfiles/.bash_aliases ~/.bash_aliases

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim &&
cd ~/.vim/bundle && git clone https://github.com/brendonrapp/smyck-vim
