return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- アイコン表示に必要
  opts = {
    options = {
      -- ここに各種オプションを設定します
      close_command = "Bdelete! %", -- バッファを閉じるコマンド
      separator_style = "slant",   -- セパレーターのスタイル ('slant' または 'thin')
      always_show_bufferline = false, -- バッファが1つでも表示するか
    },
  },
  keys = {
    -- バッファ切り替えのキーマップ例
    { '<C-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev Buffer' },
    { '<C-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next Buffer' },
  }
}
