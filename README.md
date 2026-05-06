# dotfiles

## スタートアップ

### 1. Homebrew をインストール

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

インストール完了後、以下の手順で初期設定を行います。

#### 1-1. PATH に追加

```bash
# Linux / WSL の場合（bash と zsh 両方に追加）
echo >> ~/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
echo >> ~/.zprofile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# macOS の場合
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### 1-2. 依存パッケージのインストール（Linux / WSL のみ）

```bash
sudo apt-get install build-essential
```

#### 1-3. GCC をインストール（推奨）

```bash
brew install gcc
```

### 2. zsh に切り替え

```bash
brew install zsh
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

ターミナルを再起動して zsh に切り替わっていることを確認してください。

### 3. パッケージをインストール

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
  fzf ripgrep bat neovim glow lazygit git-delta eza zoxide
```

#### oh-my-posh

```bash
# Linux / WSL の場合
sudo apt-get install unzip
curl -s https://ohmyposh.dev/install.sh | bash -s
export PATH="$HOME/.local/bin:$PATH"  # 現セッションのみ有効。ステップ5以降で永続化される

# macOS の場合
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

#### Nerd Font

```bash
# Linux / WSL の場合（oh-my-posh 経由）
oh-my-posh font install hack

# macOS の場合
brew install --cask font-hack-nerd-font
```

### 4. dotfiles をクローン

```bash
git clone https://github.com/nkita/dotfiles.git ~/dotfiles
```

### 5. 手動セットアップ

```bash
# zsh: ~/.zshrc に1行追加
echo 'source ~/dotfiles/zsh/init.zsh' >> ~/.zshrc

# Neovim: シンボリックリンクを作成
mkdir -p ~/.config
ln -s ~/dotfiles/nvim ~/.config/nvim

# LazyGit: シンボリックリンクを作成
mkdir -p ~/.config/lazygit
ln -s ~/dotfiles/lazygit/config.yml ~/.config/lazygit/config.yml

# Claude Code: 設定ファイルを個別にシンボリックリンク（~/.claude はClaudeが自動管理するため）
ln -s ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/claude/statusline-command.sh ~/.claude/statusline-command.sh
ln -s ~/dotfiles/claude/skills ~/.claude/skills
```

### 6. 設定を反映

```bash
source ~/.zshrc
```

### 7. Node.js をインストール（nvm 経由）

`zsh/common.zsh` に nvm のロード設定が含まれているため、ステップ6以降は nvm が自動で利用できます。

```bash
# nvm をインストール
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash

# Node.js LTS をインストール
nvm install --lts
```

ターミナルのフォントを **Hack Nerd Font** に設定すれば完了です。

---

## フォルダ構成

```
dotfiles/
├── zsh/
│   ├── init.zsh          # ~/.zshrc から source するエントリーポイント
│   ├── common.zsh        # 全環境共通設定（brew, oh-my-posh, fzf関数など）
│   ├── aliases.zsh       # 共通エイリアス
│   └── amro.omp.json     # oh-my-posh テーマ
├── nvim/                 # Neovim設定（~/.config/nvim にシンボリックリンク）
│   ├── init.lua
│   └── lua/
│       ├── config/       # lazy.nvim・キーマップ設定
│       └── plugins/      # 各プラグイン設定
├── lazygit/              # LazyGit設定（~/.config/lazygit/config.yml にシンボリックリンク）
│   └── config.yml
├── claude/               # Claude Code設定（各ファイルを ~/.claude/ に個別シンボリックリンク）
│   ├── settings.json
│   ├── statusline-command.sh
│   └── skills/
└── docs/
    └── features.md       # 機能・キーマップ一覧
```

---

## 機能一覧

→ [docs/features.md](docs/features.md)
