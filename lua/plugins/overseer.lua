return {
  {
    'stevearc/overseer.nvim',

    config = function()
      local overseer = require('overseer')
      overseer.setup({})

      require('dap.ext.vscode').json_decode = require('overseer.json').decode
    end,

    cmd = {
      'OverseerToggle',
      'OverseerRun',
      'OverseerInfo',
      'OverseerOpen',
      'OverseerBuild',
      'OverseerClose',
      'OverseerRunCmd',
      'OverseerClearCache',
      'OverseerLoadBundle',
      'OverseerSaveBundle',
      'OverseerTaskAction',
      'OverseerQuickAction',
      'OverseerDeleteBundle',
    },
  },
}
