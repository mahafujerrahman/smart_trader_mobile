import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/app/core/routes/app_routes.dart';
import 'package:smart_trader_mobile/app/core/widgets/app_button.dart';
import 'package:smart_trader_mobile/app/core/widgets/app_text_field.dart';
import 'package:smart_trader_mobile/features/auth/presentation/controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late AnimationController _entryController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  late AuthController _authController;
  String? _lastShownError;

  // Owned by this State (created/disposed with the screen) — NOT by
  // AuthController, whose GetX lifecycle can end while this screen is
  // still alive, which disposed them mid-use and crashed the fields.
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _fadeAnim =
        CurvedAnimation(parent: _entryController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    Get.rawSnackbar(
      messageText: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: AppColors.errorColor,
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 12,
      margin: EdgeInsets.all(16.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050810), Color(0xFF0A0E1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 40.h),

                              // Logo & Title
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: SlideTransition(
                                  position: _slideAnim,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80.w,
                                        height: 80.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: AppColors.primaryGradient,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 30,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.candlestick_chart_rounded,
                                          color: Colors.white,
                                          size: 36.sp,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'SmartTrader',
                                        style: AppStyles.fontSize26(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        'Your professional trading companion',
                                        style: AppStyles.fontSize13(
                                            color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Login Card
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: _entryController,
                                    curve: const Interval(0.3, 1.0,
                                        curve: Curves.easeOut),
                                  )),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        24.w, 32.h, 24.w, 32.h),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF111827),
                                          Color(0xFF1A2332),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32.r),
                                        topRight: Radius.circular(32.r),
                                      ),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppColors.primaryColor
                                              .withValues(alpha: 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome back',
                                          style: AppStyles.fontSize24(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          'Sign in to your trading account',
                                          style: AppStyles.fontSize14(
                                              color: AppColors.textSecondary),
                                        ),
                                        SizedBox(height: 28.h),

                                        // Account ID
                                        Text('Account ID',
                                            style: AppStyles.fontSize13(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            )),
                                        SizedBox(height: 8.h),
                                        AppTextField(
                                          controller: _loginCtrl,
                                          hintText: 'Enter your account ID',
                                          keyboardType: TextInputType.number,
                                          prefixIcon: Icon(
                                            Icons.person_outline_rounded,
                                            color: AppColors.textHint,
                                            size: 20.sp,
                                          ),
                                          validator: (v) => (v == null ||
                                                  v.isEmpty)
                                              ? 'Please enter your account ID'
                                              : null,
                                        ),
                                        SizedBox(height: 16.h),

                                        // Password
                                        Text('Password',
                                            style: AppStyles.fontSize13(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            )),
                                        SizedBox(height: 8.h),
                                        AppTextField(
                                          controller: _passCtrl,
                                          hintText: 'Enter your password',
                                          isPassword: true,
                                          prefixIcon: Icon(
                                            Icons.lock_outline_rounded,
                                            color: AppColors.textHint,
                                            size: 20.sp,
                                          ),
                                          validator: (v) => (v == null ||
                                                  v.isEmpty)
                                              ? 'Please enter your password'
                                              : null,
                                        ),
                                        SizedBox(height: 12.h),

                                        // Remember me
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 22.w,
                                              height: 22.w,
                                              child: Obx(() => Checkbox(
                                                value: _authController
                                                    .rememberMe.value,
                                                onChanged:
                                                    _authController
                                                        .toggleRememberMe,
                                                activeColor:
                                                    AppColors.primaryColor,
                                                checkColor: Colors.white,
                                                side: const BorderSide(
                                                    color: AppColors.textHint),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              )),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text('Remember me',
                                                style: AppStyles.fontSize14(
                                                    color: AppColors
                                                        .textSecondary)),
                                          ],
                                        ),
                                        SizedBox(height: 28.h),

                                        // Sign In Button — reactive
                                        Obx(() {
                                          final status =
                                              _authController.status.value;

                                          // Navigate on success
                                          if (status ==
                                              AuthStatus.authenticated) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              if (mounted) {
                                                Get.offAllNamed(AppRoutes.profile);
                                              }
                                            });
                                          }

                                          // Show error snackbar
                                          if (status == AuthStatus.error) {
                                            final msg = _authController
                                                .errorMessage.value;
                                            if (msg.isNotEmpty &&
                                                msg != _lastShownError) {
                                              _lastShownError = msg;
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                _showError(msg);
                                              });
                                            }
                                          }

                                          return AppButton(
                                            text: 'Sign In',
                                            isLoading:
                                                _authController.isLoading,
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _lastShownError = null;
                                                _authController.login(
                                                  _loginCtrl.text.trim(),
                                                  _passCtrl.text.trim(),
                                                );
                                              }
                                            },
                                          );
                                        }),

                                        SizedBox(height: 20.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.lock_rounded,
                                                color: AppColors.textMuted,
                                                size: 14.sp),
                                            SizedBox(width: 6.w),
                                            Text(
                                              'Secured with 256-bit encryption',
                                              style: AppStyles.fontSize12(
                                                  color: AppColors.textMuted),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4AA).withValues(alpha: 0.04)
      ..strokeWidth = 0.5;
    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
