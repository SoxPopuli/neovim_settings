"auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

"    Plug 'vimsence/vimsence' " Vim rich presence :^)
"        let g:vimsence_discord_flatpak=1

"    Plug 'vim-airline/vim-airline'
"    Plug 'vim-airline/vim-airline-themes'
"        let g:airline#extensions#tabline#enabled = 1
"        let g:airline#extensions#tabline#formatter = 'default'
"        let g:airline_theme = 'dracula'


    Plug 'feline-nvim/feline.nvim'
    Plug 'kyazdani42/nvim-web-devicons'



    Plug 'preservim/tagbar'
        nmap <F8> :TagbarToggle<CR>

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update


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
        "nnoremap <Bslash> <Cmd>:call NERDComment('n', 'Toggle')<CR>
        nmap <Bslash> <plug>NERDCommenterToggle
        vmap <Bslash> <plug>NERDCommenterToggle
    
    " autocomplete
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
        let g:coc_snippet_next="<Tab>"

        " use <tab> for trigger completion and navigate to the next complete item
        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        inoremap <silent><expr> <Tab>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()

        inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
        inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

        inoremap <silent><expr> <c-space> coc#refresh()

        nnoremap <Leader>cr <Plug>(coc-rename)
        nnoremap <Leader>rn <Plug>(coc-rename)
        nnoremap <Leader>rf <Plug>(coc-refactor)

        nnoremap <silent> gf <Plug>(coc-definition)
        nnoremap <silent> gc <Plug>(coc-declaration)
        nnoremap <silent> gi <Plug>(coc-declaration)

        nnoremap <silent> g[ <Plug>(coc-diagnostic-prev)
        nnoremap <silent> g] <Plug>(coc-diagnostic-next)
        nnoremap <silent> g, <Plug>(coc-diagnostic-next-error)
        nnoremap <silent> g. <Plug>(coc-diagnostic-next-error)

        nnoremap <silent> <Leader>f <Plug>(coc-float-hide)
        nnoremap <Leader>k :call CocActionAsync('diagnosticInfo') <CR>

        nnoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-k>"
        nnoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-j>"
        inoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        
    " C++ header / source switching
    Plug 'ericcurtin/CurtineIncSw.vim'
        map <F4> <Cmd>:call CurtineIncSw()<CR>

"    "syntax highlighting
"    Plug 'jackguo380/vim-lsp-cxx-highlight'
"        "let g:lsp_cxx_hl_use_text_props = 1
"        let g:cpp_class_scope_highlight = 1
"        let g:cpp_member_variable_highlight = 1
"        let g:cpp_class_decl_highlight = 1 


    Plug 'vim-syntastic/syntastic'
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*

        let g:syntastic_check_on_open = 1
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 0
        let g:syntastic_check_on_wq = 0

        let g:syntastic_cpp_checkers = ['clang-tidy']
        let g:syntastic_cpp_cpplint_exec = 'clang-tidy'
        let g:syntastic_c_checkers = ['clang-tidy']
        let g:syntastic_cpp_compiler_options = '-std=c++2a'

        let g:syntastic_tex_checkers = ['chktex']

    

    "Plug 'junegunn/rainbow_parentheses.vim'
        "let g:rainbow#max_level = 32
        "let g:rainbow#pairs = [ ['(', ')'], ['[', ']'], ['{', '}'] ]
        "let g:rainbow#blacklist = [15]
        "autocmd BufEnter * RainbowParentheses

    Plug 'p00f/nvim-ts-rainbow'

    Plug 'dracula/vim',{'as':'dracula'}
    Plug 'chrisbra/unicode.vim'
    Plug 'lervag/vimtex'
call plug#end()

lua <<EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "rust", }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "javascript" }, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        -- disable = { "rust" },  -- list of language that will be disabled
        },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
        colors = {
            '#8ff0a4',
            '#dc143c',
            '#33ccff',
            '#ff7800',
            '#ee82ee',
            '#ffd700',
            '#7fff00',
            }
        }
    }

