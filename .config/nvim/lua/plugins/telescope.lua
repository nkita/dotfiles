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
    -- ファイル検索: <leader>f でプロジェクト内のファイルを検索
    {"<C-p>", function() require("telescope.builtin").find_files() end, desc = "Find Files"},
    -- Grep検索: <leader>r でカレントディレクトリからテキストを検索
    {"<C-f>", function() require("telescope.builtin").live_grep() end, desc = "Live Grep"},
    -- 診断一覧: <leader>fd で診断を表示
    {"<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics"},
    -- 現在のバッファのみの診断: <leader>fD
    {"<leader>fD", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end, desc = "Buffer Diagnostics"},
    -- LSPシンボル検索: <leader>fs でファイル内のシンボル（関数、変数など）を検索
    {"<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols"},
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
      hidden = true,  -- 隠しファイル・ディレクトリを表示
      follow = true,  -- シンボリックリンクを追跡
    },
    -- live_grep など他のピッカーにも適用できます
    live_grep = {
      sorter = sorters.get_fuzzy_file_sorter,
      additional_args = function()
        return { "--hidden" }  -- ripgrepで隠しファイルも検索
      end,
    }
  }
      -- ここに他の拡張機能の設定を追加
      -- extensions = {
      --   -- 例: "fzf" = { ... }
      -- }
    })
  end,
}
