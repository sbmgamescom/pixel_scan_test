import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/subscription_viewmodel.dart';
import 'paywall_screen.dart';

class PremiumGuard extends StatelessWidget {
  final Widget child;
  final String? paywallTitle;
  final String? paywallSubtitle;
  final VoidCallback? onPremiumRequired;

  const PremiumGuard({
    super.key,
    required this.child,
    this.paywallTitle,
    this.paywallSubtitle,
    this.onPremiumRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isPremiumUser) {
          return child;
        }

        return GestureDetector(
          onTap: () => _showPaywall(context, viewModel),
          child: child,
        );
      },
    );
  }

  void _showPaywall(BuildContext context, SubscriptionViewModel viewModel) {
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
        ),
      ),
    );
  }
}

class PremiumFeature extends StatelessWidget {
  final Widget child;
  final Widget? premiumWidget;
  final String? paywallTitle;
  final String? paywallSubtitle;

  const PremiumFeature({
    super.key,
    required this.child,
    this.premiumWidget,
    this.paywallTitle,
    this.paywallSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isPremiumUser) {
          return child;
        }

        return premiumWidget ?? _buildLockedFeature(context, viewModel);
      },
    );
  }

  Widget _buildLockedFeature(
      BuildContext context, SubscriptionViewModel viewModel) {
    return GestureDetector(
      onTap: () => _showPaywall(context, viewModel),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: child,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Премиум',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaywall(BuildContext context, SubscriptionViewModel viewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaywallScreen(
          title: paywallTitle ?? 'Премиум функция',
          subtitle: paywallSubtitle ??
              'Эта функция доступна только для премиум пользователей',
        ),
      ),
    );
  }
}
