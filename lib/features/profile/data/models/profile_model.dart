class ProfileModel {
  final String name;
  final String address;
  final String city;
  final String country;
  final double balance;
  final double equity;
  final double freeMargin;
  final int leverage;
  final bool isSwapFree;
  final int totalTradesCount;
  final double totalTradesVolume;
  final int currentTradesCount;
  final double currentTradesVolume;
  final bool isAnyOpenTrades;
  final int verificationLevel;
  final String currency;
  final String lastFourPhone;

  const ProfileModel({
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.balance,
    required this.equity,
    required this.freeMargin,
    required this.leverage,
    required this.isSwapFree,
    required this.totalTradesCount,
    required this.totalTradesVolume,
    required this.currentTradesCount,
    required this.currentTradesVolume,
    required this.isAnyOpenTrades,
    required this.verificationLevel,
    required this.currency,
    this.lastFourPhone = '',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name']?.toString() ?? 'N/A',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      equity: (json['equity'] as num?)?.toDouble() ?? 0.0,
      freeMargin: (json['freeMargin'] as num?)?.toDouble() ?? 0.0,
      leverage: (json['leverage'] as num?)?.toInt() ?? 0,
      isSwapFree: json['isSwapFree'] as bool? ?? false,
      totalTradesCount: (json['totalTradesCount'] as num?)?.toInt() ?? 0,
      totalTradesVolume: (json['totalTradesVolume'] as num?)?.toDouble() ?? 0.0,
      currentTradesCount: (json['currentTradesCount'] as num?)?.toInt() ?? 0,
      currentTradesVolume: (json['currentTradesVolume'] as num?)?.toDouble() ?? 0.0,
      isAnyOpenTrades: json['isAnyOpenTrades'] as bool? ?? false,
      verificationLevel: (json['verificationLevel'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? '0',
    );
  }

  ProfileModel copyWith({String? lastFourPhone}) {
    return ProfileModel(
      name: name,
      address: address,
      city: city,
      country: country,
      balance: balance,
      equity: equity,
      freeMargin: freeMargin,
      leverage: leverage,
      isSwapFree: isSwapFree,
      totalTradesCount: totalTradesCount,
      totalTradesVolume: totalTradesVolume,
      currentTradesCount: currentTradesCount,
      currentTradesVolume: currentTradesVolume,
      isAnyOpenTrades: isAnyOpenTrades,
      verificationLevel: verificationLevel,
      currency: currency,
      lastFourPhone: lastFourPhone ?? this.lastFourPhone,
    );
  }
}
