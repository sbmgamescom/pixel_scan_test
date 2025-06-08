import 'package:flutter/material.dart';
import 'package:pixel_scan_test/src/core/config/images.dart';

import '../../../core/utils/app_text_styles.dart';

class PaywallPageWidget extends StatefulWidget {
  final VoidCallback? onPurchaseSuccess;

  const PaywallPageWidget({
    super.key,
    this.onPurchaseSuccess,
  });

  @override
  State<PaywallPageWidget> createState() => _PaywallPageWidgetState();
}

class _PaywallPageWidgetState extends State<PaywallPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Заголовок и подзаголовок
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
              SizedBox(width: 40), // Отступ слева для индикаторов
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Обновим заголовок, чтобы "PDF" было красным
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ultimate\n',
                            style:
                                AppTextStyles.blackColor(AppTextStyles.title2),
                          ),
                          TextSpan(
                            text: 'PDF',
                            style: AppTextStyles.title2.copyWith(
                              color: Color(0xFFFD1524), // Красный цвет
                            ),
                          ),
                          TextSpan(
                            text: ' Scanner',
                            style:
                                AppTextStyles.blackColor(AppTextStyles.title2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      '''Get unlimited scans,\nadvanced editing, and\nan ad-free experience
              ''',
                      style: AppTextStyles.secondaryColor(AppTextStyles.body1)
                          .copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Image
        _buildPageImage(),
      ],
    );
  }

  Widget _buildPageImage() {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      width: double.infinity,
      child: Center(
        child: Image.asset(
          AppImages.on3,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
