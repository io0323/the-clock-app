---
globs: ["lib/presentation/providers/**/*.dart"]
---

# 状態管理ルール（Riverpod）

- Provider の種類の使い分け:
  - `Provider` — 依存注入（Repository, UseCase）
  - `StateNotifierProvider` — 複雑な状態（BLE接続状態, アラーム設定）
  - `FutureProvider` — 単発非同期（初回データ取得）
  - `StreamProvider` — 継続ストリーム（MQTTメッセージ, BLE通知）
- `ref.watch()` は build メソッド内のみ
- `ref.read()` はイベントハンドラ内のみ
- 状態のネストは2階層まで（それ以上は設計を見直す）