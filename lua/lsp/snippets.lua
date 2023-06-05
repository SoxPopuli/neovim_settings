local M = {}

-- Imports (as per 'luasnip.txt')
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key
-- 

function M.addSnippets()
    ls.add_snippets("all", {
        s("stirng", t("string")),
        s("Stirng", t("String")),
    })

    ls.add_snippets("fsharp", {
        s("todo", t('failwith "todo"')),
        s('arm', { t('| '), i(1, 'case'), t(' -> '), i(2, '()') }),
        s('pfn', fmt([[printfn $"{}"]], { i(1, 'msg') })),

        s('letfn', fmt([[
        let {} () =
            {}
        ]], { i(1, 'func'), i(2, 'failwith "todo"') })),

        s('union', fmt([[
        type {} =
            | {}
            | {}
        ]], { i(1, 'Union'), i(2, 'A'), i(3, 'B') })),

        s('match', fmt([[
        match {} with
        | {} -> {}
        ]], { i(1, 'cond'), i(2, 'case'), i(3, '()') })),

        s('mem', fmt([[
        member {} {} = 
            {}
        ]], { i(1, 'fn'), i(2, '()'), i(3, 'failwith "todo"') })),

        s('smem', fmt([[
        static member {} {} = 
            {}
        ]], { i(1, 'fn'), i(2, '()'), i(3, 'failwith "todo"') })),
    })
end

return M
