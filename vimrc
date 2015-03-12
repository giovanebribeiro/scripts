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
Plugin 'ervandew/supertab'
Plugin 'tir_black'
Plugin 'jnurmine/Zenburn'
Plugin 'nathanaelkane/vim-indent-guides'

call vundle#end()
filetype plugin indent on

syntax on
set number
set backspace=2
set backspace=indent,eol,start

" Color Scheme, identation, etc
set t_Co=256
colors zenburn
set ts=2 sw=2 et
let g:indent_guides_auto_colors=0
autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd guibg=black ctermbg=235
autocmd VimEnter,ColorScheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=237
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
    
"
" Atalhos
"
"# Ctrl + n: Ativa a NERDTree
map <C-n> :NERDTreeToggle<CR>
"# Ctrl + i: Ativa a identacao
map <C-i> :IndentGuidesToggle<CR> 
