# The Clock App — BALMUDA Connect 再設計

> BALMUDA「The Clock」向け Flutter ポートフォリオアプリ。
> BLE通信・MQTT/クラウド連携・非同期状態管理を横断した設計が中核。

## スクリーンショット

| ホーム画面 | アラーム一覧 | アラーム編集 | 発火画面 |
|:---------:|:-----------:|:-----------:|:-------:|
| ![home](docs/screenshots/home.png) | ![alarm_list](docs/screenshots/alarm_list.png) | ![alarm_edit](docs/screenshots/alarm_edit.png) | ![firing](docs/screenshots/firing.png) |

---

## 技術スタック

| カテゴリ | 技術 |
|---------|------|
| フレームワーク | Flutter 3.x / Dart 3.x |
| 状態管理 | Riverpod 2.x（StateNotifier / StreamProvider） |
| BLE通信 | flutter_blue_plus |
| クラウド連携 | MQTT（mqtt_client）/ REST API（Dio + Retrofit） |
| 通知 | flutter_local_notifications |
| 永続化 | SharedPreferences |
| テスト | flutter_test / mocktail |
| CI | GitHub Actions |

---

## アーキテクチャ

Clean Architecture（3層分離）を採用しています。

```
┌─────────────────────────────────────────────────────┐
│                  Presentation                       │
│   Screens ─── Widgets ─── Riverpod Providers        │
├─────────────────────────────────────────────────────┤
│                    Domain                           │
│   Entities ─── UseCases ─── Repository Interfaces   │
├─────────────────────────────────────────────────────┤
│                     Data                            │
│   Repository Impl ─── DataSources (BLE/MQTT/REST)   │
└─────────────────────────────────────────────────────┘
```

**依存方向**: Presentation → Domain ← Data（Domain は外部に依存しない）

### ディレクトリ構成

```text
lib/
├── core/                   # 共通ユーティリティ・定数・例外定義
│   ├── constants/          #   AppColors, AppTextStyles, AppTheme, MqttTopics
│   ├── errors/             #   AppException, BleException, MqttException, AlarmException
│   └── utils/              #   BleLogger, DemoData
│
├── domain/                 # ビジネスロジック層
│   ├── entities/           #   ClockState, BleDevice, SensorData, AlarmConfig 等
│   ├── repositories/       #   BleRepository, MqttRepository, ClockRepository（interface）
│   └── usecases/
│       ├── ble/            #   ScanDevices, ConnectDevice, AutoReconnect
│       └── mqtt/           #   WatchSensor, ConnectMqtt, SyncDeviceShadow, PublishAlarm
│
├── data/                   # データアクセス層
│   ├── datasources/        #   BleDataSource, MqttDataSource, RestDataSource
│   └── repositories/       #   BleRepositoryImpl, MqttRepositoryImpl, MockClockRepository
│
├── presentation/           # UI 層
│   ├── providers/          #   ble_provider, mqtt_provider, clock_provider, ble_lifecycle_provider
│   ├── screens/            #   home/, scan/, alarm/
│   └── widgets/            #   clock_face/, light_hour_bar/, mqtt/, sensor/, status_bar/
│
└── main.dart
```

---

## 設計の要点

### BLE 接続状態機械

```
Idle → Scanning → Connecting → Auth → Ready
                                 ↓
                  Error → [指数バックオフ] → Scanning
```

再接続は指数バックオフ（1s → 2s → 4s → 8s → 16s → 最大30s）で最大5回リトライします。

- `BleRepository`（interface）→ `BleRepositoryImpl`（実装）で責務を分離
- 接続状態は `StateNotifierProvider` で一元管理し、UI は `ref.watch()` で反映
- 全 BLE 操作を `try/catch (BleException)` でラップし、エラーを統一的にハンドリング

### MQTT リアルタイム同期

```
Device ──publish──▶ Broker ──subscribe──▶ App
App    ──publish──▶ Broker ──subscribe──▶ Device
```

