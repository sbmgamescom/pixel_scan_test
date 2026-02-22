import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_scan_test/src/core/models/document_model.dart';
import 'package:pixel_scan_test/src/core/models/subscription_models.dart';
import 'package:pixel_scan_test/src/core/services/subscription_service.dart';
import 'package:pixel_scan_test/src/ui/pdf/widgets/pdf_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MockSubscriptionService implements SubscriptionService {
  bool _isPremium = false;

  void setPremium(bool value) {
    _isPremium = value;
  }

  @override
  bool get isPremiumUser => _isPremium;

  @override
  UserSubscriptionInfo get currentSubscriptionInfo =>
      const UserSubscriptionInfo(
        status: SubscriptionStatus.none,
        isPremium: false,
      );

  @override
  bool get isInitialized => true;

  @override
  bool get isConfigured => true;

  @override
  Future<bool> connect() async => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<List<SubscriptionModel>> getAvailableProducts() async => [
        const SubscriptionModel(
          productId: 'premium_monthly',
          title: 'Premium',
          description: 'Monthly',
          price: '\$9.99',
          period: 'P1M',
        )
      ];

  @override
  Future<bool> purchaseProduct(String productId) async => false;

  @override
  Future<bool> restorePurchases() async => false;

  @override
  Stream<UserSubscriptionInfo> get subscriptionStream => const Stream.empty();

  @override
  void simulatePremium() {}

  @override
  void simulateNonPremium() {}

  @override
  void reset() {}

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void dispose() {}

  @override
  bool get hasListeners => false;

  @override
  void notifyListeners() {}
}

void main() {
  group('PdfScreen Premium Guard Tests', () {
    late MockSubscriptionService mockSubscriptionService;
    late DocumentModel testDocument;

    setUp(() {
      mockSubscriptionService = MockSubscriptionService();
      testDocument = DocumentModel(
        id: '1',
        name: 'Test Doc',
        folderId: null,
        createdAt: DateTime.now(),
        imagePaths: ['placeholder'],
        editedImages: {},
      );
    });

    Widget createTestWidget() {
      return ShadApp(
        materialThemeBuilder: (context, theme) {
          return theme.copyWith(
            appBarTheme: const AppBarTheme(toolbarHeight: 52),
          );
        },
        home: Material(
          child: PdfScreen(
            subscriptionService: mockSubscriptionService,
            document: testDocument,
          ),
        ),
      );
    }

    testWidgets('Shows Paywall when free user taps Export, Print, or Share',
        (WidgetTester tester) async {
      mockSubscriptionService.setPremium(false); // Free user

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open the 'More options' bottom sheet menu
      final moreMenuIcon = find.byIcon(LucideIcons.ellipsisVertical);
      expect(moreMenuIcon, findsOneWidget);
      await tester.tap(moreMenuIcon);
      await tester.pumpAndSettle();

      // 1. Check Export
      final exportButton = find.text('Экспорт в PDF');
      expect(exportButton, findsOneWidget);
      await tester.tap(exportButton);
      await tester.pumpAndSettle();

      expect(find.text('Unlock Premium Features'), findsOneWidget);

      // Close paywall
      final closeButton = find.byIcon(LucideIcons.x);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      await tester.tap(moreMenuIcon);
      await tester.pumpAndSettle();

      // 2. Check Print
      final printButton = find.text('Печать');
      expect(printButton, findsOneWidget);
      await tester.tap(printButton);
      await tester.pumpAndSettle();

      expect(find.text('Unlock Premium Features'), findsOneWidget);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      await tester.tap(moreMenuIcon);
      await tester.pumpAndSettle();

      // 3. Check Share
      final shareButton = find.text('Поделиться');
      expect(shareButton, findsOneWidget);
      await tester.tap(shareButton);
      await tester.pumpAndSettle();

      expect(find.text('Unlock Premium Features'), findsOneWidget);
    });

    testWidgets('Premium users see Export Dialog instead of Paywall',
        (WidgetTester tester) async {
      mockSubscriptionService.setPremium(true); // Premium user

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final moreMenuIcon = find.byIcon(LucideIcons.ellipsisVertical);
      await tester.tap(moreMenuIcon);
      await tester.pumpAndSettle();

      final exportButton = find.text('Экспорт в PDF');
      await tester.tap(exportButton);
      await tester.pumpAndSettle();

      // Should show the Export Settings Dialog, NOT Paywall
      expect(find.text('Настройки экспорта PDF'), findsOneWidget);
      expect(find.text('Unlock Premium Features'), findsNothing);
    });
  });
}
