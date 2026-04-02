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

# LazyGit設定ファイルのセットアップ（lazygitがインストールされている場合のみ）
if command -v lazygit &> /dev/null; then
    LAZYGIT_CONFIG_DIR=$(lazygit --print-config-dir 2>/dev/null)
    
    if [[ -n "$LAZYGIT_CONFIG_DIR" ]]; then
        # 設定ディレクトリが存在しない場合は作成
        mkdir -p "$LAZYGIT_CONFIG_DIR"
        
        # 既存の設定ファイルをバックアップ（シンボリックリンクでない場合のみ）
        if [[ -f "$LAZYGIT_CONFIG_DIR/config.yml" && ! -L "$LAZYGIT_CONFIG_DIR/config.yml" ]]; then
            mkdir -p "$BACKUP_DIR"
            cp "$LAZYGIT_CONFIG_DIR/config.yml" "$BACKUP_DIR/lazygit_config.yml"
            echo "既存の lazygit config.yml をバックアップしました: $BACKUP_DIR"
        fi
        
        # シンボリックリンクを作成
        ln -sf "$DOTFILES_DIR/.config/lazygit/config.yml" "$LAZYGIT_CONFIG_DIR/config.yml"
        echo "LazyGit設定ファイルをセットアップしました"
    fi
fi

# ===================================
# Claude Code 設定
# ===================================

CLAUDE_DIR="$HOME/.claude"
DOTFILES_CLAUDE_DIR="$DOTFILES_DIR/.claude"

# skills ディレクトリのシンボリックリンク
if [[ -d "$DOTFILES_CLAUDE_DIR/skills" ]]; then
    mkdir -p "$CLAUDE_DIR"
    if [[ -L "$CLAUDE_DIR/skills" ]]; then
        rm "$CLAUDE_DIR/skills"
    elif [[ -d "$CLAUDE_DIR/skills" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$CLAUDE_DIR/skills" "$BACKUP_DIR/claude_skills"
        echo "既存の .claude/skills をバックアップしました: $BACKUP_DIR"
    fi
    ln -sf "$DOTFILES_CLAUDE_DIR/skills" "$CLAUDE_DIR/skills"
    echo "Claude skills をセットアップしました"
fi

# statusline-command.sh のシンボリックリンク
if [[ -f "$DOTFILES_CLAUDE_DIR/statusline-command.sh" ]]; then
    if [[ -f "$CLAUDE_DIR/statusline-command.sh" && ! -L "$CLAUDE_DIR/statusline-command.sh" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp "$CLAUDE_DIR/statusline-command.sh" "$BACKUP_DIR/statusline-command.sh"
        echo "既存の statusline-command.sh をバックアップしました: $BACKUP_DIR"
    fi
    ln -sf "$DOTFILES_CLAUDE_DIR/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
    echo "Claude statusline-command.sh をセットアップしました"
fi

# settings.json をコピー（$HOME を展開して配置）
SETTINGS_SRC="$DOTFILES_CLAUDE_DIR/settings.json"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
if [[ -f "$SETTINGS_SRC" ]]; then
    mkdir -p "$CLAUDE_DIR"
    if [[ -f "$SETTINGS_FILE" && ! -L "$SETTINGS_FILE" ]]; then
        echo ""
        echo "既存の $SETTINGS_FILE が見つかりました。上書きしますか？"
        echo "現在の内容:"
        cat "$SETTINGS_FILE"
        echo ""
        read -r -p "上書きしますか？ [y/N]: " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            mkdir -p "$BACKUP_DIR"
            cp "$SETTINGS_FILE" "$BACKUP_DIR/claude_settings.json"
            echo "バックアップしました: $BACKUP_DIR/claude_settings.json"
        else
            echo "settings.json のコピーをスキップしました"
        fi
    fi
    if [[ ! -f "$SETTINGS_FILE" || "$confirm" =~ ^[Yy]$ ]]; then
        envsubst < "$SETTINGS_SRC" > "$SETTINGS_FILE"
        echo "Claude settings.json をコピーしました"
    fi
fi

echo "dotfiles setup complete. Run 'source ~/.zshrc' to apply changes."