-- which-key.nvim: キーマップのポップアップ表示
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- デフォルト設定
		icons = {
			breadcrumb = "»", -- 階層の区切り
			separator = "➜", -- キーと説明の区切り
			group = "+", -- グループの表示
		},
		win = {
			border = "rounded", -- ウィンドウの枠線スタイル
			padding = { 1, 2, 1, 2 },
		},
		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- グループ名の登録
		wk.add({
			{ "<leader>f", group = "Find (Telescope)" },
			{ "<leader>g", group = "Git" },
			{ "<leader>y", group = "Yank (Copy Path)" },
		})
	end,
}
