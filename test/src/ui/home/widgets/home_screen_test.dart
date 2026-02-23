import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_scan_test/l10n/app_localizations.dart';
import 'package:pixel_scan_test/src/core/router/app_navigator.dart';
import 'package:pixel_scan_test/src/core/services/subscription_service.dart';
import 'package:pixel_scan_test/src/ui/home/widgets/home_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSubscriptionService implements SubscriptionService {
  @override
  bool get isPremiumUser => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAppNavigator implements AppNavigator {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '.';
    });

    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MainScreen renders empty state', (WidgetTester tester) async {
    final subscriptionService = MockSubscriptionService();
    final appNavigator = MockAppNavigator();

    await tester.pumpWidget(
      ShadApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainScreen(
          subscriptionService: subscriptionService,
          appNavigator: appNavigator,
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Pixel Scan'), findsOneWidget);
    expect(find.text('No documents'), findsOneWidget);
  });
}
