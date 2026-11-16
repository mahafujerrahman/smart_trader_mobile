class SignalModel {
  final int? id;
  final String symbol;
  final String direction;
  final double? openPrice;
  final double? takeProfit;
  final double? stopLoss;
  final DateTime? signalTime;
  final String? comment;
  final String? period;
  final int? tradingSystem;

  const SignalModel({
    this.id,
    required this.symbol,
    required this.direction,
    this.openPrice,
    this.takeProfit,
    this.stopLoss,
    this.signalTime,
    this.comment,
    this.period,
    this.tradingSystem,
  });

  bool get isBuy => direction.toUpperCase() == 'BUY';

  factory SignalModel.fromJson(Map<String, dynamic> json) {

    final cmdRaw = json['Cmd'] ?? json['cmd'] ?? json['direction'] ??
        json['Direction'] ?? json['type'] ?? json['Type'];
    String direction = _parseDirection(cmdRaw);

    DateTime? parseTimestamp(dynamic val) {
      if (val == null) return null;
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      if (val is String) {
        try {
          return DateTime.parse(val);
        } catch (_) {
          final ts = int.tryParse(val);
          if (ts != null) return DateTime.fromMillisecondsSinceEpoch(ts * 1000);
        }
      }
      return null;
    }

    return SignalModel(
      id: (json['Id'] ?? json['id'] ?? json['ticket'])?.toInt(),
      symbol: json['Pair']?.toString() ??
          json['pair']?.toString() ??
          json['Symbol']?.toString() ??
          json['symbol']?.toString() ??
          '',
      direction: direction,
      openPrice: _toDouble(json['Price'] ?? json['price'] ??
          json['openPrice'] ?? json['OpenPrice']),
      takeProfit: _toDouble(json['Tp'] ?? json['tp'] ??
          json['takeProfit'] ?? json['TakeProfit']),
      stopLoss: _toDouble(json['Sl'] ?? json['sl'] ??
          json['stopLoss'] ?? json['StopLoss']),
      signalTime: parseTimestamp(
          json['ActualTime'] ?? json['actualTime'] ??
          json['openTime'] ?? json['OpenTime'] ??
          json['timestamp']),
      comment: json['Comment']?.toString() ?? json['comment']?.toString(),
      period: json['Period']?.toString() ?? json['period']?.toString(),
      tradingSystem:
          (json['TradingSystem'] ?? json['tradingSystem'])?.toInt(),
    );
  }

  static String _parseDirection(dynamic cmd) {
    if (cmd == null) return 'BUY';
    final str = cmd.toString().trim().toUpperCase();
    if (str == 'BUY' || str == 'BUY_LIMIT' || str == 'BUY LIMIT' || str == 'BUY_STOP' || str == 'BUY STOP') {
      return 'BUY';
    }
    if (str == 'SELL' || str == 'SELL_LIMIT' || str == 'SELL LIMIT' || str == 'SELL_STOP' || str == 'SELL STOP') {
      return 'SELL';
    }

    final num = int.tryParse(str);
    if (num != null) {
      return num.isEven ? 'BUY' : 'SELL';
    }
    return 'BUY';
  }

  static double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return double.tryParse(val.toString());
  }
}
