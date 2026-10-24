import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/app_icons.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/app/core/base/custom_button.dart';
import 'package:smart_trader_mobile/app/core/base/custom_text.dart';
import 'package:smart_trader_mobile/app/core/base/custom_text_field.dart';
import 'package:smart_trader_mobile/app/core/routes/routes.dart';
import 'package:smart_trader_mobile/features/auth/controller/auth_controller.dart';

class LogInScreen extends GetView<AuthController> {
  LogInScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  // ২. পুরো Column-কে Form দিয়ে র‍্যাপ করুন
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// Top content
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            children: [
                              SizedBox(height: 30.h),
                              SvgPicture.asset(
                                AppIcons.loginIllustrationIcon,
                                height: 200.h,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "Log in now to access your dashboard and continue your journey today.",
                                textAlign: TextAlign.center,
                                style: AppStyles.fontSize16(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        /// Bottom login container
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text(
                                    "Login Here",
                                    style: AppStyles.fontSize24(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                /// ৩. ইউজারনেম ফিল্ডে ভ্যালিডেটর দিন
                                CustomTextField(
                                  controller: controller.logInUserNameCtrl,
                                  hintText: "Username",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your username";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 12.h),

                                /// ৪. পাসওয়ার্ড ফিল্ডে ভ্যালিডেটর দিন
                                CustomTextField(
                                  controller: controller.logInPassCtrl,
                                  hintText: "Password",
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Obx(() => Checkbox(
                                      value: controller.rememberMe.value,
                                      onChanged: (val) => controller.rememberMe.value = val ?? false,
                                      activeColor: Colors.white,
                                      checkColor: AppColors.primaryColor,
                                      side: const BorderSide(color: Colors.white),
                                    ),
                                    ),
                                    CustomText(text: "Remember me", color: Colors.white),
                                    const Spacer(),
                                  ],
                                ),
                                SizedBox(height: 10.h),

                                /// ৫. অন-ট্যাপে ফর্ম ভ্যালিডেট করুন
                                Obx(
                                      () => CustomButton(
                                    loading: controller.logInLoading.value,
                                    text: "Login",
                                    textColor: AppColors.blackColor,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.logInMethod();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
