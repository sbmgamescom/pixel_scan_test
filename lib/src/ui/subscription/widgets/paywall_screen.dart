import 'package:flutter/material.dart';

import '../../../components/loading_overlay.dart';
import '../../../core/services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback? onPurchaseSuccess;
  final VoidCallback? onSkip;
  final bool showSkipButton;
  final String title;
  final String subtitle;
  final SubscriptionService subscriptionService;

  const PaywallScreen({
    super.key,
    this.onPurchaseSuccess,
    this.onSkip,
    this.showSkipButton = false,
    this.title = 'Перейти на Премиум',
    this.subtitle = 'Разблокируйте все возможности приложения',
    required String source,
    required this.subscriptionService,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String? _selectedProductId;
  bool _isPurchasing = false;
  List<dynamic> _availableProducts = [];
  final bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAvailableProducts();
  }

  Future<void> _loadAvailableProducts() async {
    try {
      final products = await widget.subscriptionService.getAvailableProducts();
      setState(() {
        _availableProducts = products;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки подписок: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: LoadingOverlay(
        isLoading: _isPurchasing,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildContent(),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (widget.showSkipButton)
            IconButton(
              onPressed: widget.onSkip,
              icon: const Icon(
                Icons.close,
                color: Colors.white70,
              ),
            ),
          const Spacer(),
          if (!widget.showSkipButton)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Закрыть',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildTitle(),
          const SizedBox(height: 40),
          _buildFeatures(),
          const SizedBox(height: 40),
          _buildSubscriptionOptions(),
          const SizedBox(height: 20),
          if (_errorMessage != null) _buildErrorMessage(_errorMessage!),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF9D8DF1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.star,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          widget.subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    final features = [
      {'icon': Icons.scanner, 'title': 'Неограниченное сканирование'},
      {'icon': Icons.edit, 'title': 'Продвинутое редактирование'},
      {'icon': Icons.print, 'title': 'Экспорт и печать документов'},
      {'icon': Icons.share, 'title': 'Безлимитное сохранение'},
      {'icon': Icons.cloud_sync, 'title': 'Синхронизация в облаке'},
      {'icon': Icons.support, 'title': 'Приоритетная поддержка'},
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFF6C63FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                feature['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionOptions() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C63FF),
        ),
      );
    }

    if (_availableProducts.isEmpty) {
      return const Text(
        'Подписки временно недоступны',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: _availableProducts.map((product) {
        final isSelected = _selectedProductId == product.productId;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedProductId = product.productId;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : Colors.white.withOpacity(0.2),
                width: 2,
              ),
              color: isSelected
                  ? const Color(0xFF6C63FF).withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Radio<String>(
                    value: product.productId,
                    groupValue: _selectedProductId,
                    onChanged: (value) {
                      setState(() {
                        _selectedProductId = value;
                      });
                    },
                    activeColor: const Color(0xFF6C63FF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getProductTitle(product.period),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getProductDescription(product.period),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        if (product.trialPeriod != null)
                          const SizedBox(height: 4),
                        if (product.trialPeriod != null)
                          Text(
                            'Бесплатный пробный период',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  String _getProductTitle(String period) {
    switch (period.toLowerCase()) {
      case 'week':
        return 'Недельная подписка';
      case 'month':
        return 'Месячная подписка';
      case 'year':
        return 'Годовая подписка';
      default:
        return 'Подписка';
    }
  }

  String _getProductDescription(String period) {
    switch (period.toLowerCase()) {
      case 'week':
        return 'Оплата каждую неделю';
      case 'month':
        return 'Оплата каждый месяц';
      case 'year':
        return 'Оплата один раз в год';
      default:
        return 'Премиум доступ';
    }
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _selectedProductId != null && !_isPurchasing
                  ? _handlePurchase
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isPurchasing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Подписаться',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _handleRestore,
                child: const Text(
                  'Восстановить',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                height: 16,
                width: 1,
                color: Colors.white38,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Показать пользовательское соглашение
                },
                child: const Text(
                  'Условия',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (_selectedProductId == null) return;

    setState(() {
      _isPurchasing = true;
    });

    try {
      final success =
          await widget.subscriptionService.purchaseProduct(_selectedProductId!);

      if (success && mounted) {
        widget.onPurchaseSuccess?.call();
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Покупка не удалась')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() {
      _isPurchasing = true;
    });

    try {
      final restored = await widget.subscriptionService.restorePurchases();

      if (restored && mounted) {
        widget.onPurchaseSuccess?.call();
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Активные подписки не найдены')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }
}
