# ===================================
# dotfiles .zshrc 
# 全環境共通 + PC個別設定の読み込み
# ===================================

# dotfilesのパス設定
export DOTFILES_DIR="${HOME}/dotfiles"

# 全環境共通設定の読み込み
if [[ -f "$DOTFILES_DIR/zsh/common.zsh" ]]; then
    source "$DOTFILES_DIR/zsh/common.zsh"
fi

# 共通エイリアス設定の読み込み
if [[ -f "$DOTFILES_DIR/zsh/aliases.zsh" ]]; then
    source "$DOTFILES_DIR/zsh/aliases.zsh"
fi

# PC個別設定の読み込み（ホスト名ベース）
local_config="$DOTFILES_DIR/zsh/local/$(hostname -s).zsh"
if [[ -f "$local_config" ]]; then
    source "$local_config"
fi

# 汎用的なlocal設定ファイルの読み込み
if [[ -f "$DOTFILES_DIR/zsh/local/local.zsh" ]]; then
    source "$DOTFILES_DIR/zsh/local/local.zsh"
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nkita/work/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nkita/work/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nkita/work/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nkita/work/google-cloud-sdk/completion.zsh.inc'; fi
