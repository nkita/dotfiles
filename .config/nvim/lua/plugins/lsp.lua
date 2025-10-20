-- /Users/nkita/dotfiles/.config/nvim/lua/plugins/lsp.lua

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    require("neodev").setup()

    -- 診断表示の設定
    vim.diagnostic.config({
      virtual_text = false,       -- インライン表示を無効化
      signs = true,             -- サイン表示を有効化
      underline = true,         -- 下線表示を有効化
      update_in_insert = false, -- 入力中は更新しない
      severity_sort = true,     -- 重要度順にソート
      float = {
        source = "always",      -- ソース情報を常に表示
        border = "rounded",     -- 角丸枠
        header = "",            -- ヘッダーを空にしてシンプルに
        prefix = "",            -- プレフィックスを空にしてシンプルに
        focusable = true,       -- フローティングウィンドウにフォーカス可能
      },
    })

    -- グローバルキーマップ（診断表示）
    vim.keymap.set("n", "gl", function()
      vim.diagnostic.open_float(nil, {
        scope = "line",           -- 行全体の診断を表示
        focus = false,            -- フローティングウィンドウにフォーカスしない
        border = "rounded",       -- 角丸の枠線
        source = "if_many",       -- 複数のソースがある場合のみソース名を表示
      })
    end, { noremap = true, silent = true, desc = "Show line diagnostics" })

    -- グローバルキーマップ（LSP機能 - LSPがアタッチされていれば動作）
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "Go to declaration" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "Go to implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "Show references" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover documentation" })
    
    -- 診断一覧をQuickfixリストに表示
    vim.keymap.set("n", "<leader>q", function()
      vim.diagnostic.setqflist({ open = true })
    end, { noremap = true, silent = true, desc = "Diagnostics to Quickfix" })

    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- エラー・診断のナビゲーション
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      
      -- その他のLSP機能はグローバルに設定済み
      -- 必要に応じてバッファ固有の設定をここに追加
    end

    require("mason").setup({
      ui = {
        ensure_installed = {
          -- LSP Servers
          "typescript-language-server",
          "pyright",
          "html-lsp",
          "css-lsp",
          "emmet-ls",
          "lua-language-server",
          -- Debug Adapters
          "js-debug-adapter",
          -- Linters/Formatters
          "prettier",
          "eslint_d",
        }
      }
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("mason-lspconfig").setup({
      handlers = {
        -- すべてのサーバーに共通の設定を適用
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
      }
    })

  end,

}
