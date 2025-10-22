# ===================================
# 全環境共通のエイリアス設定
# ===================================

# 基本エイリアス
alias vi='nvim'
alias vim='nvim'
alias f='fzf'
alias coma='cat ~/.command'

# Git関連エイリアス
alias g='git'
alias gsw='git switch'
alias gs='git status'
alias ga='git add'
alias game='git commit --amend'
alias gb='git branch'
alias gp='git pull'
alias gl='git log --pretty=fuller'
alias gm='git commit -m'
alias lg='lazygit'

# Docker関連エイリアス
alias dc='docker-compose'
alias dcew='dc exec workspace bash'
alias dcer='dc exec redis bash'
alias dcem='dc exec mysql bash'
alias dceh='dc exec httpd bash'
alias dcup='dc up -d --build'
alias dcrmall='dc down --rmi all --volumes'
alias dcexec='dc exec'
alias dcremake='dc down; dc build httpd; dc up -d'

# Vagrant関連エイリアス
alias va='vagrant'
alias vgs='vagrant global-status'

# ls関連エイリアス（デフォルト）
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'

# eza設定（インストールされている場合）
# Need: brew install eza
if [[ $(command -v eza) ]]; then
    alias ls='eza --icons --git --group-directories-first'
    alias ll='eza -l -T -a -I "node_modules|.git|.cache" --git --icons --group-directories-first -L 1'
    alias lll='eza -T -a -I "node_modules|.git|.cache" --git --icons --group-directories-first -L 1'
fi