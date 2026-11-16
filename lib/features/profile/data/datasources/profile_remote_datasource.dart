import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/core/error/failures.dart';
import 'package:smart_trader_mobile/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getAccountInformation(String login, String token);
  Future<String> getLastFourNumbersPhone(String login, String token);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static const Duration _timeout = Duration(seconds: 30);
  final Logger _logger = Logger();

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> _post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('${AppConstants.peanutBaseUrl}$endpoint');
    final encoded = jsonEncode(body);
    _logger.d('[PROFILE POST] $uri | $encoded');

    final response = await http
        .post(uri, headers: _headers, body: encoded)
        .timeout(_timeout);
    _logger.d('[PROFILE RESP ${response.statusCode}] ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.trim().isEmpty) return <String, dynamic>{};
      return jsonDecode(response.body);
    }
    throw ServerFailure('Server error: ${response.statusCode}');
  }

  @override
  Future<ProfileModel> getAccountInformation(
      String login, String token) async {
    final result = await _post(
      AppConstants.getAccountInformation,
      {
        'login': int.tryParse(login) ?? login,
        'token': token,
      },
    );

    if (result is Map<String, dynamic>) {
      return ProfileModel.fromJson(result);
    }
    throw const ServerFailure('Unexpected profile response format.');
  }

  @override
  Future<String> getLastFourNumbersPhone(String login, String token) async {
    final result = await _post(
      AppConstants.getLastFourNumbersPhone,
      {
        'login': int.tryParse(login) ?? login,
        'token': token,
      },
    );

    if (result is String) return result;
    if (result is Map<String, dynamic>) {
      return result['phone']?.toString() ??
          result['Phone']?.toString() ??
          result['lastFourNumbers']?.toString() ??
          '****';
    }
    return '****';
  }
}
