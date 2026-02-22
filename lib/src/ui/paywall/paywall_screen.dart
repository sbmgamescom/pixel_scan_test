import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../src/components/loading_overlay.dart';
import '../../core/models/subscription_models.dart';
import '../../core/services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  final String source; // onboarding, launch, print, share
  final SubscriptionService subscriptionService;

  const PaywallScreen({
    super.key,
    required this.source,
    required this.subscriptionService,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<SubscriptionModel> _products = [];
  String? _selectedProductId;
  bool _isLoading = false;
  bool _isProductsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await widget.subscriptionService.getAvailableProducts();
      setState(() {
        _products = products;
        _selectedProductId =
            products.firstWhere((p) => p.isRecommended).productId;
        _isProductsLoading = false;
      });
    } catch (e) {
      setState(() {
        _isProductsLoading = false;
      });
    }
  }

  Future<void> _purchaseSelected() async {
    if (_selectedProductId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success =
          await widget.subscriptionService.purchaseProduct(_selectedProductId!);

      if (success && mounted) {
        Navigator.pop(context, true);
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('🎉 Добро пожаловать в Premium!'),
            description: Text('Теперь вам доступны все функции'),
          ),
        );
      } else if (mounted) {
        ShadToaster.of(context).show(
          const ShadToast.destructive(
            title: Text('Ошибка'),
            description: Text('Покупка не удалась. Попробуйте ещё раз.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка'),
            description: Text('Ошибка: $e'),
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
      final success = await widget.subscriptionService.restorePurchases();

      if (success && mounted) {
        Navigator.pop(context, true);
        ShadToaster.of(context).show(
          const ShadToast(
            title: Text('✅ Покупки восстановлены!'),
            description: Text('Ваша подписка активирована'),
          ),
        );
      } else if (mounted) {
        showShadDialog(
          context: context,
          builder: (context) => ShadDialog.alert(
            title: const Text('Активные подписки не найдены'),
            description: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Мы не смогли найти активные подписки для восстановления. '
                'Пожалуйста, оформите новую подписку или убедитесь, что вы используете тот же Apple ID.',
              ),
            ),
            actions: [
              ShadButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Понятно'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Ошибка восстановления'),
            description: Text('$e'),
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

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                // Кнопка закрытия
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      ShadIconButton.ghost(
                        icon: const Icon(LucideIcons.x, size: 24),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ],
                  ),
                ),

                // Контент
                Expanded(
                  child: _isProductsLoading ? _buildLoading() : _buildContent(),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildLoading() {
    final theme = ShadTheme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShadProgress(value: null),
          const SizedBox(height: 20),
          Text('Загрузка подписок...', style: theme.textTheme.muted),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildFeatures(),
                const SizedBox(height: 30),
                _buildSubscriptionOptions(),
              ],
            ),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    final theme = ShadTheme.of(context);

    return Column(
      children: [
        // Premium icon с градиентом
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.crown, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          'Unlock Premium Features',
          style: theme.textTheme.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Get unlimited access to all features',
          style: theme.textTheme.muted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final theme = ShadTheme.of(context);

    final features = [
      (
        icon: LucideIcons.scan,
        title: 'Unlimited Scanning',
        subtitle: 'Scan as many documents as you want'
      ),
      (
        icon: LucideIcons.penTool,
        title: 'Advanced Editing',
        subtitle: 'Full editing suite with filters and effects'
      ),
      (
        icon: LucideIcons.download,
        title: 'Export Options',
        subtitle: 'PDF, JPEG, PNG and more formats'
      ),
      (
        icon: LucideIcons.cloud,
        title: 'Cloud Sync',
        subtitle: 'Sync across all your devices'
      ),
    ];

    return Column(
      children: features
          .map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature.icon,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: theme.textTheme.p
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            feature.subtitle,
                            style: theme.textTheme.muted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSubscriptionOptions() {
    final theme = ShadTheme.of(context);

    return Column(
      children: _products.map((product) {
        final isSelected = _selectedProductId == product.productId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedProductId = product.productId;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.border,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: theme.radius,
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.05)
                    : theme.colorScheme.card,
              ),
              child: Row(
                children: [
                  // Радио индикатор
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.muted,
                        width: 2,
                      ),
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(LucideIcons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Информация о подписке
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              product.title,
                              style: theme.textTheme.p
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (product.isRecommended) ...[
                              const SizedBox(width: 8),
                              ShadBadge.secondary(
                                child: const Text('BEST VALUE'),
                              ),
                            ],
                          ],
                        ),
                        if (product.trialPeriod != null)
                          Text(
                            product.trialPeriod!,
                            style: theme.textTheme.small.copyWith(
                              color: const Color(0xFF22C55E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Text(
                          product.description,
                          style: theme.textTheme.muted,
                        ),
                      ],
                    ),
                  ),

                  // Цена
                  Text(
                    product.price,
                    style: theme.textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    final theme = ShadTheme.of(context);
    final selectedProduct = _products.firstWhere(
      (p) => p.productId == _selectedProductId,
      orElse: () => _products.first,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(
          top: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка покупки
          ShadButton(
            width: double.infinity,
            enabled: !_isLoading,
            onPressed: _purchaseSelected,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    selectedProduct.productId == 'yearly_premium'
                        ? 'Continue'
                        : 'Start ${selectedProduct.period}ly subscription',
                  ),
          ),
          const SizedBox(height: 12),

          // Восстановить покупки
          ShadButton.ghost(
            onPressed: _isLoading ? null : _restorePurchases,
            child: const Text('Restore Purchases'),
          ),
          const SizedBox(height: 12),

          // Ссылки
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShadButton.link(
                onPressed: () {},
                child: Text('Privacy Policy', style: theme.textTheme.muted),
              ),
              Text(' • ', style: theme.textTheme.muted),
              ShadButton.link(
                onPressed: () {},
                child: Text('Terms of Service', style: theme.textTheme.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
