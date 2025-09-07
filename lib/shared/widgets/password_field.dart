import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';
import 'custom_text_field.dart';

/// Campo de contraseña con toggle para mostrar/ocultar
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
    this.showStrengthIndicator = false,
    this.autofocus = false,
  });

  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final bool showStrengthIndicator;
  final bool autofocus;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  int _passwordStrength = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hintText: widget.hintText,
          labelText: widget.labelText,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: (value) {
            if (widget.showStrengthIndicator) {
              setState(() {
                _passwordStrength = _calculatePasswordStrength(value);
              });
            }
            widget.onChanged?.call(value);
          },
          onSubmitted: widget.onSubmitted,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.gray500,
              size: AppDimensions.iconS.sp,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.showStrengthIndicator && _passwordStrength > 0) ...[
          SizedBox(height: 8.h),
          _buildPasswordStrengthIndicator(),
        ],
      ],
    );
  }

  /// Construye el indicador de fortaleza de la contraseña
  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: _passwordStrength / 100,
                backgroundColor: AppColors.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStrengthColor(_passwordStrength),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              _getStrengthText(_passwordStrength),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: _getStrengthColor(_passwordStrength),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          _getStrengthDescription(_passwordStrength),
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  /// Calcula la fortaleza de la contraseña (0-100)
  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;
    
    // Longitud
    if (password.length >= 8) score += 20;
    if (password.length >= 12) score += 10;
    if (password.length >= 16) score += 10;
    
    // Tipos de caracteres
    if (RegExp(r'[a-z]').hasMatch(password)) score += 15;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 15;
    if (RegExp(r'\d').hasMatch(password)) score += 15;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 15;
    
    return score.clamp(0, 100);
  }

  /// Obtiene el color según la fortaleza
  Color _getStrengthColor(int strength) {
    if (strength < 30) return AppColors.error;
    if (strength < 60) return AppColors.warning;
    if (strength < 80) return AppColors.info;
    return AppColors.success;
  }

  /// Obtiene el texto según la fortaleza
  String _getStrengthText(int strength) {
    if (strength < 30) return 'Débil';
    if (strength < 60) return 'Regular';
    if (strength < 80) return 'Buena';
    return 'Fuerte';
  }

  /// Obtiene la descripción según la fortaleza
  String _getStrengthDescription(int strength) {
    if (strength < 30) return 'Debe contener al menos 8 caracteres';
    if (strength < 60) return 'Agrega mayúsculas y números';
    if (strength < 80) return 'Agrega caracteres especiales';
    return 'Contraseña muy segura';
  }
}