- `StreamProvider` で MQTT メッセージを購読し、センサーデータをリアルタイム反映
- Device Shadow パターンでオフライン時の状態差分を同期
- トピック設計は `core/constants/mqtt_topics.dart` に集約

#### MQTTトピック設計

| 方向 | トピック | 用途 |
|-----|---------|------|
| Sub | `balmuda/{deviceId}/alarm` | アラーム発火イベント受信 |
| Sub | `balmuda/{deviceId}/sensor` | 温湿度センサーデータ |
| Sub | `balmuda/{deviceId}/shadow/get/accepted` | デバイスシャドウ取得 |
| Pub | `balmuda/{deviceId}/alarm/set` | アラーム設定送信 |
| Pub | `balmuda/{deviceId}/shadow/update` | シャドウ更新 |

### アラーム管理

- Domain Entity（`AlarmConfig`）→ UseCase（`PublishAlarmUsecase`）→ MQTT publish の流れ
- アラーム発火時のバイブレーション・サウンドは OS ネイティブ通知と連携

---

## 実装のポイント（採用要件との対応）

### 非同期処理・状態管理の設計（MUST）
- Riverpod の `StateNotifierProvider` で BLE・アラームの状態を厳密に管理
- 接続中に再接続処理が走らないよう `BleConnectionStatus` で排他制御
- 通信失敗時の自動リトライを `AutoReconnectUseCase` に集約

### BLE / IoTデバイス連携開発（WANT）
- `flutter_blue_plus` でスキャン・ペアリング・再接続・状態同期を実装
- iOS / Android の BLE パーミッション差異・バックグラウンド挙動の違いを吸収

### MQTT / クラウド連携（WANT）
- `mqtt_client` で AWS IoT Core 互換のリアルタイム通信を実装
- デバイスシャドウ（REST API / MQTT の二段階フォールバック）

### 通信トラブル時のリカバリ設計（WANT）
- 指数バックオフによる自動再接続（BLE / MQTT 両方）
- タイムアウト検知・切断リカバリフローを UseCase に実装

### ログをもとに不具合を特定する力（WANT）
- `BleLogger` で接続イベントを構造化ログ出力
- アプリ側 / 通信側 / デバイス側の問題を3段階で切り分け可能

---

## セットアップ

```bash
# 依存パッケージのインストール
flutter pub get

# コード生成（Riverpod Generator / Retrofit）
dart run build_runner build --delete-conflicting-outputs

# アプリ起動
flutter run

# テスト実行
flutter test
```

### 前提条件

- Flutter SDK 3.x / Dart SDK 3.x
- Xcode（iOS）/ Android Studio（Android）
- BLE テストは実機が必要（エミュレータ不可）
- MQTT 接続にはローカル Broker（`localhost:1883`）または検証環境を使用

---

## テスト方針

| レイヤー | テスト手法 | ツール |
|---------|-----------|-------|
| Domain（UseCase） | ユニットテスト | flutter_test / mocktail |
| Data（Repository） | ユニットテスト + Mock | mocktail |
| BLE / MQTT 結合 | 統合テスト（実機） | flutter_test |
| Presentation | Widget テスト | flutter_test |

---

## コミット規約

[Conventional Commits](https://www.conventionalcommits.org/) に準拠しています。

```
feat:     新機能
fix:      バグ修正
refactor: リファクタリング
test:     テスト追加・修正
docs:     ドキュメント
```

---

## ロードマップ

- [x] Clean Architecture の土台構築
- [x] Riverpod 導入・Provider 設計
- [x] BLE 接続フロー実装（スキャン → 接続 → ライフサイクル管理）
- [x] MQTT 連携（リアルタイム同期・センサーデータ購読）
- [x] REST API 連携（Dio + Retrofit）
- [x] アラーム管理（ドメイン設計 → MQTT publish）
- [x] アプリアイコン・スプラッシュ画面
- [ ] flutter_local_notifications によるアラーム発火
- [ ] SharedPreferences によるアラーム永続化
- [ ] GitHub Actions CI パイプライン
- [ ] E2E テスト整備

---

## ライセンス

This project is for portfolio / demonstration purposes.
