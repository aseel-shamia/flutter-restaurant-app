// lib/features/auth/presentation/login_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phone = _phoneCtrl.text.trim();

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // أحياناً على الموبايل يتحقق أوتوماتيك
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          context.goNamed(AppRoutes.nHome);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'login_failed'.tr())),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          // نروح لشاشة OTP و نمرر الـ verificationId + رقم الهاتف
          context.pushNamed(
            AppRoutes.nOtp,
            extra: {
              'verificationId': verificationId,
              'phone': phone,
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // ممكن تتجاهليه الآن
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('something_wrong'.tr())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    const accent = Color(0xFFF4A300);

    return Scaffold(
      appBar: AppBar(
        title: Text('login_with_phone'.tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'phone_login_title'.tr(), // حطي النص اللي بدك ياه بالترجمة
                  style: t.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'phone_number'.tr(),
                    hintText: '+9725XXXXXXXX', // مهم: صيغة E.164
                    prefixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: cs.surfaceVariant.withOpacity(0.25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return 'err_phone_required'.tr();
                    if (!value.startsWith('+') || value.length < 10) {
                      return 'err_phone_format'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 48.h,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _sendCode,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : Text('send_code'.tr()),
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
