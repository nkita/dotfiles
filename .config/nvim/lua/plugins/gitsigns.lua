return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- gitsigns の設定オプション
    signs = {
      add          = { text = '▎' }, -- 追加された行
      change       = { text = '▎' }, -- 変更された行
      delete       = { text = '▞' }, -- 削除された行 (行の代わりに)
      topdelete    = { text = '▔' }, -- ファイル先頭での削除
      changedelete = { text = '▎' }, -- 変更と削除が混在した行
      untracked    = { text = '┆' }, -- トラッキングされていない行 (通常は表示されない)
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')

      -- gitsigns 固有のキーマップを設定
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- よく使う機能のキーマップ例
      -- <leader>gp: 前の差分へジャンプ
      map('n', '<leader>gp', function() gs.prev_hunk() end, 'Go to Previous Hunk')
      -- <leader>gn: 次の差分へジャンプ
      map('n', '<leader>gn', function() gs.next_hunk() end, 'Go to Next Hunk')
      -- <leader>gl: 差分の内容をポップアップで表示
      map('n', '<leader>gl', gs.preview_hunk, 'Preview Hunk')
      -- <leader>gr: 差分を元に戻す (リバート)
      map('n', '<leader>gr', function() gs.reset_hunk() end, 'Reset Hunk')
      -- <leader>gb: 行の差分を新しいバッファで表示
      map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame Line')
    end,
  },
}
