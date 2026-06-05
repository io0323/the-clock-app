enum AlarmSound {
  rain,
  chime,
  piano,
  forest,
  waves;

  String get label => switch (this) {
        rain => '雨音',
        chime => 'チャイム',
        piano => 'ピアノ',
        forest => '森',
        waves => '波',
      };

  String get mqttValue => name;
}
