import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_mobile/utils/geometry.dart';

enum _PyramidMode { volume, perimeter }

class PyramidScreen extends StatefulWidget {
  const PyramidScreen({super.key});

  @override
  State<PyramidScreen> createState() => _PyramidScreenState();
}

class _PyramidScreenState extends State<PyramidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sisiController = TextEditingController();
  final _tinggiController = TextEditingController();

  _PyramidMode _mode = _PyramidMode.volume;
  double? _volume;
  double? _basePerimeter;

  @override
  void dispose() {
    _sisiController.dispose();
    _tinggiController.dispose();
    super.dispose();
  }

  void _reset() {
    _sisiController.clear();
    _tinggiController.clear();
    setState(() {
      _volume = null;
      _basePerimeter = null;
    });
  }

  void _onModeChanged(_PyramidMode mode) {
    setState(() {
      _mode = mode;
    });
    _reset();
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) return;

    final s = double.parse(_sisiController.text);

    setState(() {
      try {
        if (_mode == _PyramidMode.volume) {
          final t = double.parse(_tinggiController.text);
          _volume = calculatePyramidVolume(s, t);
          _basePerimeter = null;
        } else {
          _basePerimeter = calculatePyramidBasePerimeter(s);
          _volume = null;
        }
      } on ArgumentError catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    });
  }

  String? _validatePositive(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return '$label harus berupa angka';
    }
    if (parsed <= 0) {
      return '$label harus lebih dari 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = _volume != null || _basePerimeter != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Piramida')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_PyramidMode>(
                segments: const [
                  ButtonSegment(
                    value: _PyramidMode.volume,
                    label: Text('Hitung Volume'),
                  ),
                  ButtonSegment(
                    value: _PyramidMode.perimeter,
                    label: Text('Hitung Keliling'),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) =>
                    _onModeChanged(selection.first),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _sisiController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Sisi Alas (s)',
                  helperText: 'Contoh: 6 cm',
                  border: OutlineInputBorder(),
                  suffixText: 'satuan',
                ),
                validator: (v) => _validatePositive(v, 'Sisi alas'),
              ),
              const SizedBox(height: 16),
              if (_mode == _PyramidMode.volume)
                TextFormField(
                  controller: _tinggiController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Tinggi Piramida (t)',
                    helperText: 'Contoh: 4 cm',
                    border: OutlineInputBorder(),
                    suffixText: 'satuan',
                  ),
                  validator: (v) => _validatePositive(v, 'Tinggi piramida'),
                ),
              if (_mode == _PyramidMode.volume) const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _hitung,
                      child: const Text('Hitung'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (hasResult)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil Perhitungan',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        if (_volume != null)
                          _ResultRow(
                            label: 'Volume Piramida',
                            value: _volume!.toStringAsFixed(2),
                            unit: 'satuan³',
                            icon: Icons.view_in_ar,
                          )
                        else
                          _ResultRow(
                            label: 'Keliling Alas Piramida',
                            value: _basePerimeter!.toStringAsFixed(2),
                            unit: 'satuan',
                            icon: Icons.crop_square,
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '$value $unit',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
