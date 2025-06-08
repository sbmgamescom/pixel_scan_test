import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

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

    // Загружаем сохраненное состояние подписки
    await _loadSubscriptionState();
    _subscriptionController.add(currentSubscriptionInfo);
  }

  Future<void> _loadSubscriptionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool('isPremium') ?? false;
      _activeProductId = prefs.getString('activeProductId');

      final expirationMillis = prefs.getInt('expirationDate');
      if (expirationMillis != null) {
        _expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationMillis);

        // Проверяем, не истекла ли подписка
        if (_expirationDate != null &&
            _expirationDate!.isBefore(DateTime.now())) {
          _isPremium = false;
          _activeProductId = null;
          _expirationDate = null;
          await _saveSubscriptionState(); // Очищаем истекшую подписку
        }
      }
    } catch (e) {
      dev.log('Ошибка загрузки состояния подписки: $e');
    }
  }

  Future<void> _saveSubscriptionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPremium', _isPremium);

      if (_activeProductId != null) {
        await prefs.setString('activeProductId', _activeProductId!);
      } else {
        await prefs.remove('activeProductId');
      }

      if (_expirationDate != null) {
        await prefs.setInt(
            'expirationDate', _expirationDate!.millisecondsSinceEpoch);
      } else {
        await prefs.remove('expirationDate');
      }
    } catch (e) {
      dev.log('Ошибка сохранения состояния подписки: $e');
    }
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

      await _saveSubscriptionState(); // Сохраняем состояние
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

      await _saveSubscriptionState(); // Сохраняем состояние
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
  void simulatePremium() async {
    _isPremium = true;
    _activeProductId = 'yearly_premium';
    _expirationDate = DateTime.now().add(Duration(days: 365));
    await _saveSubscriptionState();
    _subscriptionController.add(currentSubscriptionInfo);
  }

  void simulateNonPremium() async {
    _isPremium = false;
    _activeProductId = null;
    _expirationDate = null;
    await _saveSubscriptionState();
    _subscriptionController.add(currentSubscriptionInfo);
  }

  void reset() async {
    _isPremium = false;
    _activeProductId = null;
    _expirationDate = null;
    await _saveSubscriptionState();
    _subscriptionController.add(currentSubscriptionInfo);
  }
}
