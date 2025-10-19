return {
  'stevearc/conform.nvim',
  lazy = false,

  opts = {
    -- 1. フォーマッターの定義
    formatters_by_ft = {
      -- ... あなたのフォーマッター設定 ...
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'jq' },
      -- HTMLやCSSもフォーマットしたい場合は追加
      html = { 'prettier' },
      css = { 'prettier' },	
    },
    
    -- 2. 自動フォーマットの設定
    format_on_save = {
      -- ... あなたの format_on_save 設定 ...
      async = true,
      lsp_format = 'fallback',
    },
  },
  
  -- ✅ ここに keys テーブルを追加します
  keys = {
    -- n (ノーマル), v (ビジュアル) モードで <leader>fm を format 関数にマップ
    { '<leader>i', function() require('conform').format() end, mode = { 'n', 'v' }, desc = 'Format file or selection' },
  },
}
