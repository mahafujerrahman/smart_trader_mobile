import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/app/core/widgets/app_error_widget.dart';
import 'package:smart_trader_mobile/features/promo/data/models/promo_model.dart';
import 'package:smart_trader_mobile/features/promo/presentation/controller/promo_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoScreen extends GetView<PromoController> {
  const PromoScreen({super.key});

  Future<void> _openLink(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Promo Materials',
                        style: AppStyles.fontSize22(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Latest offers & promotions',
                        style: AppStyles.fontSize13(
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Obx(() => GestureDetector(
                        onTap: () => ctrl.loadPromo(),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color:
                                    AppColors.primaryColor.withOpacity(0.3)),
                          ),
                          child: ctrl.isLoading
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : Icon(Icons.refresh_rounded,
                                  color: AppColors.primaryColor, size: 22.sp),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Body
            Expanded(
              child: Obx(() {
                switch (ctrl.status) {
                  case PromoStatus.loading:
                    return _buildShimmerGrid();
                  case PromoStatus.error:
                    return AppErrorWidget(
                      message: ctrl.errorMessage,
                      onRetry: () => ctrl.loadPromo(),
                    );
                  case PromoStatus.empty:
                    return _buildEmpty();
                  case PromoStatus.loaded:
                    return _buildPromoList(ctrl.promos);
                  default:
                    return _buildShimmerGrid();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoList(List<PromoModel> promos) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: promos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _PromoCard(
            promo: promos[index],
            onTap: () => _openLink(promos[index].link),
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 4,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Shimmer.fromColors(
          baseColor: AppColors.bgTertiary,
          highlightColor: AppColors.bgSurface,
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined,
              color: AppColors.textMuted, size: 56.sp),
          SizedBox(height: 16.h),
          Text('No Promos Available',
              style: AppStyles.fontSize18(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new promotional materials.',
            textAlign: TextAlign.center,
            style: AppStyles.fontSize13(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatefulWidget {
  final PromoModel promo;
  final VoidCallback onTap;

  const _PromoCard({required this.promo, required this.onTap});

  @override
  State<_PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<_PromoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) {
        _hoverController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF111827), Color(0xFF1A2332)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (widget.promo.fixedImageUrl.isNotEmpty)
                  SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: widget.promo.fixedImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.bgTertiary,
                        highlightColor: AppColors.bgSurface,
                        child: Container(color: AppColors.bgTertiary),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.bgTertiary,
                        child: Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: AppColors.textMuted, size: 36.sp),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.2),
                          AppColors.primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.campaign_rounded,
                          color: AppColors.primaryColor.withOpacity(0.5),
                          size: 48.sp),
                    ),
                  ),

                // Content
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.promo.title,
                              style: AppStyles.fontSize15(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.open_in_new_rounded,
                                    color: Colors.white, size: 14.sp),
                                SizedBox(width: 4.w),
                                Text('Open',
                                    style: AppStyles.fontSize12(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.promo.description != null &&
                          widget.promo.description!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Text(
                          widget.promo.description!,
                          style: AppStyles.fontSize12(
                              color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
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
