import 'package:flutter/material.dart';

import '../../../core/config/images.dart';
import '../models/onboarding_page_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;
  String? _selectedProductId;
  bool _isLoading = false;
  bool _isProductsLoading = true;

  // Данные страниц онбординга
  final List<OnboardingPageModel> _onboardingPages = [
    OnboardingPageModel(
      title: 'PDF Scanner',
      subtitle: 'Easily scan documents\nor convert them to PDF',
      imagePath: AppImages.on1,
    ),
    OnboardingPageModel(
      title: 'Rate Us',
      subtitle: 'Help us improve with\nyour feedback',
      imagePath: AppImages.on2,
    ),
  ];

  // Getters
  int get currentPage => _currentPage;
  String? get selectedProductId => _selectedProductId;
  bool get isLoading => _isLoading;
  bool get isProductsLoading => _isProductsLoading;
  List<OnboardingPageModel> get onboardingPages => _onboardingPages;
  bool get isLastOnboardingPage => _currentPage == _onboardingPages.length - 1;
  int get totalPages => _onboardingPages.length + 1; // +1 для paywall

  // Setters
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setSelectedProductId(String? productId) {
    _selectedProductId = productId;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setProductsLoading(bool loading) {
    _isProductsLoading = loading;
    notifyListeners();
  }

  // Навигация
  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void skipToPaywall() {
    pageController.animateToPage(
      _onboardingPages.length,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToPaywall() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
