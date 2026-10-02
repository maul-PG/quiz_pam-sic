import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_mobile/utils/geometry.dart';

enum _TriangleType { equilateral, isosceles, right }

class TriangleScreen extends StatefulWidget {
  const TriangleScreen({super.key});

  @override
  State<TriangleScreen> createState() => _TriangleScreenState();
}

class _TriangleScreenState extends State<TriangleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();

  _TriangleType _type = _TriangleType.equilateral;

  double? _luas;
  double? _keliling;
  double? _hipotenusa;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  void _reset() {
    _aController.clear();
    _bController.clear();
    setState(() {
      _luas = null;
      _keliling = null;
      _hipotenusa = null;
    });
  }

  void _onTypeChanged(_TriangleType type) {
    setState(() {
      _type = type;
    });
    _reset();
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) return;

    final a = double.parse(_aController.text);

    if (_type == _TriangleType.isosceles) {
      final b = double.parse(_bController.text);
      if (b >= 2 * a) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alas harus lebih kecil dari dua kali panjang kaki'),
          ),
        );
        return;
      }
    }

    setState(() {
      try {
        switch (_type) {
          case _TriangleType.equilateral:
            _luas = calculateEquilateralArea(a);
            _keliling = calculateEquilateralPerimeter(a);
            _hipotenusa = null;
            break;
          case _TriangleType.isosceles:
            final b = double.parse(_bController.text);
            _luas = calculateIsoscelesArea(a, b);
            _keliling = calculateIsoscelesPerimeter(a, b);
            _hipotenusa = null;
            break;
          case _TriangleType.right:
            final b = double.parse(_bController.text);
            _luas = calculateRightArea(a, b);
            _keliling = calculateRightPerimeter(a, b);
            _hipotenusa = calculateRightHypotenuse(a, b);
            break;
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

  Widget _buildInstructionCard() {
    String title;
    String description;
    String formulaText;

    switch (_type) {
      case _TriangleType.equilateral:
        title = 'Segitiga Sama Sisi';
        description = 'Masukkan panjang sisi segitiga. Ketiga sisinya memiliki panjang yang sama.';
        formulaText = 'Luas = (√3 / 4) × a²\nKeliling = 3 × a';
        break;
      case _TriangleType.isosceles:
        title = 'Segitiga Sama Kaki';
        description = 'Masukkan panjang kedua sisi kaki yang sama, serta panjang sisi alas segitiga.';
        formulaText = 'Luas = (b / 4) × √(4a² - b²)\nKeliling = 2a + b';
        break;
      case _TriangleType.right:
        title = 'Segitiga Siku-siku';
        description = 'Masukkan panjang sisi alas dan sisi tinggi segitiga yang membentuk sudut siku-siku.';
        formulaText = 'Luas = ½ × a × b\nKeliling = a + b + c';
        break;
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              'Rumus:\n$formulaText',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = _luas != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Segitiga')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInstructionCard(),
              const SizedBox(height: 20),
              SegmentedButton<_TriangleType>(
                segments: const [
                  ButtonSegment(
                    value: _TriangleType.equilateral,
                    label: Text('Sama Sisi'),
                  ),
                  ButtonSegment(
                    value: _TriangleType.isosceles,
                    label: Text('Sama Kaki'),
                  ),
                  ButtonSegment(
                    value: _TriangleType.right,
                    label: Text('Siku-siku'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) =>
                    _onTypeChanged(selection.first),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _aController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: _type == _TriangleType.isosceles
                      ? 'Sisi Kaki (a)'
                      : _type == _TriangleType.right
                      ? 'Sisi Alas (a)'
                      : 'Sisi (a)',
                  helperText: _type == _TriangleType.isosceles
                      ? 'Contoh: 5 cm'
                      : _type == _TriangleType.right
                      ? 'Contoh: 3 cm'
                      : 'Contoh: 5 cm',
                  border: const OutlineInputBorder(),
                  suffixText: 'satuan',
                ),
                validator: (v) => _validatePositive(v, 'Nilai a'),
              ),
              if (_type != _TriangleType.equilateral) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: _type == _TriangleType.isosceles
                        ? 'Sisi Alas (b)'
                        : 'Sisi Tinggi (b)',
                    helperText: _type == _TriangleType.isosceles
                        ? 'Contoh: 6 cm'
                        : 'Contoh: 4 cm',
                    border: const OutlineInputBorder(),
                    suffixText: 'satuan',
                  ),
                  validator: (v) => _validatePositive(v, 'Nilai b'),
                ),
              ],
              const SizedBox(height: 24),
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'Hasil Perhitungan',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            Icons.square_foot,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text('Luas'),
                          trailing: Text(
                            '${_luas!.toStringAsFixed(2)} satuan²',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.linear_scale,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text('Keliling'),
                          trailing: Text(
                            '${_keliling!.toStringAsFixed(2)} satuan',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (_hipotenusa != null)
                          ListTile(
                            leading: Icon(
                              Icons.arrow_right_alt,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const Text('Sisi Miring (c)'),
                            trailing: Text(
                              '${_hipotenusa!.toStringAsFixed(2)} satuan',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
