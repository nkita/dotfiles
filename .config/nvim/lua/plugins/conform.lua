-- lua/plugins/conform.lua など

return {
	"stevearc/conform.nvim",
	-- ft (filetype) をトリガーにして、関連ファイルを開いたときに初めてロードする
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"html",
		"css",
		"scss",
		"json",
		"yaml",
		"markdown",
		"lua",
		-- 他にフォーマットしたいファイルタイプがあれば追加
	},
	-- lazy.nvimでは config = function() ... end よりも opts = { ... } を使うのが推奨
	opts = {
		-- フォーマッターの定義
		formatters_by_ft = {
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			vue = { "prettierd" },
			svelte = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			lua = { "stylua" },
		},

		-- 自動フォーマットは無効（手動のみ）
		-- format_on_save = {
		--   timeout_ms = 500,
		--   lsp_fallback = true,
		-- },
	},
	-- config関数を使って、プラグインがロードされた後にキーマップを設定する
	config = function(_, opts)
		require("conform").setup(opts)

		-- 手動フォーマットのキーマップ
		vim.keymap.set({ "n", "v" }, "<leader>i", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, { desc = "Format buffer" })
	end,
}
