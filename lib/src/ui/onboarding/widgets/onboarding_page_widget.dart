import 'package:flutter/material.dart';

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
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Subtitle
                    Text(
                      pageData.subtitle,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
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
