import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/app/core/widgets/app_button.dart';
import 'package:smart_trader_mobile/app/core/widgets/app_error_widget.dart';
import 'package:smart_trader_mobile/app/core/widgets/shimmer_loading.dart';
import 'package:smart_trader_mobile/features/signals/data/models/signal_model.dart';
import 'package:smart_trader_mobile/features/signals/presentation/controller/signals_controller.dart';

class SignalsScreen extends GetView<SignalsController> {
  const SignalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFiltersSection(ctrl),
            Expanded(child: _buildBody(ctrl)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Signals Archive',
                style: AppStyles.fontSize22(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Historical trading signals',
                style: AppStyles.fontSize13(color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border:
                  Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
            ),
            child: Icon(Icons.analytics_outlined,
                color: AppColors.primaryColor, size: 22.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(SignalsController ctrl) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Currency pairs
          Text(
            'Currency Pairs',
            style: AppStyles.fontSize13(
                fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: AppConstants.availablePairs.map((pair) {
                    final isSelected = ctrl.selectedPairs.contains(pair);
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () => ctrl.togglePair(pair),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.bgTertiary,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.borderColor,
                            ),
                          ),
                          child: Text(
                            pair,
                            style: AppStyles.fontSize12(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
          SizedBox(height: 14.h),

          // Date range
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: 'From',
                      date: ctrl.from,
                      onChanged: (d) => ctrl.setFrom(d),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DatePickerField(
                      label: 'To',
                      date: ctrl.to,
                      onChanged: (d) => ctrl.setTo(d),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 14.h),

          // Search button
          Obx(() => AppButton(
                text: 'Search Signals',
                isLoading: ctrl.isLoading,
                leadingIcon:
                    Icon(Icons.search_rounded, color: Colors.white, size: 20.sp),
                onTap: () => ctrl.fetchSignals(),
              )),
        ],
      ),
    );
  }

  Widget _buildBody(SignalsController ctrl) {
    return Obx(() {
      switch (ctrl.status) {
        case SignalsStatus.initial:
          return _buildEmptyPrompt();
        case SignalsStatus.loading:
          return _buildShimmerList();
        case SignalsStatus.error:
          return AppErrorWidget(
            message: ctrl.errorMessage,
            onRetry: () => ctrl.fetchSignals(),
          );
        case SignalsStatus.empty:
          return _buildEmptyState('No signals found for the selected criteria.');
        case SignalsStatus.loaded:
          return _buildSignalList(ctrl.signals);
      }
    });
  }

  Widget _buildEmptyPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app_rounded,
              color: AppColors.textMuted, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'Select pairs & date range,\nthen press Search',
            textAlign: TextAlign.center,
            style: AppStyles.fontSize14(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, color: AppColors.textMuted, size: 56.sp),
          SizedBox(height: 16.h),
          Text('No Signals Found',
              style: AppStyles.fontSize18(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8.h),
          Text(message,
              textAlign: TextAlign.center,
              style: AppStyles.fontSize13(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: _ShimmerSignalCard(),
      ),
    );
  }

  Widget _buildSignalList(List<SignalModel> signals) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  '${signals.length} signals found',
                  style: AppStyles.fontSize12(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: signals.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _SignalCard(signal: signals[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerField(
      {required this.label, required this.date, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2010),
          lastDate: DateTime.now(),
          builder: (ctx, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primaryColor,
                  surface: Color(0xFF1A2332),
                ),
                dialogBackgroundColor: const Color(0xFF111827),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                color: AppColors.primaryColor, size: 16.sp),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppStyles.fontSize10(color: AppColors.textHint)),
                Text(
                  DateFormat('dd MMM yyyy').format(date),
                  style: AppStyles.fontSize12(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  final SignalModel signal;
  const _SignalCard({required this.signal});

  @override
  Widget build(BuildContext context) {
    final isBuy = signal.isBuy;
    final color = isBuy ? AppColors.successColor : AppColors.errorColor;
    final dateStr = signal.signalTime != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(signal.signalTime!)
        : 'N/A';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1A2332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  Text(signal.symbol,
                      style: AppStyles.fontSize16(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: 10.w),
                  _directionBadge(isBuy, color),
                  if (signal.period != null &&
                      signal.period!.isNotEmpty) ...[
                    SizedBox(width: 6.w),
                    _periodBadge(signal.period!),
                  ],
                ],
              ),
              const Spacer(),
              Text(dateStr,
                  style: AppStyles.fontSize11(
                      color: AppColors.textSecondary)),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                  child: _priceItem('Entry',
                      signal.openPrice?.toStringAsFixed(5) ?? 'N/A')),
              Expanded(
                  child: _priceItem('TP',
                      signal.takeProfit?.toStringAsFixed(5) ?? 'N/A')),
              Expanded(
                  child: _priceItem(
                      'SL', signal.stopLoss?.toStringAsFixed(5) ?? 'N/A')),
            ],
          ),
          if (signal.comment != null && signal.comment!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(height: 0.5, color: AppColors.borderColor),
            SizedBox(height: 8.h),
            Text(
              signal.comment!,
              style: AppStyles.fontSize11(color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _directionBadge(bool isBuy, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              isBuy
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: 12.sp),
          SizedBox(width: 4.w),
          Text(isBuy ? 'BUY' : 'SELL',
              style: AppStyles.fontSize11(
                  fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _periodBadge(String period) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.infoColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.infoColor.withOpacity(0.3)),
      ),
      child: Text(period,
          style: AppStyles.fontSize10(
              fontWeight: FontWeight.bold, color: AppColors.infoColor)),
    );
  }

  Widget _priceItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.fontSize10(color: AppColors.textHint)),
        SizedBox(height: 2.h),
        Text(value,
            style: AppStyles.fontSize12(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}

class _ShimmerSignalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerLoading(
                  width: 70.w,
                  height: 18.h,
                  borderRadius: BorderRadius.circular(4)),
              SizedBox(width: 10.w),
              ShimmerLoading(
                  width: 50.w,
                  height: 22.h,
                  borderRadius: BorderRadius.circular(20)),
              const Spacer(),
              ShimmerLoading(
                  width: 100.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4)),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: List.generate(
                3,
                (_) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ShimmerLoading(
                            width: double.infinity,
                            height: 32.h,
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
