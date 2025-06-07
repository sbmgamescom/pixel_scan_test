class SubscriptionModel {
  final String productId;
  final String title;
  final String description;
  final String price;
  final String period;
  final bool isActive;
  final String? trialPeriod;

  const SubscriptionModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.period,
    required this.isActive,
    this.trialPeriod,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      productId: json['productId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      period: json['period'] ?? '',
      isActive: json['isActive'] ?? false,
      trialPeriod: json['trialPeriod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'description': description,
      'price': price,
      'period': period,
      'isActive': isActive,
      'trialPeriod': trialPeriod,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriptionModel &&
        other.productId == productId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => productId.hashCode ^ isActive.hashCode;
}

enum SubscriptionStatus {
  none,
  active,
  expired,
  cancelled,
  inGracePeriod,
  inTrial,
}

class UserSubscriptionInfo {
  final SubscriptionStatus status;
  final String? activeProductId;
  final DateTime? expirationDate;
  final DateTime? originalPurchaseDate;
  final bool isPremium;

  const UserSubscriptionInfo({
    required this.status,
    this.activeProductId,
    this.expirationDate,
    this.originalPurchaseDate,
    required this.isPremium,
  });

  factory UserSubscriptionInfo.none() {
    return const UserSubscriptionInfo(
      status: SubscriptionStatus.none,
      isPremium: false,
    );
  }

  UserSubscriptionInfo copyWith({
    SubscriptionStatus? status,
    String? activeProductId,
    DateTime? expirationDate,
    DateTime? originalPurchaseDate,
    bool? isPremium,
  }) {
    return UserSubscriptionInfo(
      status: status ?? this.status,
      activeProductId: activeProductId ?? this.activeProductId,
      expirationDate: expirationDate ?? this.expirationDate,
      originalPurchaseDate: originalPurchaseDate ?? this.originalPurchaseDate,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
