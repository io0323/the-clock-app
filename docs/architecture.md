# アーキテクチャ詳細

## レイヤー図

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│   Screens / Widgets / Riverpod          │
│   HomeScreen / AlarmListScreen /        │
│   ScanScreen / AlarmFiringScreen        │
└──────────────┬──────────────────────────┘
               │ UseCase 経由のみ
┌──────────────▼──────────────────────────┐
│             Domain Layer                │
│   Entities / UseCases / Repository I/F  │
│   （Flutter・外部ライブラリに依存しない）   │
└──────────────┬──────────────────────────┘
               │ implements
┌──────────────▼──────────────────────────┐
│              Data Layer                 │
│   Repository実装 / DataSources          │
│   BLE / MQTT / REST / LocalStorage      │
└─────────────────────────────────────────┘
```

## BLE 接続フロー詳細

```
App起動
  │
  ▼
パーミッション確認
  │ OK
  ▼
スキャン開始（nameFilter: BALMUDA_CLOCK）
  │ デバイス発見（RSSI > -90dBm）
  ▼
接続試行（timeout: 10s）
  │ 失敗
  ▼
指数バックオフ（1s→2s→4s→8s→16s→30s）
  │ 5回失敗
  ▼
Error状態（ユーザーに通知）
  │ 成功
  ▼
GATT認証
  │
  ▼
Ready（MQTT接続 & シャドウ同期を開始）
```

## MQTT メッセージフロー

```
The Clock デバイス          Flutter App
     │                          │
     │── sensor ──────────────▶ │ SensorCardWidget 更新
     │── alarm/trigger ───────▶ │ AlarmFiringScreen 表示
     │── shadow/get/accepted ─▶ │ DeviceShadow 更新
     │                          │
     │◀── alarm/set ──────────  │ AlarmEditScreen 保存
     │◀── alarm/set (snooze) ── │ スヌーズ実行
     │◀── shadow/update ──────  │ 設定変更
```
