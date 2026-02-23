import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixel_scan_test/src/ui/home/widgets/home_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'l10n/app_localizations.dart';
import 'src/core/config/theme.dart';
import 'src/core/router/app_navigator.dart';
import 'src/core/services/subscription_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final subscriptionService = SubscriptionService();
  await subscriptionService.initialize();

  runApp(MyApp(subscriptionService: subscriptionService));
}

class MyApp extends StatelessWidget {
  final SubscriptionService subscriptionService;

  const MyApp({super.key, required this.subscriptionService});

  @override
  Widget build(BuildContext context) {
    final appNavigator = AppNavigator();

    return ShadApp.custom(
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      appBuilder: (context) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context),
          builder: (context, child) {
            return ShadToaster(
              child: ShadAppBuilder(child: child!),
            );
          },
          home: MainScreen(
            subscriptionService: subscriptionService,
            appNavigator: appNavigator,
          ),
        );
      },
    );
  }
}
