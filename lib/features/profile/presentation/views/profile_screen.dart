import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/app/core/routes/app_routes.dart';
import 'package:smart_trader_mobile/app/core/widgets/app_error_widget.dart';
import 'package:smart_trader_mobile/app/core/widgets/shimmer_loading.dart';
import 'package:smart_trader_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trader_mobile/features/profile/data/models/profile_model.dart';
import 'package:smart_trader_mobile/features/profile/presentation/controller/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCtrl = controller;
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Obx(() {
        final status = profileCtrl.status;
        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 160.h,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.bgSecondary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D1A2B), Color(0xFF111827)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: Center(
                                  child: Icon(Icons.person_rounded,
                                      color: Colors.white, size: 28.sp),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (status == ProfileStatus.loaded &&
                                        profileCtrl.profile != null) ...[
                                      Text(
                                        profileCtrl.profile!.name,
                                        style: AppStyles.fontSize18(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${profileCtrl.profile!.city}, ${profileCtrl.profile!.country}',
                                        style: AppStyles.fontSize13(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ] else if (status ==
                                        ProfileStatus.loading) ...[
                                      ShimmerLoading(
                                          width: 130.w,
                                          height: 20.h,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      SizedBox(height: 6.h),
                                      ShimmerLoading(
                                          width: 80.w,
                                          height: 14.h,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ] else ...[
                                      Text('My Profile',
                                          style: AppStyles.fontSize18(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  ],
                                ),
                              ),
                              // Logout button
                              IconButton(
                                onPressed: () async {
                                  final confirm = await Get.dialog<bool>(
                                    AlertDialog(
                                      backgroundColor: AppColors.bgTertiary,
                                      title: Text('Logout',
                                          style: AppStyles.fontSize18(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      content: Text(
                                          'Are you sure you want to logout?',
                                          style: AppStyles.fontSize14(
                                              color: AppColors.textSecondary)),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: Text('Cancel',
                                              style: AppStyles.fontSize14(
                                                  color:
                                                      AppColors.textSecondary)),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: Text('Logout',
                                              style: AppStyles.fontSize14(
                                                  color: AppColors.errorColor,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await authCtrl.logout();
                                    Get.offAllNamed(AppRoutes.login);
                                  }
                                },
                                icon: Icon(Icons.logout_rounded,
                                    color: AppColors.textSecondary,
                                    size: 22.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Body
            if (status == ProfileStatus.loading)
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildShimmerCard(),
                    SizedBox(height: 16.h),
                    _buildShimmerCard(),
                    SizedBox(height: 16.h),
                    _buildShimmerCard(),
                  ]),
                ),
              )
            else if (status == ProfileStatus.error)
              SliverFillRemaining(
                child: AppErrorWidget(
                  message: profileCtrl.errorMessage,
                  onRetry: () => profileCtrl.loadProfile(),
                ),
              )
            else if (status == ProfileStatus.loaded &&
                profileCtrl.profile != null)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildBalanceCard(profileCtrl.profile!),
                    SizedBox(height: 16.h),
                    _buildTradingStats(profileCtrl.profile!),
                    SizedBox(height: 16.h),
                    _buildPersonalInfo(profileCtrl.profile!),
                    SizedBox(height: 16.h),
                    _buildAccountDetails(profileCtrl.profile!),
                    SizedBox(height: 24.h),
                  ]),
                ),
              )
            else
              const SliverFillRemaining(child: SizedBox()),
          ],
        );
      }),
    );
  }

  Widget _buildBalanceCard(ProfileModel p) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003D30), Color(0xFF004D3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  color: AppColors.primaryColor, size: 18.sp),
              SizedBox(width: 8.w),
              Text('Account Balance',
                  style: AppStyles.fontSize13(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '\$${p.balance.toStringAsFixed(2)}',
            style: AppStyles.fontSize32(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                  child: _balanceStat(
                      'Equity', '\$${p.equity.toStringAsFixed(2)}')),
              Container(
                  width: 1,
                  height: 32.h,
                  color: AppColors.primaryColor.withOpacity(0.3)),
              Expanded(
                  child: _balanceStat(
                      'Free Margin', '\$${p.freeMargin.toStringAsFixed(2)}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceStat(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: AppStyles.fontSize12(color: AppColors.textSecondary)),
        SizedBox(height: 4.h),
        Text(value,
            style: AppStyles.fontSize15(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildTradingStats(ProfileModel p) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Trading Stats', Icons.bar_chart_rounded),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                  child: _statTile(
                      'Total Trades',
                      p.totalTradesCount.toString(),
                      Icons.swap_horiz_rounded,
                      AppColors.infoColor)),
              SizedBox(width: 12.w),
              Expanded(
                  child: _statTile(
                      'Total Volume',
                      '${p.totalTradesVolume.toStringAsFixed(1)} lots',
                      Icons.stacked_bar_chart,
                      AppColors.warningColor)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                  child: _statTile(
                      'Open Trades',
                      p.currentTradesCount.toString(),
                      Icons.play_circle_outline_rounded,
                      AppColors.primaryColor)),
              SizedBox(width: 12.w),
              Expanded(
                  child: _statTile(
                      'Open Volume',
                      '${p.currentTradesVolume.toStringAsFixed(1)} lots',
                      Icons.loop_rounded,
                      AppColors.primaryLight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 8.h),
          Text(value,
              style: AppStyles.fontSize16(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 2.h),
          Text(label,
              style: AppStyles.fontSize11(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(ProfileModel p) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Personal Info', Icons.info_outline_rounded),
          SizedBox(height: 16.h),
          _infoRow(Icons.location_on_outlined, 'Address',
              p.address.isNotEmpty ? p.address : 'N/A'),
          _divider(),
          _infoRow(Icons.location_city_outlined, 'City',
              p.city.isNotEmpty ? p.city : 'N/A'),
          _divider(),
          _infoRow(Icons.flag_outlined, 'Country',
              p.country.isNotEmpty ? p.country : 'N/A'),
          _divider(),
          _infoRow(Icons.phone_outlined, 'Phone',
              p.lastFourPhone.isNotEmpty ? '****${p.lastFourPhone}' : 'N/A'),
        ],
      ),
    );
  }

  Widget _buildAccountDetails(ProfileModel p) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Account Details', Icons.manage_accounts_outlined),
          SizedBox(height: 16.h),
          _infoRow(Icons.speed_rounded, 'Leverage', '1:${p.leverage}'),
          _divider(),
          _infoRow(
            Icons.verified_user_outlined,
            'Verification Level',
            _verificationLabel(p.verificationLevel),
          ),
          _divider(),
          _infoRow(
            Icons.swap_vert_rounded,
            'Swap Free',
            p.isSwapFree ? 'Yes (Islamic)' : 'No',
          ),
          _divider(),
          _infoRow(
            Icons.show_chart_rounded,
            'Active Positions',
            p.isAnyOpenTrades ? 'Yes' : 'None',
          ),
        ],
      ),
    );
  }

  String _verificationLabel(int level) {
    switch (level) {
      case 0:
        return 'Not Verified';
      case 1:
        return 'Level 1';
      case 2:
        return 'Level 2';
      case 3:
        return 'Fully Verified';
      default:
        return 'Level $level';
    }
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 18.sp),
        SizedBox(width: 8.w),
        Text(title,
            style: AppStyles.fontSize15(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18.sp),
          SizedBox(width: 12.w),
          Text(label,
              style: AppStyles.fontSize13(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: AppStyles.fontSize13(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 0.5, color: AppColors.borderColor);
  }

  BoxDecoration _cardDecor() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF111827), Color(0xFF1A2332)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColors.borderColor),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(
              width: 120.w,
              height: 18.h,
              borderRadius: BorderRadius.circular(6)),
          SizedBox(height: 14.h),
          ShimmerLoading(
              width: double.infinity,
              height: 14.h,
              borderRadius: BorderRadius.circular(4)),
          SizedBox(height: 8.h),
          ShimmerLoading(
              width: double.infinity,
              height: 14.h,
              borderRadius: BorderRadius.circular(4)),
          SizedBox(height: 8.h),
          ShimmerLoading(
              width: 160.w,
              height: 14.h,
              borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }
}
