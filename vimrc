set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

"
" Toda lista de plugins deve ser colocada ENTRE os comandos begin() e end()
"
call vundle#begin()

" Vundle se auto-gerencia
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'mustache/vim-mustache-handlebars'

call vundle#end()
filetype plugin indent on

syntax on
set number
set backspace=2
set backspace=indent,eol,start

"
" Atalhos
"
"# Ctrl + n: Ativa a NERDTree
map <C-n> : NERDTreeToggle<CR>
