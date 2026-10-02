import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_mobile/main.dart';
import 'package:quiz_mobile/screens/home_screen.dart';
import 'package:quiz_mobile/screens/profile_screen.dart';

void main() {
  testWidgets('Navigasi MainShell berjalan benar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Beranda aktif (Menu Utama)
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Menu Utama'), findsOneWidget);

    // Tap Profile
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    // Profil aktif
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Profil Pengembang'), findsOneWidget);
  });
}
