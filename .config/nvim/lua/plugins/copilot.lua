return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Copilotを有効化
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    
    -- キーマップ設定
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
    
    -- その他のキーマップ
    vim.keymap.set("i", "<C-H>", "<Plug>(copilot-dismiss)", { silent = true })
    vim.keymap.set("i", "<C-L>", "<Plug>(copilot-next)", { silent = true })
    vim.keymap.set("i", "<C-K>", "<Plug>(copilot-previous)", { silent = true })
  end,
}
