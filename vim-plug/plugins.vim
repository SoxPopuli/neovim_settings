" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

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
        
    " C++ header / source switching
    Plug 'ericcurtin/CurtineIncSw.vim'
        map <F4> <Cmd>:call CurtineIncSw()<CR>

    " syntax highlighting
    Plug 'jackguo380/vim-lsp-cxx-highlight'
        let g:cpp_class_scope_highlight = 1
        let g:cpp_member_variable_highlight = 1
        let g:cpp_class_decl_highlight = 1 

    Plug 'vim-syntastic/syntastic'
        let g:syntastic_cpp_checkers = ['clang-tidy']
        let g:syntastic_c_checkers = ['clang-tidy']
        let g:syntastic_cpp_cpplint_exec = 'clang-tidy'
        " The following two lines are optional. Configure it to your liking!
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0

    " rainbow brackets
    Plug 'luochen1990/rainbow'
        let g:rainbow_active = 1

    Plug 'dracula/vim',{'as':'dracula'}

call plug#end()