---
globs: ["lib/**/*.dart", "test/**/*.dart"]
---

# Flutter / Dart コーディングルール

- `BuildContext` を非同期処理を跨いで使用しない（`mounted` チェックを行う）
- `StatefulWidget` より `ConsumerWidget` (Riverpod) を優先する
- `const` コンストラクタを可能な限り使用する
- `setState` は使用禁止（Riverpod で統一）
- Widget ツリーのネストが深くなる場合は専用 Widget クラスに切り出す
- `print()` は使用禁止。`debugPrint()` または Logger パッケージを使用