import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/core/error/failures.dart';

abstract class AuthRemoteDataSource {
  Future<String> isAccountCredentialsCorrect(String login, String password);


  Future<String> requestPartnerToken(String login, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const Duration _timeout = Duration(seconds: 30);
  final Logger _logger = Logger();

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<String> isAccountCredentialsCorrect(
      String login, String password) async {
    final uri = Uri.parse(
        '${AppConstants.peanutBaseUrl}${AppConstants.isAccountCredentialsCorrect}');
    final body = jsonEncode({
      'login': int.tryParse(login) ?? login,
      'password': password,
    });

    _logger.d('[AUTH POST] $uri');
    final response = await http.post(uri, headers: _headers, body: body).timeout(_timeout);
    _logger.d('[AUTH RESP ${response.statusCode}] ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw const AuthFailure('Invalid login or password. Please try again.');
    }

    final raw = response.body.trim();

    if (raw == 'true') return '';
    if (raw == 'false') {
      throw const AuthFailure('Invalid login or password. Please try again.');
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is bool) {
        if (!decoded) {
          throw const AuthFailure('Invalid login or password. Please try again.');
        }
        return '';
      }

      if (decoded is Map<String, dynamic>) {
        // Check result field
        final result = decoded['result'] ??
            decoded['IsAccountCredentialsCorrectResult'] ??
            decoded['value'];
        final isOk = result == true ||
            result?.toString().toLowerCase() == 'true';

        if (!isOk) {
          throw const AuthFailure('Invalid login or password. Please try again.');
        }

        final token = decoded['token'] ??
            decoded['Token'] ??
            decoded['accessToken'] ??
            decoded['AccessToken'] ??
            '';
        return token.toString();
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      _logger.w('[AUTH] Unexpected format: $raw | error: $e');
    }
    return '';
  }

  @override
  Future<String> requestPartnerToken(String login, String password) async {
    final uri = Uri.parse(
        '${AppConstants.partnerBaseUrl}${AppConstants.requestMobileToken}');
    final body = jsonEncode({
      'login': int.tryParse(login) ?? login,
      'password': password,
    });

    _logger.d('[PARTNER POST] $uri');
    final response = await http
        .post(uri, headers: _headers, body: body)
        .timeout(_timeout);
    _logger.d('[PARTNER RESP ${response.statusCode}] ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw const ServerFailure('Failed to get partner token. Please try again.');
    }

    final raw = response.body.trim();
    if (raw.isEmpty) throw const ServerFailure('Empty token response.');


    try {
      final decoded = jsonDecode(raw);
      if (decoded is String && decoded.isNotEmpty) return decoded;
      if (decoded is Map<String, dynamic>) {
        final t = decoded['token'] ?? decoded['Token'] ??
            decoded['accessToken'] ?? decoded['AccessToken'] ?? '';
        if (t.toString().isNotEmpty) return t.toString();
      }
    } catch (_) {

      if (raw.isNotEmpty) return raw;
    }

    throw const ServerFailure('Failed to parse partner token.');
  }
}
