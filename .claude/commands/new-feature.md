---
description: Clean Architectureに沿った新機能のスケルトンコードを生成する
---

# 新機能スケルトン生成

引数として機能名を受け取り（例: `/new-feature alarm`）、以下を生成してください。

1. `lib/domain/entities/<feature>.dart` — エンティティ
2. `lib/domain/repositories/<feature>_repository.dart` — リポジトリI/F
3. `lib/domain/usecases/<feature>_usecase.dart` — ユースケース
4. `lib/data/repositories/<feature>_repository_impl.dart` — 実装
5. `lib/presentation/providers/<feature>_provider.dart` — Riverpodプロバイダ
6. `test/domain/usecases/<feature>_usecase_test.dart` — ユニットテスト

CLAUDE.md のアーキテクチャ原則・コーディング規約を必ず遵守すること。