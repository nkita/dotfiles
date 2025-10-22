-- キーマップ設定

-- クリップボード設定（システムクリップボードを使用）
vim.opt.clipboard = "unnamedplus"

-- Ctrl+C でビジュアルモード選択範囲をシステムクリップボードにコピー
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

-- Ctrl+Q で全てのウィンドウを閉じる（:qa と同じ）
vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { noremap = true, silent = true, desc = "Quit all windows" })

-- ファイルパスのコピー
-- <leader>yf: ファイル名（またはディレクトリ名）
vim.keymap.set("n", "<leader>yf", function()
	local filename = vim.fn.expand("%:t")
	if filename == "" then
		filename = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end
	vim.fn.setreg("+", filename)
	print("Copied to clipboard: " .. filename)
end, { noremap = true, silent = true, desc = "Copy filename to clipboard" })

-- <leader>yr: 相対パス
vim.keymap.set("n", "<leader>yr", function()
	local relative_path = vim.fn.expand("%:.")
	if relative_path == "" then
		relative_path = "."
	end
	vim.fn.setreg("+", relative_path)
	print("Copied to clipboard: " .. relative_path)
end, { noremap = true, silent = true, desc = "Copy relative path to clipboard" })

-- <leader>ya: 絶対パス
vim.keymap.set("n", "<leader>ya", function()
	local absolute_path = vim.fn.expand("%:p")
	if absolute_path == "" then
		absolute_path = vim.fn.getcwd()
	end
	vim.fn.setreg("+", absolute_path)
	print("Copied to clipboard: " .. absolute_path)
end, { noremap = true, silent = true, desc = "Copy absolute path to clipboard" })

-- 追加のキーマップをここに記述
-- 例：
-- vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { noremap = true, silent = true, desc = "Save file" })
