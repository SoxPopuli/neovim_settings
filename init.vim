let mapleader = ","
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

"let g:python_host_skip_check=1
"let g:loaded_python3_provider=1

source $HOME/.config/nvim/vim-plug/plugins.vim
colorscheme dracula

set path+=**
set lcs+=space:.

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autowrite
set autowriteall
set linebreak
set breakindent
set smartindent
filetype plugin indent on
filetype indent on

set showmatch
set nowrap
set scrolloff=2

" line numbers
set number
set relativenumber

" enable mouse support
set mouse=nv

" enable terminal debug
packadd termdebug
let g:termdebug_wide=1

" enable ctags
:syntax on

" keybinds
    nnoremap <F1> <Cmd>:nohl<CR>

    noremap  <F2> <Cmd>:set list! \| set list?<CR>
    noremap! <F2> <Cmd>:set list! \| set list?<CR>

    tnoremap <Esc> <C-\><C-n>
    nnoremap <A-z> :set wrap! \| set wrap?<CR>
    map! <C-BS> <C-w>
    map! <C-h> <C-w>
    
    "Ctrl-Z undo
    "noremap <C-z> <Cmd>:undo<CR>
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

    "Namespace helper
    inoremap <C-l> ::

    "Undo Tab
    inoremap <S-Tab> <C-D>
