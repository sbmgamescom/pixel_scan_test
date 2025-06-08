import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pixel_scan_test/src/components/loading_overlay.dart';
import 'package:pixel_scan_test/src/core/config/icons.dart';
import 'package:pixel_scan_test/src/core/config/images.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/services/subscription_service.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'onboarding_page_widget.dart';
import 'paywall_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onCompleted;
  final bool showPaywallOnly; // Если true, показываем только paywall

  const OnboardingScreen({
    super.key,
    this.onCompleted,
    this.showPaywallOnly = false,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingViewModel _viewModel;
  String? _selectedProductId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _loadProducts();

    // Если нужно показать только paywall, переходим к нему
    if (widget.showPaywallOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewModel.skipToPaywall();
      });
    }
  }

  Future<void> _loadProducts() async {
    final subscriptionService = context.read<SubscriptionService>();
    try {
      final products = await subscriptionService.getAvailableProducts();
      setState(() {
        _selectedProductId = products
            .firstWhere((p) => p.isRecommended, orElse: () => products.first)
            .productId;
      });
      _viewModel.setSelectedProductId(_selectedProductId);
      _viewModel.setProductsLoading(false);
    } catch (e) {
      setState(() {});
      _viewModel.setProductsLoading(false);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<OnboardingViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    // Контент страниц (прокручиваемая область)
                    Expanded(
                      child: Stack(
                        children: [
                          // Фоновое SVG изображение
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              AppImages.onboardingBg,
                              width: 184.57,
                              height: 281.49,
                              fit: BoxFit.contain,
                            ),
                          ),

                          PageView.builder(
                            controller: viewModel.pageController,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (index) =>
                                viewModel.setCurrentPage(index),
                            itemCount: viewModel.totalPages,
                            itemBuilder: (context, index) {
                              if (index == viewModel.onboardingPages.length) {
                                return PaywallPageWidget(
                                  onPurchaseSuccess: () {
                                    Navigator.pop(context, true);
                                    if (widget.onCompleted != null) {
                                      widget.onCompleted!();
                                    }
                                  },
                                );
                              }

                              final pageData = viewModel.onboardingPages[index];
                              return OnboardingPageWidget(
                                pageData: pageData,
                                pageIndex: index,
                              );
                            },
                          ),

                          // Фиксированные индикаторы страниц
                          Positioned(
                            left: 28,
                            top: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                viewModel.totalPages,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  height:
                                      viewModel.currentPage == index ? 32 : 12,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: viewModel.currentPage == index
                                        ? Color(0xFFFD1524)
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (viewModel.isPaywallPage) ...[
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 0,
                              child: Column(
                                children: [
                                  pricingItem(
                                    isSelected: viewModel.selectedPrice == 0,
                                    title: 'Week',
                                    subtitle: '3-Day Free Trial',
                                    price: "1.99\$",
                                    onTap: () {
                                      viewModel.selectPrice(0);
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  pricingItem(
                                    isSelected: viewModel.selectedPrice == 1,
                                    title: 'Year',
                                    subtitle: null,
                                    price: "10.99\$",
                                    onTap: () {
                                      viewModel.selectPrice(1);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ],
                      ),
                    ),

                    // Фиксированная нижняя панель
                    _buildBottomPanel(viewModel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  GestureDetector pricingItem({
    required String title,
    required String price,
    required String? subtitle,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        // height: 56,
        padding: EdgeInsets.only(
          left: 14,
          right: 16,
          top: 4,
          bottom: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xffFD1524) : Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: subtitle != null ? 4 : 17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              Text(
                price,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(OnboardingViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Кнопка Continue

        Padding(
          padding: EdgeInsets.only(bottom: viewModel.isPaywallPage ? 0 : 40.0),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                // Многослойная тень
                BoxShadow(
                  color: Color(0xB5C20F0F), // #C20F0FB5
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x9CC20F0F), // #C20F0F9C
                  offset: Offset(0, 3),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x5CC20F0F), // #C20F0F5C
                  offset: Offset(0, 8),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x1CC20F0F), // #C20F0F1C
                  offset: Offset(0, 13),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x03C20F0F), // #C20F0F03
                  offset: Offset(0, 21),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              onPressed:
                  viewModel.currentPage == viewModel.onboardingPages.length
                      ? (_isLoading ? null : _purchaseSelected)
                      : (viewModel.isLastOnboardingPage
                          ? () => viewModel.goToPaywall()
                          : () => viewModel.nextPage()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFD1524),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    viewModel.currentPage == viewModel.onboardingPages.length
                        ? 'Start Free Trial'
                        : 'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12),
                  SvgPicture.asset(
                    AppIcons.arrowRight,
                    // size: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Дополнительные ссылки только для paywall
        if (viewModel.currentPage == viewModel.onboardingPages.length) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _isLoading ? null : _restorePurchases,
                child: Text(
                  'Restore',
                  style: TextStyle(
                    color: Color(0xff8B7979),
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.grey[400],
              ),
              TextButton(
                onPressed: () async {
                  await launchUrlString('https://google.com');
                },
                child: Text(
                  'Privacy',
                  style: TextStyle(
                    color: Color(0xff8B7979),
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 16,
                color: Color(0xff8B7979),
              ),
              TextButton(
                onPressed: () async {
                  await launchUrlString('https://google.com');
                },
                child: Text(
                  'Terms',
                  style: TextStyle(
                    color: Color(0xff8B7979),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ],
    );
  }

  Future<void> _purchaseSelected() async {
    if (_selectedProductId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final subscriptionService = context.read<SubscriptionService>();
      final success =
          await subscriptionService.purchaseProduct(_selectedProductId!);

      if (success && mounted) {
        // Закрываем onboarding и возвращаемся в main
        Navigator.pop(context, true);
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Welcome to Premium!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final subscriptionService = context.read<SubscriptionService>();
      final success = await subscriptionService.restorePurchases();

      if (success && mounted) {
        Navigator.pop(context, true);
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Purchases restored successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Активные подписки не найдены'),
            content: Text(
                'Мы не смогли найти активные подписки для восстановления. Пожалуйста, оформите новую подписку или убедитесь, что вы используете тот же Apple ID.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Понятно'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка восстановления: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
