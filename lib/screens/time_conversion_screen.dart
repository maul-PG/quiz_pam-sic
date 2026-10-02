import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_mobile/utils/time_utils.dart';

class TimeConversionScreen extends StatefulWidget {
  const TimeConversionScreen({super.key});

  @override
  State<TimeConversionScreen> createState() => _TimeConversionScreenState();
}

class _TimeConversionScreenState extends State<TimeConversionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();

  Map<String, String>? _results;

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _useNow() {
    final now = TimeOfDay.now();
    _hourController.text = now.hour.toString().padLeft(2, '0');
    _minuteController.text = now.minute.toString().padLeft(2, '0');
    setState(() => _results = null);
  }

  void _reset() {
    _hourController.clear();
    _minuteController.clear();
    setState(() => _results = null);
  }

  void _convert() {
    if (!_formKey.currentState!.validate()) return;

    final hour = int.parse(_hourController.text);
    final minute = int.parse(_minuteController.text);

    setState(() {
      _results = {
        'MYT': convertTime(hour, minute, 'WIB', 'MYT'),
        'EDT': convertTime(hour, minute, 'WIB', 'EDT'),
      };
    });
  }

  String? _validateHour(String? value) {
    if (value == null || value.trim().isEmpty) return 'Jam wajib diisi';
    final parsed = int.tryParse(value);
    if (parsed == null) return 'Jam harus berupa angka bulat';
    if (parsed < 0 || parsed > 23) return 'Jam harus antara 0 dan 23';
    return null;
  }

  String? _validateMinute(String? value) {
    if (value == null || value.trim().isEmpty) return 'Menit wajib diisi';
    final parsed = int.tryParse(value);
    if (parsed == null) return 'Menit harus berupa angka bulat';
    if (parsed < 0 || parsed > 59) return 'Menit harus antara 0 dan 59';
    return null;
  }

  String _dayShiftLabel(String targetZone) {
    final inputMinutes =
        int.parse(_hourController.text) * 60 +
        int.parse(_minuteController.text);
    final offsetDifference =
        timeZoneOffsets[targetZone]! - timeZoneOffsets['WIB']!;
    final targetMinutes = inputMinutes + offsetDifference;

    if (targetMinutes < 0) return 'Hari Sebelumnya';
    if (targetMinutes >= 1440) return 'Hari Berikutnya';
    return 'Hari yang Sama';
  }

  @override
  Widget build(BuildContext context) {
    final wibTime =
        _hourController.text.isNotEmpty && _minuteController.text.isNotEmpty
        ? '${_hourController.text.padLeft(2, '0')}:${_minuteController.text.padLeft(2, '0')} WIB'
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Waktu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  leading: Icon(
                    Icons.public,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Zona Asal'),
                  subtitle: const Text(
                    'WIB — Waktu Indonesia Barat (UTC+7)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hourController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 2,
                      decoration: const InputDecoration(
                        labelText: 'Jam (0–23)',
                        helperText: 'Contoh: 08',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      validator: _validateHour,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _minuteController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 2,
                      decoration: const InputDecoration(
                        labelText: 'Menit (0–59)',
                        helperText: 'Contoh: 30',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      validator: _validateMinute,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _convert,
                icon: const Icon(Icons.sync_alt),
                label: const Text('Konversi Waktu'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _useNow,
                      icon: const Icon(Icons.access_time),
                      label: const Text('Ambil Jam Sekarang (WIB)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.clear),
                      label: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_results != null) ...[
                Text(
                  'Hasil Konversi dari $wibTime',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _ZoneResultCard(
                  zone: 'Malaysia (MYT - UTC+8)',
                  icon: Icons.language,
                  time: _results!['MYT']!,
                  dayShift: _dayShiftLabel('MYT'),
                ),
                const SizedBox(height: 8),
                _ZoneResultCard(
                  zone: 'Kanada (EDT - UTC-4)',
                  icon: Icons.public,
                  time: _results!['EDT']!,
                  dayShift: _dayShiftLabel('EDT'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoneResultCard extends StatelessWidget {
  const _ZoneResultCard({
    required this.zone,
    required this.icon,
    required this.time,
    required this.dayShift,
  });

  final String zone;
  final IconData icon;
  final String time;
  final String dayShift;

  @override
  Widget build(BuildContext context) {
    final isShifted = dayShift != 'Hari yang Sama';

    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(zone),
        subtitle: Text(
          dayShift,
          style: TextStyle(
            color: isShifted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            fontWeight: isShifted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
