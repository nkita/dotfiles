-- lua/plugins/lualine.lua

return {
  'nvim-lualine/lualine.nvim',
  -- lualineが依存しているライブラリ
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('lualine').setup({
      options = {
        -- テーマを設定
        theme = 'auto', -- 'auto'にするとNeovimの背景色に合わせて自動で選択されます
        -- コンポーネント間の区切り文字
        component_separators = { left = '', right = '' },
        -- セクション間の区切り文字
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
      },
      sections = {
        -- 左側に表示するコンポーネント
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', path = 1}}, -- path = 1でファイル名のみ表示
        -- 右側に表示するコンポーネント
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
      },
      inactive_sections = {
        lualine_c = {{'filename', path = 1}},
        lualine_x = {'location'},
      },
    })
  end,
}
