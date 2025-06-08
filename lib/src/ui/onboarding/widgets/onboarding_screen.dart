import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pixel_scan_test/src/core/config/icons.dart';
import 'package:pixel_scan_test/src/core/config/images.dart';
import 'package:provider/provider.dart';

import '../../../core/services/subscription_service.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'onboarding_page_widget.dart';

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
  bool _isProductsLoading = true;

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
        _isProductsLoading = false;
      });
      _viewModel.setSelectedProductId(_selectedProductId);
      _viewModel.setProductsLoading(false);
    } catch (e) {
      setState(() {
        _isProductsLoading = false;
      });
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
    return ChangeNotifierProvider.value(
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
                          onPageChanged: (index) =>
                              viewModel.setCurrentPage(index),
                          itemCount: viewModel.totalPages,
                          itemBuilder: (context, index) {
                            if (index == viewModel.onboardingPages.length) {
                              return _buildPaywallPage();
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
                                margin: const EdgeInsets.symmetric(vertical: 4),
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
    );
  }

  Widget _buildBottomPanel(OnboardingViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Кнопка Continue
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Container(
            width: double.infinity,
            height: 56,
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
              child:
                  viewModel.currentPage == viewModel.onboardingPages.length &&
                          _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              viewModel.currentPage ==
                                      viewModel.onboardingPages.length
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
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.grey[400],
              ),
              TextButton(
                onPressed: () {
                  // Privacy policy
                },
                child: Text(
                  'Privacy',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.grey[400],
              ),
              TextButton(
                onPressed: () {
                  // Terms
                },
                child: Text(
                  'Terms',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          // Индикатор внизу (как на iPhone)
          Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          SizedBox(height: 10),
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

  Widget _buildPaywallPage() {
    if (_isProductsLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading subscriptions...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPaywallHeader(),
          SizedBox(height: 40),
          _buildSubscriptionOptions(),
        ],
      ),
    );
  }

  Widget _buildPaywallHeader() {
    return Column(
      children: [
        // Иллюстрация как на изображении
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            children: [
              // Фоновые декоративные элементы
              Positioned(
                top: 20,
                right: 30,
                child: _buildDecoElement(size: 20, color: Color(0xFFE57373)),
              ),
              Positioned(
                top: 50,
                right: 80,
                child: _buildDecoElement(size: 30, color: Color(0xFFFFB74D)),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: _buildDecoElement(size: 25, color: Color(0xFFE57373)),
              ),
              Positioned(
                top: 150,
                right: 60,
                child: _buildDecoElement(size: 15, color: Color(0xFFFFB74D)),
              ),

              // Основная иллюстрация документа
              Center(
                child: Container(
                  width: 200,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Шапка документа с крестиком
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFE57373),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Color(0xFFE57373),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Содержимое документа
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Строки текста
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE57373),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 8,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFB74D),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 8,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE57373),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 8,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFB74D),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 16),
                              // Горизонтальная линия
                              Container(
                                height: 2,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              // Нижние строки
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ракета
              Positioned(
                right: 40,
                top: 120,
                child: Transform.rotate(
                  angle: 0.3,
                  child: SizedBox(
                    width: 60,
                    height: 80,
                    child: Stack(
                      children: [
                        // Тело ракеты
                        Container(
                          width: 40,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFE57373),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        // Окошко ракеты
                        Positioned(
                          top: 15,
                          left: 10,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Пламя
                        Positioned(
                          bottom: 0,
                          left: 8,
                          child: Container(
                            width: 24,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFB74D),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        // Полоски дыма
                        Positioned(
                          right: -10,
                          top: 30,
                          child: Container(
                            width: 15,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -15,
                          top: 40,
                          child: Container(
                            width: 12,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),
        Text(
          'Ultimate',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'PDF',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE57373),
                ),
              ),
              TextSpan(
                text: ' Scanner',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Get unlimited scans,\nadvanced editing, and\nan ad-free experience',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDecoElement({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSubscriptionOptions() {
    return Column(
      children: [
        // Weekly option (без выделения)
        Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Week',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '3-Day Free Trial',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                '1.99\$',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        // Yearly option (выделенная)
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedProductId = 'yearly_premium';
            });
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE57373), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE57373).withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Year',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  '10.99\$',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
