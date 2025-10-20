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

# Node.js PATH設定
export PATH=$HOME/.nodebrew/current/bin:$PATH