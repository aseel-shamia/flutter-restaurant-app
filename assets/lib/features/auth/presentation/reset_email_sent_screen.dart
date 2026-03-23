import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets.dart';

class ResetEmailSentScreen extends StatelessWidget {
  const ResetEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('reset_email_sent'.tr()),
        actions: const [AppTopActions()],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // simple illustration placeholder
              Icon(Icons.mark_email_read, size: 100.r, color: cs.primary),
              SizedBox(height: 20.h),
              Text(
                'reset_email_title'.tr(), // "Reset email sent"
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'reset_email_desc'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant),
              ),
              SizedBox(height: 24.h),
              AppPrimaryButton(
                labelKey: 'open_email_app', // "Open email app"
                onPressed: () {}, // TODO
              ),
            ],
          ),
        ),
      ),
    );
  }
}
