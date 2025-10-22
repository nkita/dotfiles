-- プラグイン設定を読み込む（leaderキーの設定を含む）
require("config.lazy")

-- キーマップ設定を読み込む（キャッシュクリア）
package.loaded["config.keymaps"] = nil
require("config.keymaps")
