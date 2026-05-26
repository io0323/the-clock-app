---
globs: ["lib/data/datasources/ble*.dart", "lib/domain/**/*ble*.dart"]
---

# BLE実装ルール

- BLE操作は必ず `try/catch (BleException)` でラップする
- 接続タイムアウトは 10秒（デフォルト）を上限とする
- 再接続は指数バックオフ（1s → 2s → 4s → 最大30s）で実装
- 接続中に再度接続処理を呼ばないよう State で排他制御する
- バックグラウンド時の BLE 動作は iOS/Android で挙動が異なるため、
  プラットフォーム分岐を明示的に記述する
- デバイス切断イベントは必ずリッスンし、UI に反映する