const Map<String, int> timeZoneOffsets = <String, int>{
  'WIB': 420,
  'MYT': 480,
  'EDT': -240,
};

const Map<int, String> _dayNames = <int, String>{
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: 'Jumat',
  6: 'Sabtu',
  7: 'Minggu',
};

int _offsetOf(String zone, String paramName) {
  final offset = timeZoneOffsets[zone];
  if (offset == null) {
    throw ArgumentError.value(
      zone,
      paramName,
      'Zona waktu tidak dikenali. Gunakan salah satu: ${timeZoneOffsets.keys.join(', ')}',
    );
  }
  return offset;
}

String convertTime(int hour, int minute, String fromZone, String toZone) {
  if (hour < 0 || hour > 23) {
    throw ArgumentError.value(
      hour,
      'hour',
      'Jam harus berada dalam rentang 0..23',
    );
  }
  if (minute < 0 || minute > 59) {
    throw ArgumentError.value(
      minute,
      'minute',
      'Menit harus berada dalam rentang 0..59',
    );
  }

  final fromOffset = _offsetOf(fromZone, 'fromZone');
  final toOffset = _offsetOf(toZone, 'toZone');

  final utcMinutes = hour * 60 + minute - fromOffset;
  final targetMinutes = ((utcMinutes + toOffset) % 1440 + 1440) % 1440;

  final hh = (targetMinutes ~/ 60).toString().padLeft(2, '0');
  final mm = (targetMinutes % 60).toString().padLeft(2, '0');
  return '$hh:$mm';
}

String getDayName(int dayNumber) {
  final name = _dayNames[dayNumber];
  if (name == null) {
    throw ArgumentError.value(
      dayNumber,
      'dayNumber',
      'Nomor hari harus berada dalam rentang 1..7',
    );
  }
  return name;
}
