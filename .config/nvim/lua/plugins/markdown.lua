return {
	-- 軽量・安全なMarkdownプレビュー（Glow推奨）
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		ft = { "markdown" },
		config = function()
			require("glow").setup({
				style = "dark",
				width = 120,
			})
			vim.keymap.set("n", "<leader>md", ":Glow<CR>", { desc = "Markdown Preview (Glow)" })
			vim.keymap.set("n", "<leader>mp", ":Glow<CR>", { desc = "Markdown Preview" })
		end,
	},

	-- オプション：重いがリッチなブラウザプレビュー（必要時のみ有効化）
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	ft = { "markdown" },
	-- 	build = function() vim.fn["mkdp#util#install"]() end,
	-- 	config = function()
	-- 		vim.g.mkdp_auto_start = 0
	-- 		vim.g.mkdp_auto_close = 1
	-- 		vim.g.mkdp_theme = "dark"
	-- 		vim.keymap.set("n", "<leader>mbp", "<Plug>MarkdownPreviewToggle", { desc = "Browser Preview" })
	-- 	end,
	-- },

	-- Markdown編集支援（軽量）
	{
		"bullets-vim/bullets.vim",
		ft = { "markdown", "text", "gitcommit" },
		config = function()
			vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
		end,
	},
}