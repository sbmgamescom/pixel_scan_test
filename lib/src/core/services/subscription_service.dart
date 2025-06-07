import 'dart:async';
import 'dart:developer';
import 'dart:math';

import '../models/subscription_models.dart';

class SubscriptionService {
  bool _isPremium = false;
  String? _activeProductId;
  DateTime? _expirationDate;

  final StreamController<UserSubscriptionInfo> _subscriptionController =
      StreamController<UserSubscriptionInfo>.broadcast();

  Stream<UserSubscriptionInfo> get subscriptionStream =>
      _subscriptionController.stream;

  UserSubscriptionInfo get currentSubscriptionInfo => UserSubscriptionInfo(
        status:
            _isPremium ? SubscriptionStatus.active : SubscriptionStatus.none,
        activeProductId: _activeProductId,
        isPremium: _isPremium,
        expirationDate: _expirationDate,
      );

  Future<void> initialize() async {
    await Future.delayed(Duration(milliseconds: 500));

    // Симуляция проверки сохраненной подписки
    _checkSavedSubscription();
    _subscriptionController.add(currentSubscriptionInfo);
  }

  void _checkSavedSubscription() {
    // Здесь можно добавить проверку SharedPreferences
    // Пока просто симулируем
  }

  Future<List<SubscriptionModel>> getAvailableProducts() async {
    await Future.delayed(Duration(seconds: 1));

    return [
      SubscriptionModel(
        productId: 'weekly_premium',
        title: 'Weekly Premium',
        description: 'Perfect for trying out all features',
        price: '\$2.99',
        period: 'week',
        isActive: false,
        trialPeriod: null,
        isRecommended: false,
      ),
      SubscriptionModel(
        productId: 'monthly_premium',
        title: 'Monthly Premium',
        description: 'Great for regular users',
        price: '\$9.99',
        period: 'month',
        isActive: false,
        trialPeriod: '3 days free',
        isRecommended: false,
      ),
      SubscriptionModel(
        productId: 'yearly_premium',
        title: 'Yearly Premium',
        description: 'Best value for power users',
        price: '\$59.99',
        period: 'year',
        isActive: true,
        trialPeriod: '7 days free',
        isRecommended: true,
      ),
    ];
  }

  Future<bool> purchaseProduct(String productId) async {
    await Future.delayed(Duration(seconds: 3)); // Симуляция покупки

    // Симуляция случайного успеха/неудачи (90% успеха)
    final random = Random();
    final success = random.nextInt(10) < 9;

    if (success) {
      _isPremium = true;
      _activeProductId = productId;
      _expirationDate = _calculateExpirationDate(productId);

      _subscriptionController.add(currentSubscriptionInfo);
      return true;
    } else {
      return false;
    }
  }

  DateTime _calculateExpirationDate(String productId) {
    final now = DateTime.now();
    switch (productId) {
      case 'weekly_premium':
        return now.add(Duration(days: 7));
      case 'monthly_premium':
        return now.add(Duration(days: 30));
      case 'yearly_premium':
        return now.add(Duration(days: 365));
      default:
        return now.add(Duration(days: 30));
    }
  }

  Future<bool> restorePurchases() async {
    await Future.delayed(Duration(seconds: 2));

    // Симуляция восстановления (70% успеха)
    final random = Random();
    final hasActivePurchases = random.nextInt(10) < 7;

    if (hasActivePurchases) {
      _isPremium = true;
      _activeProductId = 'yearly_premium'; // Симуляция найденной подписки
      _expirationDate = DateTime.now().add(Duration(days: 300));

      _subscriptionController.add(currentSubscriptionInfo);
      return true;
    } else {
      return false;
    }
  }

  bool get isPremiumUser => _isPremium;

  void dispose() {
    _subscriptionController.close();
  }

  // Методы для тестирования
  void simulatePremium() {
    _isPremium = true;
    _activeProductId = 'yearly_premium';
    _expirationDate = DateTime.now().add(Duration(days: 365));
    _subscriptionController.add(currentSubscriptionInfo);
  }

  void simulateNonPremium() {
    _isPremium = false;
    _activeProductId = null;
    _expirationDate = null;
    _subscriptionController.add(currentSubscriptionInfo);
  }

  void reset() {
    _isPremium = false;
    _activeProductId = null;
    _expirationDate = null;
    _subscriptionController.add(currentSubscriptionInfo);
  }
}
