# alias settings
alias vi='nvim'
alias vim='nvim'
alias g='git'
alias gsw='git switch'
alias gs='git status'
alias ga='git add'
alias game='git commit --amend'
alias gb='git branch'
alias gp='git pull'
alias gl='git log --pretty=fuller'  # 'llog'は存在しないので修正
alias gm='git commit -m'
alias vgs='vagrant global-status'
alias dc='docker-compose'
alias dcew='dc exec workspace bash'
alias dcer='dc exec redis bash'
alias dcem='dc exec mysql bash'
alias dceh='dc exec httpd bash'
alias dcup='dc up -d --build'
alias dcrmall='dc down --rmi all --volumes'
alias dcexec='dc exec'
alias va='vagrant'
alias f='fzf'
alias coma='cat ~/.command'
alias dcremake='dc down; dc build httpd; dc up -d'
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'

# Need:brew install eza
if [[ $(command -v eza) ]]; then
    alias ls='eza --icons --git --group-directories-first'
    alias ll='eza -l -T  -a -I "node_modules|.git|.cache" --git --icons --group-directories-first -L 1'
    alias lll='eza -T  -a -I "node_modules|.git|.cache" --git --icons --group-directories-first -L 1'
fi
# Need:brew install jandedobbeleer/oh-my-posh/oh-my-posh
# Teheme:https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/amro.omp.json
eval "$(oh-my-posh init zsh --config ~/dotfiles/amro.omp.json)"

#. "$(brew --prefix)/etc/profile.d/z.sh"

# Need:brew install zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Need:brew install zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=$HOME/.nodebrew/current/bin:$PATH

# Need:brew install zsh-completions
if type brew &>/dev/null; then
     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

     autoload -Uz compinit
     compinit
fi

# Added by Windsurf
export PATH="/Users/nkita/.codeium/windsurf/bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

