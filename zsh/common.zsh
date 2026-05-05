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
# Theme: https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/amro.omp.json
eval "$(oh-my-posh init zsh --config ~/dotfiles/zsh/amro.omp.json)"

# Homebrew共有ディレクトリ
if type brew &>/dev/null; then
    HOMEBREW_PREFIX=$(brew --prefix)
fi

# zsh-completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
    autoload -Uz compinit
    compinit
fi

# zsh-autocomplete
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

# zsh-autosuggestions
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# zoxide (z command - smart directory jumper)
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

# ===================================
# Git worktree shortcuts
# ===================================

# gwa: ブランチ名を指定してworktreeを追加し、作成先へ移動
if alias gwa >/dev/null 2>&1; then
    echo "[dotfiles] alias 'gwa' already exists. Skip function definition."
else
function gwa {
    if [ -z "$1" ]; then
        echo "Error: ブランチ名を指定してください。"
        echo "Usage: gwa {branch-name}"
        return 1
    fi

    local current_dir branch_name target_path
    current_dir=$(basename "$PWD")
    branch_name="$1"
    target_path="../${current_dir}-${branch_name}"

    # ブランチが存在しなければ新規作成してworktreeを追加
    if git show-ref --verify --quiet "refs/heads/$branch_name" || git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
        git worktree add "$target_path" "$branch_name"
    else
        git worktree add -b "$branch_name" "$target_path"
    fi

    # 作成に成功した場合のみ移動する
    if [ $? -eq 0 ]; then
        cd "$target_path" || return 1
    fi
}
fi

# gwr: worktreeを削除。必要なら削除後に別ディレクトリへ退避
if alias gwr >/dev/null 2>&1; then
    echo "[dotfiles] alias 'gwr' already exists. Skip function definition."
else
function gwr {
    local input_target="$1"
    local removed_path=""
    local current_path fallback_path wt_path
    local -a worktree_paths

    current_path=$(pwd -P)
    worktree_paths=("${(@f)$(git worktree list --porcelain 2>/dev/null | awk '/^worktree /{print substr($0,10)}')}")

    if [ ${#worktree_paths[@]} -eq 0 ]; then
        echo "Error: このディレクトリはgit worktree管理下ではありません。"
        return 1
    fi

    # 削除後に移動する候補を事前に決める
    fallback_path="$HOME"

    if [ -z "$input_target" ]; then
        removed_path="$current_path"
        for wt_path in "${worktree_paths[@]}"; do
            if [ "$wt_path" != "$removed_path" ] && [ -d "$wt_path" ]; then
                fallback_path="$wt_path"
                break
            fi
        done

        git worktree remove ./
        if [ $? -ne 0 ]; then
            return 1
        fi

        cd "$fallback_path" || return 1
        return 0
    fi

    if [ -d "$input_target" ]; then
        removed_path=$(cd "$input_target" 2>/dev/null && pwd -P)
    else
        for wt_path in "${worktree_paths[@]}"; do
            if [ "$(basename "$wt_path")" = "$input_target" ] || [ "$wt_path" = "$input_target" ]; then
                removed_path="$wt_path"
                break
            fi
        done
    fi

    if [ -z "$removed_path" ]; then
        echo "Error: 指定したworktreeが見つかりません: $input_target"
        return 1
    fi

    for wt_path in "${worktree_paths[@]}"; do
        if [ "$wt_path" != "$removed_path" ] && [ -d "$wt_path" ]; then
            fallback_path="$wt_path"
            break
        fi
    done

    git worktree remove "$removed_path"
    if [ $? -ne 0 ]; then
        return 1
    fi

    if [ "$current_path" = "$removed_path" ] || [[ "$current_path" == "$removed_path/"* ]]; then
        cd "$fallback_path" || return 1
    fi
}
fi
