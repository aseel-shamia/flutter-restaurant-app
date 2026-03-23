// lib/features/auth/presentation/sign_up_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/app_routes.dart';
import '../../../shared/state/theme_notifier.dart';
import '../services/storage_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;

  // صورة البروفايل المختارة
  File? _pickedImage;

  // Firebase
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storageService = StorageService();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _storageService.pickImage();
    if (file != null) {
      setState(() => _pickedImage = file);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      // 1) إنشاء مستخدم في FirebaseAuth
      final cred = await _auth.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      final user = cred.user;
      if (user == null) {
        throw Exception('user_is_null');
      }

      // 2) لو المستخدم اختار صورة، نرفعها لـ Storage
      String? photoUrl;
      if (_pickedImage != null) {
        photoUrl = await _storageService.uploadUserImage(
          uid: user.uid,
          file: _pickedImage!,
        );
      }

      // 3) حفظ بيانات المستخدم في Firestore داخل collection users
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': user.phoneNumber,
        'photoUrl': photoUrl, // ممكن تكون null لو ما اختار صورة
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('signup_success_mock'.tr())),
      );

      context.goNamed(AppRoutes.nHome);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String msg = 'signup_failed'.tr();

      if (e.code == 'email-already-in-use') {
        msg = 'err_email_in_use'.tr();
      } else if (e.code == 'weak-password') {
        msg = 'err_password_weak'.tr();
      } else if (e.code == 'invalid-email') {
        msg = 'err_email_format'.tr();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      debugPrint('FIREBASE ERROR: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore error: ${e.code}')),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('UNKNOWN ERROR: $e');
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
    final lang = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text('signup_appbar'.tr()),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<Locale>(
            tooltip: 'language'.tr(),
            icon: const Icon(Icons.language),
            onSelected: context.setLocale,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: const Locale('en'),
                child: Row(children: [
                  if (lang == 'en') const Icon(Icons.check, size: 18),
                  if (lang == 'en') SizedBox(width: 6.w),
                  const Text('EN'),
                ]),
              ),
              PopupMenuItem(
                value: const Locale('ar'),
                child: Row(children: [
                  if (lang == 'ar') const Icon(Icons.check, size: 18),
                  if (lang == 'ar') SizedBox(width: 6.w),
                  const Text('AR'),
                ]),
              ),
            ],
          ),
          IconButton(
            tooltip: 'theme'.tr(),
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeNotifier>().toggle(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة البروفايل (اختيار من المعرض)
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40.r,
                      backgroundColor: cs.primary.withOpacity(0.2),
                      backgroundImage:
                      _pickedImage != null ? FileImage(_pickedImage!) : null,
                      child: _pickedImage == null
                          ? Icon(
                        Icons.camera_alt,
                        size: 26.sp,
                        color: cs.primary,
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  'signup_title'.tr(),
                  style: t.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 26.sp,
                    height: 1.12,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'signup_subtitle'.tr(),
                  style: t.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 22.h),

                // Full name
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'full_name'.tr(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 12.w,
                    ),
                    suffixIcon: const Icon(Icons.check, size: 18),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'err_name_required'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email'.tr(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 12.w,
                    ),
                    suffixIcon: const Icon(Icons.check, size: 18),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'err_email_required'.tr();
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(v.trim())) {
                      return 'err_email_format'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'password'.tr(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 12.w,
                    ),
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

                SizedBox(height: 18.h),

                // Sign up button
                SizedBox(
                  height: 48.h,
                  width: double.infinity,
                  child: FilledButton(
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
                      'sign_up'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
                Text(
                  'signup_terms'.tr(),
                  textAlign: TextAlign.center,
                  style: t.textTheme.bodySmall?.copyWith(
                    fontSize: 11.5.sp,
                    color: cs.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),

                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: cs.outlineVariant)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'or'.tr(),
                        style: t.textTheme.bodySmall
                            ?.copyWith(fontSize: 12.sp),
                      ),
                    ),
                    Expanded(child: Divider(color: cs.outlineVariant)),
                  ],
                ),

                // … باقي أزرار Facebook / Google / "already have account"
              ],
            ),
          ),
        ),
      ),
    );
  }
}

