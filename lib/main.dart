import 'package:flutter/material.dart';
import 'package:pixel_scan_test/src/ui/home/widgets/home_screen.dart';
import 'package:provider/provider.dart';

import 'src/core/models/subscription_models.dart';
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
    return MultiProvider(
      providers: [
        Provider<SubscriptionService>.value(value: subscriptionService),
        StreamProvider<UserSubscriptionInfo>(
          create: (_) => subscriptionService.subscriptionStream,
          initialData: subscriptionService.currentSubscriptionInfo,
        ),
      ],
      child: MaterialApp(
        title: 'Pixel Scan Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'SF Pro Display', // Статический SF Pro шрифт
        ),
        home: const MainScreen(),
      ),
    );
  }
}
