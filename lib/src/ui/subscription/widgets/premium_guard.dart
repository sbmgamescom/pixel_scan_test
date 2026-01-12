import 'package:flutter/material.dart';

import '../../../core/services/subscription_service.dart';
import 'paywall_screen.dart';

class PremiumGuard extends StatelessWidget {
  final Widget child;
  final String? paywallTitle;
  final String? paywallSubtitle;
  final VoidCallback? onPremiumRequired;
  final SubscriptionService subscriptionService;

  const PremiumGuard({
    super.key,
    required this.child,
    this.paywallTitle,
    this.paywallSubtitle,
    this.onPremiumRequired,
    required this.subscriptionService,
  });

  @override
  Widget build(BuildContext context) {
    if (subscriptionService.isPremiumUser) {
      return child;
    }

    return GestureDetector(
      onTap: () => _showPaywall(context),
      child: child,
    );
  }

  void _showPaywall(BuildContext context) {
    onPremiumRequired?.call();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaywallScreen(
          title: paywallTitle ?? 'Премиум функция',
          subtitle: paywallSubtitle ??
              'Эта функция доступна только для премиум пользователей',
          onPurchaseSuccess: () {
            // Навигация обратно будет обработана автоматически
          },
          source: '',
          subscriptionService: subscriptionService,
        ),
      ),
    );
  }
}
