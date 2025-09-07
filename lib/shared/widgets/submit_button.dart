import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

/// Botón de envío personalizado y reutilizable
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.textStyle,
    this.loadingColor,
    this.elevation,
    this.margin,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Color? loadingColor;
  final double? elevation;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !isEnabled || isLoading || onPressed == null;

    return Container(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      margin: margin,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.onPrimary,
          disabledBackgroundColor: AppColors.gray200,
          disabledForegroundColor: AppColors.gray500,
          elevation: elevation ?? 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.radiusL,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL.w,
            vertical: AppDimensions.paddingM.h,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loadingColor ?? AppColors.onPrimary,
                  ),
                ),
              )
            : Text(
                text,
                style: textStyle ??
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.onPrimary,
                    ),
              ),
      ),
    );
  }
}

/// Botón secundario (outline)
class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.textStyle,
    this.loadingColor,
    this.margin,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Color? loadingColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = !isEnabled || isLoading || onPressed == null;

    return Container(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      margin: margin,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          disabledForegroundColor: AppColors.gray400,
          side: BorderSide(
            color: isDisabled 
                ? AppColors.gray300 
                : (borderColor ?? AppColors.primary),
            width: 1.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.radiusL,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL.w,
            vertical: AppDimensions.paddingM.h,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loadingColor ?? AppColors.primary,
                  ),
                ),
              )
            : Text(
                text,
                style: textStyle ??
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.primary,
                    ),
              ),
      ),
    );
  }
}

/// Botón de texto plano
class TextButton extends StatelessWidget {
  const TextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.textStyle,
    this.margin,
  });

  final VoidCallback? onPressed;
  final String text;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM.w,
              vertical: AppDimensions.paddingS.h,
            ),
            child: Text(
              text,
              style: textStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor ?? AppColors.primary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
