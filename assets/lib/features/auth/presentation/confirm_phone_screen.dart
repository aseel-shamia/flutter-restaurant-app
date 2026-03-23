// lib/features/auth/presentation/confirm_phone_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/app_routes.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  final String phoneNumber;

  const ConfirmPhoneScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<ConfirmPhoneScreen> createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _sendCode() async {
    setState(() => _isLoading = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // لو الكود انمسك تلقائيًا
          await _auth.signInWithCredential(credential);
          if (!mounted) return;
          context.goNamed(AppRoutes.nHome);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'something_wrong'.tr())),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          // نروح لصفحة OTP ومعنا verificationId + رقم الجوال في الـ query
          context.pushNamed(
            AppRoutes.nOtp,
            extra: verificationId,
            queryParameters: {'phone': widget.phoneNumber},
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // ممكن تخزنه لو بدك
        },
      );
    } catch (_) {
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
        centerTitle: true,
        title: Text('confirm_phone_title'.tr()), // "Verify your phone"
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'confirm_phone_headline'.tr(),
                style: t.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 26.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'confirm_phone_desc'.tr(args: [widget.phoneNumber]),
                style: t.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.45,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),

              // زر Send code
              SizedBox(
                height: 48.h,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: _isLoading ? null : _sendCode,
                  child: _isLoading
                      ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : Text(
                    'send_code'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => context.pop(),
                child: Text('edit_phone'.tr()), // "Edit phone number"
              ),
            ],
          ),
        ),
      ),
    );
  }
}
