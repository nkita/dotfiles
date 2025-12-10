# ===================================
# 全環境共通のzsh設定
# ===================================

# Homebrew PATH設定（最初に読み込む）
if [[ -f /opt/homebrew/bin/brew ]]; then
    # Apple Silicon Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    # Linux (Linuxbrew)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# エディタ設定
export VISUAL=nvim
export EDITOR=nvim

# oh-my-posh設定
# Need: brew install jandedobbeleer/oh-my-posh/oh-my-posh
# Theme: https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/amro.omp.json
eval "$(oh-my-posh init zsh --config ~/dotfiles/amro.omp.json)"

# zsh-autosuggestions
# Need: brew install zsh-autosuggestions
if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting
# Need: brew install zsh-syntax-highlighting
if [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-completions
# Need: brew install zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi

# zoxide (z command - smart directory jumper)
# Need: brew install zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Node.js PATH設定
# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"  # This loads nvm
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
    source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# nodebrew (古い設定 - nvmを使う場合はコメントアウト推奨)
# export PATH=$HOME/.nodebrew/current/bin:$PATH

# ===================================
# fzf カスタム関数
# ===================================

# ff: ファイル検索してNeovimで開く
ff() {
  local target_dir="${1:-.}"
  local file
  (
    cd "$target_dir" || return 1
    file=$(fzf \
      --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {}' \
      --preview-window=right:60%:wrap \
      --bind 'ctrl-/:toggle-preview' \
      --header 'Enter: Open in Neovim | Ctrl-/: Toggle preview' \
      --walker-skip=node_modules,.git,.cache
    )
    [[ -n "$file" ]] && nvim "$file"
  )
}

# gf: プロジェクト全体をgrepしてファイル:行で開く
gf() {
  local target_dir="${1:-.}"
  local result
  (
    cd "$target_dir" || return 1
    result=$(rg --line-number --color=always --no-heading \
      --glob '!node_modules' --glob '!.git' --glob '!.cache' \
      . 2>/dev/null | \
      fzf --ansi \
          --delimiter ':' \
          --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
          --preview-window=right:60%:wrap:+{2}-5 \
          --bind 'ctrl-/:toggle-preview' \
          --header 'Enter: Open in Neovim at line | Ctrl-/: Toggle preview'
    )
    [[ -n "$result" ]] && nvim "+$(echo $result | cut -d: -f2)" "$(echo $result | cut -d: -f1)"
  )
}
