# The Clock App — BALMUDA Connect 再設計

## プロジェクト概要
BALMUDA「The Clock」向けFlutterアプリ。
BLE通信・MQTT/クラウド連携・非同期状態管理を横断した設計が中核。
ポートフォリオ兼実装プロトタイプ。

## アーキテクチャ原則
- **Clean Architecture**（Domain / Data / Presentation の3層分離）を厳守
- **Riverpod** を状態管理の唯一の手段とする
- BLE・API・MQTT はそれぞれ独立した Repository として実装
- UI からビジネスロジックを直接呼び出さない

## ディレクトリ構成
lib/
├── core/           # 共通ユーティリティ・定数・エラー定義
├── domain/         # エンティティ・ユースケース・リポジトリインターフェース
├── data/           # リポジトリ実装・データソース（BLE/API/MQTT）
└── presentation/   # UI（screens / widgets）・Riverpod providers

## コーディング規約
- Dart: `dart format` + `dart analyze` を常時クリア
- 命名: クラスはPascalCase、変数・関数はcamelCase、ファイルはsnake_case
- BLE 処理は必ず `try/catch` でラップし、エラーを `AppException` に変換
- `async/await` を使用し、`.then()` チェーンは避ける
- Widget は 100行を超えたら分割する

## テスト方針
- Domain層（UseCase）は必ずユニットテストを書く
- BLE・MQTT は Mock を使ってテスト
- `flutter test` がすべてパスすることを確認してからコミット

## コミット規約
- Conventional Commits: `feat:` / `fix:` / `refactor:` / `test:` / `docs:`
- 1コミット = 1つの論理的変更
- コミット前に `flutter analyze` を実行

## 参照ドキュメント
- @docs/ble-spec.md        # BLEプロトコル仕様
- @docs/api-spec.md        # REST API仕様
- @docs/mqtt-topics.md     # MQTTトピック一覧
- @pubspec.yaml            # 依存パッケージ一覧