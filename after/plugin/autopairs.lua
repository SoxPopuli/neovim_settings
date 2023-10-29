local npairs = require("nvim-autopairs")
npairs.setup({
      disable_in_visualblock = true,
      fast_wrap = {},
   })

--local has_npairs, npairs               = pcall(require, 'nvim-autopairs')
local has_cmp_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
local has_cmp, cmp = pcall(require, "cmp")
local has_Rule, Rule = pcall(require, "nvim-autopairs.rule")
local has_cond, cond = pcall(require, "nvim-autopairs.conds")

if not (has_cmp_autopairs and has_cmp and has_Rule and has_cond) then
   return
end

if not AutopairsConfigSet then
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
   AutopairsConfigSet = true
end

-- Add space between brackets
local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
npairs.add_rules({
      Rule(" ", " "):with_pair(function(opts)
         local pair = opts.line:sub(opts.col - 1, opts.col)
         return vim.tbl_contains({
               brackets[1][1] .. brackets[1][2],
               brackets[2][1] .. brackets[2][2],
               brackets[3][1] .. brackets[3][2],
            }, pair)
         end),
      })
   for _, bracket in pairs(brackets) do
      npairs.add_rules({
            Rule(bracket[1] .. " ", " " .. bracket[2])
               :with_pair(function()
                  return false
               end)
                  :with_move(function(opts)
                     return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                  end)
                     :use_key(bracket[2]),
               })
         end
