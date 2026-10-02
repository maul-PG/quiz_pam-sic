import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_mobile/utils/time_utils.dart';

class DayCheckerScreen extends StatefulWidget {
  const DayCheckerScreen({super.key});

  @override
  State<DayCheckerScreen> createState() => _DayCheckerScreenState();
}

class _DayCheckerScreenState extends State<DayCheckerScreen> {
  static const Color _primary = Color(0xFF424874);
  static const Color _surface = Color(0xFFDCD6F7);
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String? _resultText;
  bool _hasError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    if (!_formKey.currentState!.validate()) return;

    final number = int.parse(_controller.text);
    setState(() {
      try {
        final dayName = getDayName(number);
        _resultText = '$number = $dayName';
        _hasError = false;
      } on ArgumentError {
        _resultText =
            'Nomor $number tidak valid. Masukkan angka antara 1 sampai 7.';
        _hasError = true;
      }
    });
  }

  void _reset() {
    _controller.clear();
    setState(() {
      _resultText = null;
      _hasError = false;
    });
  }

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor hari wajib diisi';
    }
    if (int.tryParse(value) == null) {
      return 'Harus berupa angka bulat';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek Hari')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Masukkan nomor hari (1 = Senin, 7 = Minggu)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Nomor Hari',
                  hintText: '1 - 7',
                  helperText: 'Contoh: 1 (Senin) atau 7 (Minggu)',
                  border: OutlineInputBorder(),
                ),
                validator: _validateInput,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _check,
                      icon: const Icon(Icons.search),
                      label: const Text('Cek Hari'),
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
              const SizedBox(height: 32),
              if (_resultText != null)
                Card(
                  color: _hasError ? _surface : _surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _hasError
                              ? Icons.error_outline
                              : Icons.calendar_today,
                          size: 40,
                          color: _primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _hasError ? 'Tidak Valid' : 'Nama Hari',
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _resultText!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _primary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
