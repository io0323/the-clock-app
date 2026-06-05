import 'app_exception.dart';

class AlarmScheduleException extends AppException {
  const AlarmScheduleException(super.message, {super.code});

  String get userMessage => 'アラームのスケジュール登録に失敗しました';
}

class AlarmNotifyException extends AppException {
  const AlarmNotifyException(super.message, {super.code});

  String get userMessage => 'アラーム通知の送信に失敗しました';
}

class AlarmSyncException extends AppException {
  const AlarmSyncException(super.message, {super.code});

  String get userMessage => 'デバイスとのアラーム同期に失敗しました';
}

class AlarmNotFoundException extends AppException {
  const AlarmNotFoundException(super.message, {super.code});

  String get userMessage => '指定されたアラームが見つかりません';
}
