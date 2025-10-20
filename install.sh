#!/bin/bash

# ===================================
# dotfiles セットアップスクリプト
# ===================================

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup/backup_$(date +%Y%m%d_%H%M%S)"

# 既存の.zshrcをバックアップ（シンボリックリンクでない場合のみ）
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
    echo "既存の .zshrc をバックアップしました: $BACKUP_DIR"
fi

# シンボリックリンクを作成
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# PC個別設定ファイルを作成（存在しない場合のみ）
hostname=$(hostname -s)
local_config="$DOTFILES_DIR/zsh/local/${hostname}.zsh"

if [[ ! -f "$local_config" ]]; then
    # example.zshが存在する場合はコピー、そうでなければ基本テンプレートを作成
    if [[ -f "$DOTFILES_DIR/zsh/local/example.zsh" ]]; then
        cp "$DOTFILES_DIR/zsh/local/example.zsh" "$local_config"
    else
        cat > "$local_config" << EOF
# ===================================
# PC個別設定 - ${hostname}
# ===================================

# このPCだけの個別設定をここに記載

# 個別エイリアス例
# alias work_project='cd ~/work/specific-project'

# 環境変数例
# export API_KEY="your_api_key_here"

# このPCだけで使用するツールのPATH設定など
# export PATH="/path/to/specific/tool:\$PATH"

echo "PC個別設定 (${hostname}) を読み込みました"
EOF
    fi
fi

echo "dotfiles setup complete. Run 'source ~/.zshrc' to apply changes."