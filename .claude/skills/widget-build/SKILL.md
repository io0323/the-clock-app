---
description: The ClockのデザインコンセプトをFlutter Widgetとして実装する
---

# Widget実装スキル

## デザイン原則
- BALMUDA の世界観（ミニマル・光・アルミ質感）を再現
- アニメーションは `AnimationController` + `Curves.easeInOut` を基本とする
- ダークテーマ前提。カラーは `AppColors` 定数クラスから参照
- テキストは `AppTextStyles` から参照（フォントの直書き禁止）

## Light Hour ウィジェット実装方針
- `CustomPainter` で光の文字盤を描画
- 秒針は `AnimationController` でスムーズに動かす（tick駆動）
- 時報エフェクトは `flutter_animate` パッケージを使用

## アクセシビリティ
- `Semantics` ウィジェットを時刻表示に必ず付与
- コントラスト比 4.5:1 以上を確保