-- キーマップ設定

-- クリップボード設定（システムクリップボードを使用）
vim.opt.clipboard = "unnamedplus"

-- Ctrl+C でビジュアルモード選択範囲をシステムクリップボードにコピー
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

-- Ctrl+Q で全てのウィンドウを閉じる（:qa と同じ）
vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>", { noremap = true, silent = true, desc = "Quit all windows" })

-- 追加のキーマップをここに記述
-- 例：
-- vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { noremap = true, silent = true, desc = "Save file" })
