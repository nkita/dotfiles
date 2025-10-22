return {
	"nvim-tree/nvim-tree.lua",
	lazy = false, -- すぐにロードされるように設定
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- ファイルアイコンの表示に必要
	},

	-- 2. 設定とキーマップ
	config = function()
		-- Neovim組み込みのファイラ(netrw)を無効化（競合を避けるため必須）
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- nvim-tree の設定
		require("nvim-tree").setup({
			view = {
				side = "left", -- ツリーを左側に表示
			},
			git = {
				enable = true, -- Gitサポートを有効にする
				ignore = false, -- .gitignoreで無視されたファイルをツリーに表示するかどうか
				-- markers: 変更ステータスごとに表示する文字をカスタマイズできます
			},
			renderer = {
				root_folder_label = false, -- 親ディレクトリ名を非表示にする（よりシンプルに）
				icons = {
					--          show_only_dir_icons = true, -- ディレクトリのアイコンのみ表示
				},
			},
			actions = {
				open_file = {
					-- ファイルを開いたときにツリーを自動的に閉じる
					quit_on_open = false,
				},
			},
			-- その他の設定...
		})

		-- 3. ツリーの開閉キーマップ
		-- Ctrl+E でツリーを開閉
		vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })
	end,
}
