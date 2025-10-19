return {
  "folke/tokyonight.nvim",
  lazy = false, -- カラースキームはすぐにロードされるようにする
  priority = 1000, -- 他のプラグインより先にロードされるように優先度を高くする
  opts = {
    style = "moon", -- 'night', 'moon', 'storm', 'day' から好きなスタイルを選択
    transparent = true, -- 背景を透過させたい場合は true に
    -- その他の設定はオプションです
    -- styles = {
    --   comments = { italic = true },
    --   keywords = { italic = true }
    -- },
  },
  config = function(_, opts)
    -- tokyonight.nvim をセットアップ
    require("tokyonight").setup(opts)
    -- カラースキームを適用
    vim.cmd.colorscheme("tokyonight")
  end,
}
