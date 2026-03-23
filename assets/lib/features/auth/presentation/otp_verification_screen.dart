// lib/features/auth/presentation/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _nodes = List.generate(6, (_) => FocusNode());
  final _ctrs  = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (final n in _nodes) { n.dispose(); }
    for (final c in _ctrs) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _ctrs.map((e) => e.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp_incomplete'.tr())),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      // هنا يتسجل المستخدم في Firebase Auth (Users)
      context.goNamed(AppRoutes.nHome);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'login_failed'.tr())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _boxDeco(ThemeData t, Color accent, Color border) =>
      InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: accent, width: 1.8),
        ),
      );

  Widget _otpBox(int i, ThemeData t, Color accent, Color border) => SizedBox(
    width: 48.w,
    height: 56.h,
    child: TextField(
      controller: _ctrs[i],
      focusNode: _nodes[i],
      autofocus: i == 0,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      onChanged: (v) {
        if (v.isNotEmpty && i < 5) _nodes[i + 1].requestFocus();
        if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
      },
      decoration: _boxDeco(t, accent, border),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    const accent = Color(0xFFF4A300);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('otp_title'.tr()), // Enter verification code
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'otp_desc'.tr(args: [widget.phoneNumber]),
                style: t.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.45,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (i) => _otpBox(i, t, accent, cs.outlineVariant),
                ),
              ),

              SizedBox(height: 24.h),

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
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'verify'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),
              // إعادة إرسال الكود (اختياري حالياً)
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('otp_sent_again'.tr())),
                  );
                },
                child: Text('resend_code'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
