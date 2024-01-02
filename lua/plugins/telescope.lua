local function project_files()
  local builtins = require('telescope.builtin')
  local opts = {} -- define here if you want to define something
  if GIT_DIR then
    builtins.git_files(opts)
  else
    builtins.find_files(opts)
  end
end

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    lazy = true,
    cmd = 'Telescope',

    keys = {
      { '<C-p>', project_files },
      {
        '<A-p>',
        function()
          require('telescope.builtin').find_files()
        end,
      },
      {
        '<A-g>',
        function()
          require('telescope.builtin').live_grep()
        end,
      }, -- requires ripgrep
      {
        '<C-b>',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'Search buffers',
      },
      {
        '<leader>r',
        function()
          require('telescope.builtin').resume()
        end,
        desc = 'Resume Telescope',
      },
      {
        '<leader>th',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = 'Search help',
      },
      {
        '<leader>tr',
        function()
          require('telescope.builtin').reloader()
        end,
        desc = 'Module reloader',
      },
      {
        '<leader>tt',
        function()
          require('telescope.builtin').treesitter()
        end,
        desc = 'Search treesitter nodes',
      },
      {
        '<leader>tg',
        function()
          require('telescope.builtin').git_branches()
        end,
        desc = 'Search git branches',
      },
      {
        '<space>s',
        function()
          require('telescope.builtin').spell_suggest()
        end,
        desc = 'Spelling suggestions',
      },
    },

    config = function()
      local telescope = require('telescope')
      local telescope_config = require('telescope.config')
      -- local actions = require('telescope.actions')
      local action_layout = require('telescope.actions.layout')
      local builtins = require('telescope.builtin')
      local previewers = require('telescope.previewers')
      local putils = require('telescope.previewers.utils')
      -- local pfiletype = require("plenary.filetype")

      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, '--hidden')
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!**/.git/*')

      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}

        -- Force fsharp highlighting for .fs files
        if filepath:find([[.+%.fs$]]) ~= nil then
          local ft = 'fsharp'
          opts.use_ft_detect = false
          putils.regex_highlighter(bufnr, ft)
        end

        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end

      telescope.setup({
        defaults = {
          -- Default configuration for telescope goes here:
          -- config_key = value,
          buffer_previewer_maker = new_maker,
          vimgrep_arguments = vimgrep_arguments,
          mappings = {
            n = {
              ['<M-p>'] = action_layout.toggle_preview,
            },
            i = {
              -- map actions.which_key to <C-h> (default: <C-/>)
              -- actions.which_key shows the mappings for your picker,
              -- e.g. git_{create, delete, ...}_branch for the git_branches picker
              -- ["<Esc>"] = actions.close,
              ['<C-h>'] = 'which_key',
              ['<M-p>'] = action_layout.toggle_preview,
            },
          },
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
        },
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
        },
      })

      local function is_git_dir()
        vim.fn.system('git rev-parse --is-inside-work-tree')
        return vim.v.shell_error == 0
      end

      GIT_DIR = is_git_dir()

      telescope.load_extension('ui-select')
    end,
  },

  {
    'nvim-telescope/telescope-ui-select.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    lazy = true,

    init = function()
      vim.ui.select = function(items, opts, on_choice)
        require('telescope') --overrides ui.select

        vim.ui.select(items, opts, on_choice)
      end
    end,
  },
}
