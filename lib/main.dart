import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/models/subscription_models.dart';
import 'src/core/services/subscription_service.dart';
import 'src/ui/onboarding/onboarding_screen.dart';
import 'src/ui/paywall/paywall_screen.dart';
import 'src/ui/pdf/widgets/pdf_screen.dart';

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
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _hasShownLaunchPaywall = false;

  @override
  void initState() {
    super.initState();
    // Проверяем первый запуск и показываем соответствующий экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunchAndShowScreen();
    });
  }

  Future<void> _checkFirstLaunchAndShowScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      // Первый запуск - показываем onboarding
      await prefs.setBool('is_first_launch', false);
      _showOnboarding();
    } else {
      // Не первый запуск - показываем paywall для не-премиум пользователей
      _checkAndShowLaunchPaywall();
    }
  }

  void _showOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingScreen(
          onCompleted: () {
            Navigator.pop(context); // Закрываем onboarding
          },
        ),
      ),
    );
  }

  void _checkAndShowLaunchPaywall() {
    final subscriptionService = context.read<SubscriptionService>();
    if (!subscriptionService.isPremiumUser && !_hasShownLaunchPaywall) {
      _hasShownLaunchPaywall = true;
      _showLaunchPaywall();
    }
  }

  void _showLaunchPaywall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaywallScreen(source: 'launch'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSubscriptionInfo>(
      builder: (context, userInfo, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Pixel Scanner'),
            backgroundColor: userInfo.isPremium ? Colors.amber : Colors.blue,
            actions: [
              IconButton(
                icon: Icon(
                  userInfo.isPremium ? Icons.star : Icons.star_border,
                  color: userInfo.isPremium ? Colors.orange : Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaywallScreen(source: 'main'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  userInfo.isPremium ? Icons.star : Icons.star_border,
                  size: 100,
                  color: userInfo.isPremium ? Colors.amber : Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  userInfo.isPremium ? 'Premium User ⭐' : 'Free User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: userInfo.isPremium ? Colors.amber : Colors.grey[600],
                  ),
                ),
                if (userInfo.isPremium && userInfo.expirationDate != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Expires: ${userInfo.expirationDate!.day}/${userInfo.expirationDate!.month}/${userInfo.expirationDate!.year}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PdfScreen()),
                    );
                  },
                  child: Text('Start Scanning'),
                ),
                if (!userInfo.isPremium) ...[
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaywallScreen(source: 'main'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Upgrade to Premium'),
                  ),
                ],

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Onboarding to Premium'),
                ),
                SizedBox(height: 20),
                // Тестовые кнопки
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<SubscriptionService>().simulatePremium();
                      },
                      child: Text('Test Premium'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<SubscriptionService>()
                            .simulateNonPremium();
                      },
                      child: Text('Test Free'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
