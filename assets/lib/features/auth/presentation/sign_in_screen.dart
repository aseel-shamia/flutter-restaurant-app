// lib/features/auth/presentation/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../shared/state/theme_notifier.dart';
import '../../../app/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  // Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (!mounted) return;

      // نجاح تسجيل الدخول
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('login_success_mock'.tr())),
      );

      context.goNamed(AppRoutes.nHome);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'login_failed'.tr();

      if (e.code == 'user-not-found') {
        message = 'err_user_not_found'.tr();
      } else if (e.code == 'wrong-password') {
        message = 'err_wrong_password'.tr();
      } else if (e.code == 'invalid-email') {
        message = 'err_email_format'.tr();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final currentLang = context.locale.languageCode;

    const accent = Color(0xFFF4A300); // الأصفر
    const fbBlue = Color(0xFF1877F2);
    const googleBlue = Color(0xFF4285F4);

    InputDecoration _filledInput(String label, {Widget? suffixIcon}) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: cs.surfaceVariant.withOpacity(0.25),
        contentPadding:
        EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        suffixIcon: suffixIcon,
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'sign_in_appbar'.tr(), // Sign In
          style: t.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // 🔀 زر تغيير اللغة
          PopupMenuButton<Locale>(
            tooltip: 'language'.tr(),
            onSelected: (locale) => context.setLocale(locale),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Row(
                  children: [
                    if (currentLang == 'en')
                      const Icon(Icons.check, size: 18),
                    if (currentLang == 'en') const SizedBox(width: 6),
                    const Text('EN'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: const Locale('ar'),
                child: Row(
                  children: [
                    if (currentLang == 'ar')
                      const Icon(Icons.check, size: 18),
                    if (currentLang == 'ar') const SizedBox(width: 6),
                    const Text('AR'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.language),
          ),

          // 🌙/☀️ زر تغيير الثيم
          IconButton(
            tooltip: 'theme'.tr(),
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeNotifier>().toggleTheme();
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  'signin_title'.tr(),
                  style: t.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 26.sp,
                    height: 1.12,
                  ),
                ),
                SizedBox(height: 6.h),

                // Subtitle
                Text(
                  'signin_subtitle'.tr(),
                  style: t.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 22.h),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _filledInput('email'.tr()),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'err_email_required'.tr();
                    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value);
                    if (!ok) return 'err_email_format'.tr();
                    return null;
                  },
                ),
                SizedBox(height: 14.h),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: _filledInput(
                    'password'.tr(),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'err_password_required'.tr();
                    }
                    if (v.length < 6) {
                      return 'err_password_short'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),

                // Forgot password
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () =>
                        context.pushNamed(AppRoutes.nForgot),
                    child: Text(
                      'forgot_password'.tr(),
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // زر تسجيل الدخول
                SizedBox(
                  height: 48.h,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      'login'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // OR divider
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: cs.outlineVariant),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'or'.tr(),
                        style: t.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: cs.outlineVariant),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Continue with Facebook
                SizedBox(
                  height: 48.h,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: fbBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('facebook_mock'.tr()),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.facebook),
                        SizedBox(width: 8.w),
                        Text(
                          'continue_with_facebook'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Continue with Google
                SizedBox(
                  height: 48.h,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: googleBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('google_mock'.tr()),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata_rounded),
                        SizedBox(width: 8.w),
                        Text(
                          'continue_with_google'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Login with phone
                Center(
                  child: TextButton(
                    onPressed: () =>
                        context.pushNamed(AppRoutes.nLoginPhone),
                    child: Text('login_with_phone'.tr()),
                  ),
                ),

                // Create account
                Center(
                  child: TextButton(
                    onPressed: () =>
                        context.pushNamed(AppRoutes.nSignup),
                    child: Text('create_account'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
