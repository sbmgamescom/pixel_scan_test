import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:pixel_scan_test/src/core/models/subscription_model.dart';
import 'package:pixel_scan_test/src/core/services/revenue_cat_service.dart';

class SubscriptionViewModel extends ChangeNotifier {
  final RevenueCatService _revenueCatService;

  SubscriptionViewModel(this._revenueCatService) {
    _subscriptionSubscription = _revenueCatService.subscriptionStream.listen(
      (subscriptionInfo) {
        _userSubscriptionInfo = subscriptionInfo;
        notifyListeners();
      },
    );
    _loadInitialData();
  }

  StreamSubscription<UserSubscriptionInfo>? _subscriptionSubscription;

  List<SubscriptionModel> _availableProducts = [];
  UserSubscriptionInfo _userSubscriptionInfo = UserSubscriptionInfo.none();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPurchasing = false;

  // Getters
  List<SubscriptionModel> get availableProducts => _availableProducts;
  UserSubscriptionInfo get userSubscriptionInfo => _userSubscriptionInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPurchasing => _isPurchasing;
  bool get isPremiumUser => _userSubscriptionInfo.isPremium;

  Future<void> _loadInitialData() async {
    await loadAvailableProducts();
  }

  Future<void> loadAvailableProducts() async {
    _setLoading(true);
    _clearError();

    try {
      _availableProducts = await _revenueCatService.getAvailableProducts();
      log('Loaded ${_availableProducts.length} subscription products');
    } catch (e) {
      _setError('Не удалось загрузить доступные подписки: $e');
      log('Failed to load products: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> purchaseSubscription(String productId) async {
    if (_isPurchasing) return false;

    _setPurchasing(true);
    _clearError();

    try {
      final success = await _revenueCatService.purchaseProduct(productId);

      if (success) {
        log('Successfully purchased subscription: $productId');
        return true;
      } else {
        _setError('Покупка была отменена');
        return false;
      }
    } catch (e) {
      _setError('Ошибка при покупке: $e');
      log('Purchase error: $e');
      return false;
    } finally {
      _setPurchasing(false);
    }
  }

  Future<bool> restorePurchases() async {
    if (_isPurchasing) return false;

    _setPurchasing(true);
    _clearError();

    try {
      final restored = await _revenueCatService.restorePurchases();

      if (restored) {
        log('Successfully restored purchases');
      } else {
        _setError('Не найдено активных подписок для восстановления');
      }

      return restored;
    } catch (e) {
      _setError('Ошибка при восстановлении покупок: $e');
      log('Restore error: $e');
      return false;
    } finally {
      _setPurchasing(false);
    }
  }

  SubscriptionModel? getProductById(String productId) {
    try {
      return _availableProducts.firstWhere(
        (product) => product.productId == productId,
      );
    } catch (e) {
      return null;
    }
  }

  String getSubscriptionStatusText() {
    switch (_userSubscriptionInfo.status) {
      case SubscriptionStatus.active:
        return 'Активная подписка';
      case SubscriptionStatus.inTrial:
        return 'Пробный период';
      case SubscriptionStatus.inGracePeriod:
        return 'Льготный период';
      case SubscriptionStatus.expired:
        return 'Подписка истекла';
      case SubscriptionStatus.cancelled:
        return 'Подписка отменена';
      case SubscriptionStatus.none:
        return 'Нет активной подписки';
    }
  }

  bool shouldShowPaywall() {
    return !_userSubscriptionInfo.isPremium;
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setPurchasing(bool purchasing) {
    if (_isPurchasing != purchasing) {
      _isPurchasing = purchasing;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearError() => _clearError();

  @override
  void dispose() {
    _subscriptionSubscription?.cancel();
    super.dispose();
  }
}
