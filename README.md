# dotfiles

全環境共通の設定とPC個別の設定を管理するためのdotfiles構成です。

## Quick Start

すぐに使い始めたい場合は、以下のコマンドを実行してください：

```bash
# 1. 依存関係をインストール
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-completions jandedobbeleer/oh-my-posh/oh-my-posh fzf ripgrep neovim eza lazygit git-delta
brew install --cask font-hack-nerd-font

# 2. dotfilesをクローンしてセットアップ
git clone https://github.com/nkita/dotfiles.git
cd dotfiles
./install.sh

# 3. 設定を反映
source ~/.zshrc
```

ターミナルのフォントをHack Nerd Fontに設定すれば完了です！

## フォルダ構成

```
dotfiles/
├── .zshrc                    # メインの設定ファイル（各設定を読み込む）
├── .gitignore               # PC個別設定を除外
├── install.sh               # セットアップスクリプト
├── amro.omp.json           # oh-my-posh テーマ
├── backup/                  # バックアップフォルダ
│   ├── .gitkeep            # Git管理に含めるためのファイル
│   └── backup_YYYYMMDD_HHMMSS/  # 実際のバックアップ（実行時に作成）
└── zsh/
    ├── common.zsh          # 全環境共通設定
    ├── aliases.zsh         # 共通エイリアス
    └── local/              # PC個別設定フォルダ
        ├── README.md       # 使用方法の説明
        ├── example.zsh     # 設定例
        └── $(hostname).zsh # ホスト名ベースの個別設定
```

## 必要な依存関係

このdotfilesを使用する前に、以下のツールをインストールしてください。

### Homebrew

まず、Homebrewをインストールしてください：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 必須パッケージ

```bash
# zsh拡張機能
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
brew install zsh-completions

# oh-my-posh（プロンプトテーマ）
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# ファイル操作・検索ツール
brew install fzf
brew install ripgrep

# Neovim関連
brew install neovim
brew install glow  # 軽量・安全なMarkdownプレビュー

# Git TUI（lazygit）
brew install lazygit

# Git差分ツール（delta）
brew install git-delta

# 高機能lsコマンド（オプション）
brew install eza
```

### Nerd Fonts

Neovimやoh-my-poshで使用するアイコンフォントをインストール：

```bash
# 例：Hack Nerd Fontをインストール
brew install --cask font-hack-nerd-font

# または他のNerd Font
brew install --cask font-fira-code-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
```

## セットアップ方法

### 新しい環境での初回セットアップ

```bash
git clone https://github.com/nkita/dotfiles.git
cd dotfiles
./install.sh
```

### 設定の反映

```bash
source ~/.zshrc
```

### ターミナル設定

フォントとカラースキームを設定してください：

1. **フォント**: インストールしたNerd Fontを選択
2. **カラースキーム**: お好みのものに変更（tokyonightなど推奨）

### Neovim機能

このdotfilesには以下のNeovim機能が含まれています：

**Git管理（LazyGit）**
```vim
<leader>gg : LazyGit起動
<leader>gf : 現在のファイルの履歴をLazyGitで表示
```

**Markdownプレビュー**
```vim
" Markdownファイルで使用

" ターミナル内プレビュー:
<leader>md : Glowプレビュー
<leader>mp : Glowプレビュー
```

**LSP診断とナビゲーション**
```vim
" エラー・警告の確認
gl          : カーソル行の診断を表示
<leader>fd  : 診断一覧（Telescope）
<leader>fD  : 現在のファイルの診断
<leader>q   : 診断をQuickfixに表示
[d / ]d     : 前/次の診断へジャンプ

" コードナビゲーション
gd          : 定義へジャンプ（エイリアス対応）
gD          : 宣言へジャンプ
gi          : 実装へジャンプ
gr          : 参照一覧
K           : ホバー情報を表示
```

**Node.jsデバッグ**
```vim
" JavaScriptファイルで使用
F5      : デバッグ開始/継続
F1      : ステップイン
F2      : ステップオーバー
F3      : ステップアウト
F7      : デバッグUIの表示/非表示
<leader>b : ブレークポイント切り替え
```

## 更新・メンテナンス

### dotfilesの更新

```bash
# dotfilesディレクトリに移動
cd ~/dotfiles

# 最新版を取得
git pull origin main

# 設定を反映（ターミナルを再起動するか以下を実行）
source ~/.zshrc
```

### 設定変更の反映

設定ファイルを編集した後の反映方法：

**共通設定を変更した場合**
```bash
# zsh/common.zsh や zsh/aliases.zsh を編集後
source ~/.zshrc
```

**PC個別設定を変更した場合**
```bash
# zsh/local/$(hostname -s).zsh を編集後
source ~/.zshrc
# または
source ~/dotfiles/zsh/local/$(hostname -s).zsh
```

**Neovim設定を変更した場合**
```bash
# .config/nvim/ 以下を変更後、Neovim内で
:Lazy sync
# Mason管理のツールを更新
:MasonInstallAll
# または Neovimを再起動
```

### 設定のバックアップ

**大幅な変更前にバックアップを作成**
```bash
cd ~/dotfiles
./backup-config.sh
```

**バックアップファイルの確認**
```bash
# バックアップファイルの確認
ls ~/dotfiles/backup/

# 設定を復元（例）
cp ~/dotfiles/backup/config_backup_20241020_143022/.zshrc ~/dotfiles/
```

## PC個別設定の追加

```bash
# 現在のPC用の設定ファイルを編集
vim ~/dotfiles/zsh/local/$(hostname -s).zsh

# または example.zsh をコピーして作成
cd ~/dotfiles/zsh/local
cp example.zsh $(hostname -s).zsh
vim $(hostname -s).zsh
```

## 設定の仕組み

1. **.zshrc**: 各設定ファイルを順次読み込む
2. **zsh/common.zsh**: 全環境で使う基本設定
3. **zsh/aliases.zsh**: 全環境共通のエイリアス
4. **zsh/local/$(hostname).zsh**: PC固有の設定

## バックアップについて

install.sh実行時に既存の設定ファイルは自動的にbackupフォルダにバックアップされます。

### バックアップファイルの命名規則

```
backup_YYYYMMDD_HHMMSS/
├── .zshrc
└── その他のファイル...
```

### バックアップからの復元

```bash
# 間違って設定を変更してしまった場合
cp backup/backup_20241020_143022/.zshrc ~/.zshrc
```

## トラブルシューティング

### よくある問題

**プロンプトが正しく表示されない**
```bash
# Nerd Fontがインストールされているか確認
# ターミナルでフォント設定を確認してください
```

**zshプラグインが動作しない**
```bash
# パッケージがインストールされているか確認
brew list | grep -E "(zsh-autosuggestions|zsh-syntax-highlighting|zsh-completions)"

# パスが正しいか確認
echo $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

**Neovimでアイコンが表示されない**
```bash
# Nerd Fontが設定されているか確認
# ripgrepがインストールされているか確認
rg --version
```

## この構成のメリット

- **明確な分離**: 共通設定と個別設定が分かれている
- **Git安全**: 個別設定はGitに含まれない（機密情報も安心）
- **自動化**: ホスト名で自動的に個別設定を読み込む
- **拡張性**: 新しい設定ファイルを簡単に追加できる
- **保守性**: 各設定の役割が明確
- **セキュリティ重視**: 不要なNode.js依存を排除し軽量・安全な構成

## セキュリティポリシー

- **依存関係最小化**: 必要最小限のパッケージのみインストール
- **定期更新**: Homebrewパッケージの定期更新を推奨
- **軽量設計**: Neovimプラグインは軽量で安全なものを優先選択
