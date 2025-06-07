import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/subscription_model.dart';

class RevenueCatService {
  static const String _apiKey =
      'YOUR_REVENUE_CAT_API_KEY'; // Замените на ваш API ключ

  // Product IDs для ваших подписок
  static const String weeklyProductId = 'weekly_premium';
  static const String monthlyProductId = 'monthly_premium';
  static const String yearlyProductId = 'yearly_premium';

  bool _isInitialized = false;
  final StreamController<UserSubscriptionInfo> _subscriptionController =
      StreamController<UserSubscriptionInfo>.broadcast();

  Stream<UserSubscriptionInfo> get subscriptionStream =>
      _subscriptionController.stream;

  UserSubscriptionInfo _currentSubscriptionInfo = UserSubscriptionInfo.none();
  UserSubscriptionInfo get currentSubscriptionInfo => _currentSubscriptionInfo;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
      await Purchases.configure(configuration);

      // Добавляем слушатель изменений подписки
      Purchases.addCustomerInfoUpdateListener(_handleCustomerInfoUpdate);

      // Проверяем текущую подписку
      await _updateSubscriptionInfo();

      _isInitialized = true;
      log('RevenueCat initialized successfully');
    } catch (e) {
      log('Failed to initialize RevenueCat: $e');
      rethrow;
    }
  }

  Future<void> _updateSubscriptionInfo() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final subscriptionInfo = _parseCustomerInfo(customerInfo);
      _currentSubscriptionInfo = subscriptionInfo;
      _subscriptionController.add(subscriptionInfo);
    } catch (e) {
      log('Failed to update subscription info: $e');
      final fallbackInfo = UserSubscriptionInfo.none();
      _currentSubscriptionInfo = fallbackInfo;
      _subscriptionController.add(fallbackInfo);
    }
  }

  void _handleCustomerInfoUpdate(CustomerInfo customerInfo) {
    final subscriptionInfo = _parseCustomerInfo(customerInfo);
    _currentSubscriptionInfo = subscriptionInfo;
    _subscriptionController.add(subscriptionInfo);
  }

  UserSubscriptionInfo _parseCustomerInfo(CustomerInfo customerInfo) {
    final entitlements = customerInfo.entitlements;
    final premiumEntitlement = entitlements.all['premium'];

    if (premiumEntitlement == null || !premiumEntitlement.isActive) {
      return UserSubscriptionInfo.none();
    }

    SubscriptionStatus status;
    if (premiumEntitlement.willRenew) {
      status = SubscriptionStatus.active;
    } else if (premiumEntitlement.isActive) {
      status = SubscriptionStatus.inGracePeriod;
    } else {
      status = SubscriptionStatus.expired;
    }

    return UserSubscriptionInfo(
      status: status,
      activeProductId: premiumEntitlement.productIdentifier,
      isPremium: premiumEntitlement.isActive,
    );
  }

  Future<List<SubscriptionModel>> getAvailableProducts() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null) {
        return [];
      }

      final products = <SubscriptionModel>[];

      for (final package in currentOffering.availablePackages) {
        final storeProduct = package.storeProduct;

        products.add(SubscriptionModel(
          productId: storeProduct.identifier,
          title: storeProduct.title,
          description: storeProduct.description,
          price: storeProduct.priceString,
          period: _getPeriodFromPackageType(package.packageType),
          isActive: false,
          trialPeriod: storeProduct.introductoryPrice?.priceString,
        ));
      }

      return products;
    } catch (e) {
      log('Failed to get available products: $e');
      return [];
    }
  }

  String _getPeriodFromPackageType(PackageType packageType) {
    switch (packageType) {
      case PackageType.weekly:
        return 'week';
      case PackageType.monthly:
        return 'month';
      case PackageType.annual:
        return 'year';
      default:
        return 'unknown';
    }
  }

  Future<bool> purchaseProduct(String productId) async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering == null) {
        throw Exception('No offerings available');
      }

      Package? targetPackage;
      for (final package in currentOffering.availablePackages) {
        if (package.storeProduct.identifier == productId) {
          targetPackage = package;
          break;
        }
      }

      if (targetPackage == null) {
        throw Exception('Product not found');
      }

      final purchaserInfo = await Purchases.purchasePackage(targetPackage);

      if (purchaserInfo.entitlements.all['premium']?.isActive == true) {
        await _updateSubscriptionInfo();
        return true;
      }

      return false;
    } catch (e) {
      log('Purchase failed: $e');
      if (e is PlatformException) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          // Пользователь отменил покупку
          return false;
        }
      }
      rethrow;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      await _updateSubscriptionInfo();
      return customerInfo.entitlements.all['premium']?.isActive == true;
    } catch (e) {
      log('Restore purchases failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await Purchases.logOut();
      _currentSubscriptionInfo = UserSubscriptionInfo.none();
      _subscriptionController.add(_currentSubscriptionInfo);
    } catch (e) {
      log('Logout failed: $e');
    }
  }

  bool get isPremiumUser => _currentSubscriptionInfo.isPremium;

  void dispose() {
    _subscriptionController.close();
  }
}
