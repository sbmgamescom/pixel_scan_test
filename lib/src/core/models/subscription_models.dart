enum SubscriptionStatus {
  none,
  active,
  expired,
  trial,
}

class SubscriptionModel {
  final String productId;
  final String title;
  final String description;
  final String price;
  final String period;
  final bool isActive;
  final String? trialPeriod;
  final bool isRecommended;

  const SubscriptionModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.period,
    this.isActive = false,
    this.trialPeriod,
    this.isRecommended = false,
  });
}

class UserSubscriptionInfo {
  final SubscriptionStatus status;
  final String? activeProductId;
  final bool isPremium;
  final DateTime? expirationDate;

  const UserSubscriptionInfo({
    required this.status,
    this.activeProductId,
    required this.isPremium,
    this.expirationDate,
  });
}
