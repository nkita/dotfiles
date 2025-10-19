return {
  -- 1. Telescope 本体
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8', -- 最新の安定版ブランチを指定
  dependencies = {
    -- 必須依存プラグイン
    'nvim-lua/plenary.nvim',
    -- 高速化のため、オプションでfzfを導入
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  },
  -- 2. キーマップの設定 (遅延読み込みの設定を兼ねる)
  keys = {
    -- ファイル検索: <leader>ff でプロジェクト内のファイルを検索
    {"<leader>f", function() require("telescope.builtin").find_files() end, desc = "Find Files"},
    -- Grep検索: <leader>fg でカレントディレクトリからテキストを検索
    {"<leader>g", function() require("telescope.builtin").live_grep() end, desc = "Live Grep"},
    -- 開いているバッファ検索: <leader>fb
    {"<leader>b", function() require("telescope.builtin").buffers() end, desc = "Find Buffers"},
    -- ヘルプタグ検索: <leader>fh
    {"<leader>h", function() require("telescope.builtin").help_tags() end, desc = "Help Tags"},
  },
  -- 3. 詳細設定 (オプション)
  config = function()
    -- fzf-native 拡張機能のロード (インストールしている場合)
  local sorters = require("telescope.sorters")
    pcall(require("telescope").load_extension, "fzf")
    -- グローバルなデフォルト設定
    require("telescope").setup({
      defaults = {
        -- 例: レイアウトを画面の95%に拡大
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.95,
            height = 0.95,
          },
        },
	path_display = { 'absolute' }, -- 'absolute', 'relative', 'filename' から選択
	file_sorter = sorters.get_fuzzy_file_sorter,
        -- ファイル無視パターン
        file_ignore_patterns = {
          "node_modules",
          "%.git/",
          "%.venv/",
        },
      },
      pickers = {
    -- find_files の結果にソート設定を適用
    find_files = {
      sorter = sorters.get_fuzzy_file_sorter,
    },
    -- live_grep など他のピッカーにも適用できます
    live_grep = {
      sorter = sorters.get_fuzzy_file_sorter,
    }
  }
      -- ここに他の拡張機能の設定を追加
      -- extensions = {
      --   -- 例: "fzf" = { ... }
      -- }
    })
  end,
}
