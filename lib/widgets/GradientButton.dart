import 'package:ama/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color colorText;
  final double borderRadius;
  final double fontSizeText;
  final bool isLoading;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.colorText = Colors.white,
    this.borderRadius = 12.0,
    this.fontSizeText = 14.0,
    this.width = double.infinity,
    this.height = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: colorText,
                  fontSize: fontSizeText,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
