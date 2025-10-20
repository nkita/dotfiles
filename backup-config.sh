#!/bin/bash

# ===================================
# dotfiles バックアップスクリプト
# dotfiles内の設定ファイルをバックアップ
# ===================================

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup/config_backup_$(date +%Y%m%d_%H%M%S)"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Error: dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

echo "Creating backup of dotfiles configuration..."

# バックアップディレクトリを作成
mkdir -p "$BACKUP_DIR"

# 設定ファイルをバックアップ
cp -r "$DOTFILES_DIR/zsh" "$BACKUP_DIR/" 2>/dev/null
cp "$DOTFILES_DIR/.zshrc" "$BACKUP_DIR/" 2>/dev/null
cp "$DOTFILES_DIR/amro.omp.json" "$BACKUP_DIR/" 2>/dev/null
cp -r "$DOTFILES_DIR/.config" "$BACKUP_DIR/" 2>/dev/null

echo "Configuration backup saved to: $BACKUP_DIR"