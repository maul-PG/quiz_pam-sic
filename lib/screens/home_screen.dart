import 'package:flutter/material.dart';
import 'package:quiz_mobile/screens/day_checker_screen.dart';
import 'package:quiz_mobile/screens/pyramid_screen.dart';
import 'package:quiz_mobile/screens/time_conversion_screen.dart';
import 'package:quiz_mobile/screens/triangle_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Utama')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: const [
          _MenuListItem(
            title: 'Piramida',
            subtitle: 'Volume & Keliling',
            icon: Icons.change_history,
            destination: PyramidScreen(),
          ),
          SizedBox(height: 16),
          _MenuListItem(
            title: 'Segitiga',
            subtitle: '3 Jenis Segitiga',
            icon: Icons.architecture,
            destination: TriangleScreen(),
          ),
          SizedBox(height: 16),
          _MenuListItem(
            title: 'Konversi Waktu',
            subtitle: 'WIB, MYT, EDT',
            icon: Icons.access_time,
            destination: TimeConversionScreen(),
          ),
          SizedBox(height: 16),
          _MenuListItem(
            title: 'Cek Hari',
            subtitle: 'Input Angka 1-7',
            icon: Icons.calendar_today,
            destination: DayCheckerScreen(),
          ),
        ],
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  const _MenuListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => destination));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: theme.colorScheme.primary, width: 6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, size: 36, color: theme.colorScheme.primary),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
