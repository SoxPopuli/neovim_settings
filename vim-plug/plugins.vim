" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'default'
        let g:airline_theme = 'dracula'

    Plug 'preservim/tagbar'
        nmap <F8> :TagbarToggle<CR>

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
        let g:AutoPairsMapCh=0

    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'preservim/nerdcommenter'
        nnoremap <Bslash> <Cmd>:call NERDComment('n', 'Toggle')<CR>
    
    " autocomplete
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
        let g:coc_snippet_next="<Tab>"

        " use <tab> for trigger completion and navigate to the next complete item
        function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~ '\s'
        endfunction
        
            inoremap <silent><expr> <Tab>
                    \ pumvisible() ? "\<C-n>" :
                    \ <SID>check_back_space() ? "\<Tab>" :
                    \ coc#refresh()

        inoremap <silent><expr> <c-space> coc#refresh()
        nnoremap <Leader>rn <Plug>(coc-rename)
        "inoremap <nowait><expr> <C-j> coc#float#scroll(1)
        "inoremap <nowait><expr> <C-k> coc#float#scroll(0)

        nnoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-k>"
        nnoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-j>"
        inoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        
    " C++ header / source switching
    Plug 'ericcurtin/CurtineIncSw.vim'
        map <F4> <Cmd>:call CurtineIncSw()<CR>

    " syntax highlighting
    Plug 'jackguo380/vim-lsp-cxx-highlight'
        let g:cpp_class_scope_highlight = 1
        let g:cpp_member_variable_highlight = 1
        let g:cpp_class_decl_highlight = 1 

    Plug 'vim-syntastic/syntastic'
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
        let g:syntastic_cpp_checkers = ['clang-tidy']
        let g:syntastic_c_checkers = ['clang-tidy']
        let g:syntastic_cpp_cpplint_exec = 'clang-tidy'
        let g:syntastic_check_on_open = 1
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 0
        let g:syntastic_check_on_wq = 0

    " rainbow brackets
    "Plug 'luochen1990/rainbow'
        "let g:rainbow_active = 1
        "" 206: HotPink
        "let g:rainbow_conf = {
        "\   'guifgs': ['royalblue3', 'Yellow', 'LightGreen'],
        "\   'ctermfgs': ['royalblue3', 'Yellow', 'LightGreen']
        "\}
    
    Plug 'junegunn/rainbow_parentheses.vim'
        let g:rainbow#max_level = 8
        let g:rainbow#pairs = [ ['(', ')'], ['[', ']'], ['{', '}'] ]
        let g:rainbow#blacklist = [15]
        autocmd BufEnter * RainbowParentheses

    Plug 'dracula/vim',{'as':'dracula'}
    Plug 'chrisbra/unicode.vim'
    Plug 'lervag/vimtex'
call plug#end()
