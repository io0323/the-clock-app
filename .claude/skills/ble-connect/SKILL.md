---
description: BLE接続フロー（スキャン→接続→認証→ready）の実装・修正・デバッグを行う
---

# BLE接続フロー実装スキル

## このスキルが扱う範囲
- `flutter_blue_plus` を使ったデバイス探索・ペアリング
- 接続状態マシン（Idle / Scanning / Connecting / Auth / Ready / Error）の実装
- 切断検知・自動リカバリ・タイムアウト設計

## 実装手順
1. `lib/data/datasources/ble_datasource.dart` を確認・編集
2. `.claude/rules/ble.md` のルールを厳守
3. 状態は `BleConnectionState` enum で管理（`lib/domain/entities/ble_state.dart`）
4. エラー発生時は `AppException.ble()` に変換して上位へ伝播
5. 実装後に `flutter analyze` を実行し警告ゼロを確認

## テンプレート（接続リトライロジック）
```dart
Future<void> connectWithRetry(BluetoothDevice device) async {
  int attempt = 0;
  final maxAttempts = 5;
  while (attempt < maxAttempts) {
    try {
      await device.connect(timeout: const Duration(seconds: 10));
      return;
    } on BleException {
      attempt++;
      if (attempt >= maxAttempts) rethrow;
      await Future.delayed(Duration(seconds: 1 << attempt)); // 指数バックオフ
    }
  }
}
```