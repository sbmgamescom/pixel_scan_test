import 'package:flutter/material.dart';

import '../../../core/utils/app_text_styles.dart';
import '../models/onboarding_page_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel pageData;
  final int pageIndex;

  const OnboardingPageWidget({
    super.key,
    required this.pageData,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Заголовок и подзаголовок
          Row(
            children: [
              SizedBox(width: 40), // Отступ слева для индикаторов
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      pageData.title,
                      style: AppTextStyles.blackColor(AppTextStyles.title2),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      pageData.subtitle,
                      style: AppTextStyles.secondaryColor(AppTextStyles.body1)
                          .copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Image
          _buildPageImage(),
        ],
      ),
    );
  }

  Widget _buildPageImage() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      width: double.infinity,
      child: Center(
        child: Image.asset(
          pageData.imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
