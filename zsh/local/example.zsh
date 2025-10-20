# ===================================
# PC個別設定のサンプル
# ===================================
# このファイルをコピーして、あなたのホスト名でファイルを作成してください
# 例: cp example.zsh $(hostname -s).zsh

# 個別エイリアスの例
# alias work='cd ~/work'
# alias project='cd ~/projects/current-project'
# alias start_dev='docker-compose -f docker-compose.dev.yml up -d'
# alias stop_dev='docker-compose -f docker-compose.dev.yml down'

# 環境変数の例
# export API_KEY="your_development_api_key"
# export DATABASE_URL="postgresql://user:pass@localhost:5432/devdb"
# export EDITOR="code"

# PATH設定の例
# export PATH="/usr/local/bin/custom-tool:$PATH"
# export PATH="$HOME/.local/bin:$PATH"

# このPC固有のツール設定
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"
# export ANDROID_HOME="$HOME/Library/Android/sdk"

# プロジェクト固有の設定
# export PROJECT_ROOT="$HOME/work/main-project"
# alias goto_project='cd $PROJECT_ROOT'

# 開発サーバー起動用のエイリアス
# alias dev_server='cd $PROJECT_ROOT && npm run dev'
# alias test_server='cd $PROJECT_ROOT && npm run test'

echo "PC個別設定 ($(hostname -s)) を読み込みました"