# dotfiles

## スタートアップ

### 1. Homebrew をインストール

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. zsh に切り替え

```bash
brew install zsh
chsh -s $(which zsh)
```

ターミナルを再起動して zsh に切り替わっていることを確認してください。

### 3. パッケージをインストール

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
  jandedobbeleer/oh-my-posh/oh-my-posh fzf ripgrep bat neovim glow \
  lazygit git-delta eza zoxide

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
