let mapleader = ","
source $HOME/.config/nvim/vim-plug/plugins.vim

colorscheme dracula

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autowrite
set autowriteall
set linebreak
set breakindent

set showmatch
set nowrap
set scrolloff=2

" line numbers
set number
set relativenumber

" enable mouse support
set mouse=a

" enable terminal debug
packadd termdebug

" enable ctags
:syntax on

" keybinds
    nnoremap <F1> <Cmd>:nohl<CR>
    tnoremap <Esc> <C-\><C-n>
    nnoremap <A-z> :set wrap! \| set wrap?<CR>
    map! <C-BS> <C-w>
    map! <C-h> <C-w>
    
    "Ctrl-Z undo
    noremap <C-z> <Cmd>:undo<CR>
    inoremap <C-z> <Cmd>:undo<CR>
    
    "Ctrl-S save
    noremap <C-s> <Cmd>:w<CR>
    inoremap <C-s> <Cmd>:w<CR>
    
    "Alt-Directon switch window
    nnoremap <A-Up> <C-w><Up>
    nnoremap <A-Down> <C-w><Down>
    nnoremap <A-Left> <C-w><Left>
    nnoremap <A-Right> <C-w><Right>
    nnoremap <A-k> <C-w>k
    nnoremap <A-j> <C-w>j
    nnoremap <A-h> <C-w>h
    nnoremap <A-l> <C-w>l
