-- lua/plugins/cmp.lua

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets", -- (任意) スニペット集
		"onsails/lspkind-nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		-- friendly-snippetsなどのスニペットをロードする
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			-- 補完ソースの指定
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),

			-- スニペットの展開設定
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- キーマップの設定
			mapping = cmp.mapping.preset.insert({
				-- Tabで補完候補を選択
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				-- Enterで補完を確定
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				-- Ctrl+Spaceで手動で補完をトリガー
				["<C-Space>"] = cmp.mapping.complete(),
			}),

			-- (任意) 見た目の設定
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			formatting = {
				format = lspkind.cmp_format({
					with_text = true, -- 補完候補のテキストを表示 (trueに設定)
					menu = {
						buffer = "[buf]",
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						path = "[path]",
					},
				}),
			},
		})
	end,
}
