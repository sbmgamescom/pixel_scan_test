import 'package:flutter/material.dart';
import 'package:pixel_scan_test/l10n/app_localizations.dart';

import '../../../components/loading_overlay.dart';
import '../../../core/services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback? onPurchaseSuccess;
  final VoidCallback? onSkip;
  final bool showSkipButton;
  final String? title;
  final String? subtitle;
  final SubscriptionService subscriptionService;

  const PaywallScreen({
    super.key,
    this.onPurchaseSuccess,
    this.onSkip,
    this.showSkipButton = false,
    this.title,
    this.subtitle,
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionLoadError(e.toString()))),
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
              child: Text(
                AppLocalizations.of(context)!.close,
                style: const TextStyle(
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
          widget.title ?? AppLocalizations.of(context)!.paywallTitle,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          widget.subtitle ?? AppLocalizations.of(context)!.paywallSubtitle,
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
    final l10n = AppLocalizations.of(context)!;
    final features = [
      {'icon': Icons.scanner, 'title': l10n.unlimitedScans},
      {'icon': Icons.edit, 'title': l10n.advancedEditing},
      {'icon': Icons.print, 'title': l10n.exportAndPrint},
      {'icon': Icons.share, 'title': l10n.unlimitedStorage},
      {'icon': Icons.cloud_sync, 'title': l10n.cloudSync},
      {'icon': Icons.support, 'title': l10n.prioritySupport},
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
      return Text(
        AppLocalizations.of(context)!.subscriptionsUnavailable,
        style: const TextStyle(
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
                            AppLocalizations.of(context)!.freeTrial,
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
    final l10n = AppLocalizations.of(context)!;
    switch (period.toLowerCase()) {
      case 'week':
        return l10n.weeklySubscription;
      case 'month':
        return l10n.monthlySubscription;
      case 'year':
        return l10n.annualSubscription;
      default:
        return l10n.defaultSubscription;
    }
  }

  String _getProductDescription(String period) {
    final l10n = AppLocalizations.of(context)!;
    switch (period.toLowerCase()) {
      case 'week':
        return l10n.weeklyPayment;
      case 'month':
        return l10n.monthlyPayment;
      case 'year':
        return l10n.annualPayment;
      default:
        return l10n.premiumAccess;
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
                  : Text(
                      AppLocalizations.of(context)!.subscribe,
                      style: const TextStyle(
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
                child: Text(
                  AppLocalizations.of(context)!.restorePurchases,
                  style: const TextStyle(
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
                child: Text(
                  AppLocalizations.of(context)!.termsOfService,
                  style: const TextStyle(
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
          SnackBar(content: Text(AppLocalizations.of(context)!.purchaseFailed)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.errorWithDetail(e.toString()))),
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
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.noActiveSubscriptions)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.errorWithDetail(e.toString()))),
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
