enum AlarmWeekday {
  mon,
  tue,
  wed,
  thu,
  fri,
  sat,
  sun;

  String get label => switch (this) {
        mon => '月',
        tue => '火',
        wed => '水',
        thu => '木',
        fri => '金',
        sat => '土',
        sun => '日',
      };

  int get dateTimeWeekday => index + 1;
}
