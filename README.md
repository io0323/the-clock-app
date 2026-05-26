# The Clock App

BALMUDA「The Clock」をモチーフにした Flutter アプリケーションです。  
BLE、MQTT、クラウド連携を前提に、再設計プロトタイプとして開発を進めるプロジェクトです。

## Overview

このリポジトリでは、The Clock 向けモバイルアプリを Flutter で構築します。  
主なテーマは以下です。

- BLE 接続とデバイス制御
- MQTT を用いたリアルタイム連携
- REST API / クラウド連携
- Riverpod を用いた非同期状態管理
- Clean Architecture による責務分離

## Architecture

本プロジェクトは以下の原則に従って設計します。

- Clean Architecture
- Riverpod による状態管理
- BLE / API / MQTT を独立した Repository として分離
- UI からビジネスロジックを直接呼び出さない

## Directory Structure

```text
lib/
├── core/           # 共通ユーティリティ・定数・例外定義
├── domain/         # Entity / UseCase / Repository interface
├── data/           # Repository implementation / data sources
└── presentation/   # Screen / Widget / Riverpod providers

Development
Requirements
Flutter SDK
Dart SDK
Xcode / Android Studio
実機 BLE テスト環境
Install dependencies
flutter pub get
Run app
flutter run
Run tests
flutter test
Notes
BLE テストは実機前提
MQTT 接続はローカル Broker または検証環境を利用
コミットは Conventional Commits を利用
Roadmap
 Clean Architecture の土台構築
 Riverpod 導入
 BLE 接続フロー実装
 MQTT 連携
 クラウド API 連携
 デバイス状態同期 UI の実装
