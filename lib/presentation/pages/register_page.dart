import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/di/injection_container.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/password_field.dart';
import '../../shared/widgets/submit_button.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/base_bloc.dart';

/// Pantalla de registro de usuario
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: BlocListener<AuthBloc, BaseState>(
          listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error.message),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is RegistrationSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Registro exitoso! Bienvenido'),
                  backgroundColor: AppColors.success,
                ),
              );
              // Aquí podrías navegar a otra pantalla
              // Navigator.of(context).pushReplacementNamed('/home');
            }
          },
          child: Column(
            children: [
              // Header con título
              _buildHeader(),
              
              // Formulario
              Expanded(
                child: _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el header con el título
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Text(
            'Registro',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Construye el formulario
  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXXL.r),
          topRight: Radius.circular(AppDimensions.radiusXXL.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppDimensions.marginXL.h),
              
              // Campo de nombre
              CustomTextField(
                hintText: 'Nombre',
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  if (value.length < 2) {
                    return 'El nombre debe tener al menos 2 caracteres';
                  }
                  if (value.length > 50) {
                    return 'El nombre no puede exceder 50 caracteres';
                  }
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$').hasMatch(value)) {
                    return 'El nombre solo puede contener letras y espacios';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.marginM.h),

              // Campo de email
              CustomTextField(
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El email es requerido';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Ingresa un email válido';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.marginM.h),

              // Campo de contraseña
              PasswordField(
                hintText: 'Contraseña',
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                showStrengthIndicator: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es requerida';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                    return 'Debe contener al menos: 1 minúscula, 1 mayúscula y 1 número';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.marginM.h),

              // Campo de confirmar contraseña
              PasswordField(
                hintText: 'Repetir contraseña',
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirma tu contraseña';
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppDimensions.marginXL.h),

              // Botón de registro
              BlocBuilder<AuthBloc, BaseState>(
                builder: (context, state) {
                  final isLoading = state is LoadingState;
                  
                  return SubmitButton(
                    onPressed: isLoading ? null : _handleRegister,
                    text: 'Enviar',
                    isLoading: isLoading,
                  );
                },
              ),

              SizedBox(height: AppDimensions.marginL.h),

              // Enlace para ir al login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.gray600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text(
                      'Inicia sesión',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.marginL.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Maneja el registro del usuario
  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      // Limpiar estado previo de errores
      context.read<AuthBloc>().add(const ClearAuthStateEvent());
      
      // Disparar evento de registro
      context.read<AuthBloc>().add(
        RegisterUserEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }
}
