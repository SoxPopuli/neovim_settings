local telescope = require('telescope')
local telescope_config = require("telescope.config")
-- local actions = require('telescope.actions')
local action_layout = require("telescope.actions.layout")
local builtins = require('telescope.builtin')
local previewers = require('telescope.previewers')
local putils = require("telescope.previewers.utils")
-- local pfiletype = require("plenary.filetype")

require("telescope").setup {
  defaults = {
    buffer_previewer_maker = new_maker,
  }
}

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

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

telescope.setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    buffer_previewer_maker = new_maker,
    vimgrep_arguments = vimgrep_arguments,
    mappings = {
      n = {
        ["<M-p>"] = action_layout.toggle_preview,
      },
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ["<Esc>"] = actions.close,
        ["<C-h>"] = "which_key",
        ["<M-p>"] = action_layout.toggle_preview,
      }
    }
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
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

local function is_git_dir()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  return vim.v.shell_error == 0
end

GIT_DIR = is_git_dir()

local function project_files()
  local opts = {} -- define here if you want to define something
  if GIT_DIR then
    builtins.git_files(opts)
  else
    builtins.find_files(opts)
  end
end

vim.keymap.set('n', '<C-p>', function() project_files() end)
vim.keymap.set('n', '<A-p>', function() builtins.find_files() end)
vim.keymap.set('n', '<A-g>', function() builtins.live_grep() end) -- requires ripgrep
vim.keymap.set('n', '<leader>r', function() builtins.resume() end, { desc = "Resume Telescope" })
vim.keymap.set('n', '<leader>tb', function() builtins.buffers() end, { desc = "Search buffers" })
vim.keymap.set('n', '<leader>th', function() builtins.help_tags() end)
vim.keymap.set('n', '<leader>tr', function() builtins.reloader() end)
vim.keymap.set('n', '<leader>tt', function() builtins.treesitter() end)
vim.keymap.set('n', '<leader>tg', function() builtins.git_branches() end)
vim.keymap.set('n', '<space>s', function() builtins.spell_suggest() end)
