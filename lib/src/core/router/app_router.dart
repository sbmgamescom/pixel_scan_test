import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_scan_test/src/core/services/revenue_cat_service.dart';
import 'package:pixel_scan_test/src/ui/onboarding/widgets/onboarding_screen.dart';
import 'package:pixel_scan_test/src/ui/pdf/widgets/pdf_screen.dart';
import 'package:pixel_scan_test/src/ui/subscription/viewmodel/subscription_viewmodel.dart';
import 'package:pixel_scan_test/src/ui/subscription/widgets/paywall_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final RevenueCatService _revenueCatService = RevenueCatService();

  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => OnboardingScreen(
          onCompleted: () {
            context.go('/home');
          },
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const PdfScreen(),
        redirect: (context, state) {
          // Проверяем, нужно ли показать paywall при запуске приложения
          final subscriptionViewModel = context.read<SubscriptionViewModel>();
          if (subscriptionViewModel.shouldShowPaywall()) {
            // Можно добавить логику показа paywall при определенных условиях
            return null; // Пока позволяем переход
          }
          return null;
        },
      ),
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PaywallScreen(
            title: extra?['title'] ?? 'Перейти на Премиум',
            subtitle: extra?['subtitle'] ?? 'Разблокируйте все возможности',
            showSkipButton: extra?['showSkipButton'] ?? false,
            onPurchaseSuccess: () {
              context.pop();
            },
            onSkip: extra?['onSkip'],
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Страница не найдена',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    ),
  );

  static Future<void> initializeRevenueCat() async {
    await _revenueCatService.initialize();
  }

  static RevenueCatService get revenueCatService => _revenueCatService;
}