local components = {
    active = {},
    inactive = {},
}

local background_color = '#1f1f23'

-- Insert three sections (left, mid and right) for the active statusline
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

-- Insert two sections (left and right) for the inactive statusline
table.insert(components.inactive, {})
table.insert(components.inactive, {})

table.insert(components.active[1], { 
    provider = '▊',
    hl = {
        fg = '#50b0f0',
        bg = background_color,
    },
    right_sep = {
        str = ' ',
        hl = {
            bg = background_color,
        }
    }
})

table.insert(components.active[1], { 
    provider = 'vi_mode',
    hl = function()
        return {
            name = require('feline.providers.vi_mode').get_mode_highlight_name(),
            fg = require('feline.providers.vi_mode').get_mode_color(),
            style = 'bold'
        }
    end,
    left_sep = ' ',
    right_sep = ' ',
    -- Uncomment the next line to disable icons for this component and use the mode name instead
    -- icon = ''

})

local black_spacer = { str = ' ', hl = { bg = background_color} }
local blue_spacer = { str = ' ', hl = { bg = '#0066cc' } }

table.insert(components.active[1], { 
    provider = 'file_info',
    hl = {
        fg = 'white',
        bg = '#0066cc',
        style = 'bold'
    },
    left_sep = { 'slant_left_2', blue_spacer },
    right_sep = { blue_spacer, 'slant_right_2' },
})
table.insert(components.active[1], { 
    provider = 'position',
    left_sep = { black_spacer, 'slant_left_2' },
    right_sep = 'slant_right_2',
})


-- Right active
local function coc_diag(type, icon, color)
    return { 
        provider = function()
            info = vim.b.coc_diagnostic_info
            if info ~= nil and info[type] ~= nil and info[type] > 0 then
                return icon .. ' ' .. tostring(info[type])
            else
                return ''
            end
        end,
        update = { 'CocDiagnosticChange' },
        left_sep = {
            { str = 'slant_left_2', hl = { fg = color } },
            { str = ' ', hl = { bg = color } }, 
        },
        right_sep = {
            { str = ' ', hl = { bg = color } },
            { str = 'slant_right', hl = { fg = color  } },
        },
        hl = {
            fg = 'white',
            bg = color,
            -- style = 'bold',
        }
    }
end

table.insert(components.active[3], coc_diag('error', '', '#dc143c'))
table.insert(components.active[3], coc_diag('warning', '', '#daa520'))
table.insert(components.active[3], coc_diag('hint', '', '#0066cc'))
table.insert(components.active[3], { 
    provider = function() 
        status = vim.g.coc_status
        if status ~= nil then
            return status
        else
            return ''
        end
    end,
    right_sep = { black_spacer, { str = 'right', hl = { fg = 'white' } }, black_spacer },
    update = { 'CocStatusChange' }
})
table.insert(components.active[3], {
    provider = 'line_percentage',
    hl = { style = 'bold', },
    left_sep = ' ',
    right_sep = ' ',
})
table.insert(components.active[3], {
    provider = 'scroll_bar',
    hl = {
        fg = '#50b0f0',
        bg = '#1f1f23',
    },
})


-- inactive
table.insert(components.inactive[1], {
    provider = ' ',
    hl = {
        fg = 'white',
        bg = '#0066cc',
        style = 'bold',
    },
})
table.insert(components.inactive[1], {
    provider = 'file_type',
    hl = {
        fg = 'white',
        bg = '#0066cc',
        style = 'bold',
    },
    right_sep = { blue_spacer, 'slant_right_2' },
})

require('feline').setup {
    components = components,
}

require('nvim-web-devicons').setup {
    color_icons = true,
    default = true,
}
EOF



augroup hl
    autocmd!
    autocmd BufEnter *.cpp,*.hpp hi! def link TSNamespace String
    autocmd BufEnter *.cpp,*.hpp hi! def link TSProperty TSField
    autocmd BufEnter *.cpp,*.hpp hi! TSPunctBracket ctermfg=0
augroup END
