return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("Comment").setup({
      -- Ctrl+/ のみを使用するため、デフォルトマッピングは無効化
      mappings = {
        basic = false,
        extra = false,
      },
    })

    -- カスタムキーマップ: Ctrl+/ でコメントアウト
    local api = require("Comment.api")
    
    -- ノーマルモード: 現在行をコメントアウト/解除
    vim.keymap.set("n", "<C-/>", function()
      api.toggle.linewise.current()
    end, { noremap = true, silent = true, desc = "Toggle comment" })
    
    -- ビジュアルモード: 選択範囲をコメントアウト/解除
    vim.keymap.set("v", "<C-/>", function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      api.toggle.linewise(vim.fn.visualmode())
    end, { noremap = true, silent = true, desc = "Toggle comment" })
  end,
}
