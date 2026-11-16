import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/core/error/failures.dart';

class ApiClient {
  final http.Client _client;
  final Logger _logger = Logger();
  static const Duration _timeout = Duration(seconds: 30);

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  // --- Peanut Service — returns dynamic (bool OR Map) ---
  Future<dynamic> postPeanutDynamic(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return _postDynamic('${AppConstants.peanutBaseUrl}$endpoint', body);
  }


  Future<Map<String, dynamic>> postPeanut(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final result = await _postDynamic(
        '${AppConstants.peanutBaseUrl}$endpoint', body);
    if (result is Map<String, dynamic>) return result;
    // Unexpected type — wrap it
    return {'result': result};
  }

  // --- Partner Service ---
  Future<dynamic> getPartner(
    String endpoint, {
    Map<String, String>? queryParams,
    String? passkey,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.partnerBaseUrl}$endpoint',
    ).replace(queryParameters: queryParams);

    _logger.d('[GET] $uri');
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (passkey != null) 'passkey': passkey,
        },
      ).timeout(_timeout);

      _logger.d('[RESPONSE ${response.statusCode}] ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const ServerFailure('Request timed out. Please try again.');
    }
  }

  Future<Map<String, dynamic>> postPartner(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final result =
        await _postDynamic('${AppConstants.partnerBaseUrl}$endpoint', body);
    if (result is Map<String, dynamic>) return result;
    return {'result': result};
  }

  // --- SOAP Service ---
  static const Duration _soapTimeout = Duration(seconds: 120);

  Future<String> postSoap(
      String url, String soapBody, String soapAction) async {
    _logger.d('[SOAP POST] $url');
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': soapAction,
        },
        body: soapBody,
      ).timeout(_soapTimeout);

      _logger.d('[SOAP RESPONSE ${response.statusCode}] ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerFailure('SOAP error: ${response.statusCode}');
      }
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const ServerFailure('Request timed out.');
    }
  }

  // --- Private Helpers ---
  Future<dynamic> _postDynamic(
    String url,
    Map<String, dynamic> body,
  ) async {
    _logger.d('[POST] $url | body: ${jsonEncode(body)}');
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(_timeout);

      _logger.d('[RESPONSE ${response.statusCode}] ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const ServerFailure('Request timed out.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) return <String, dynamic>{};
      final decoded = jsonDecode(response.body);
      return decoded; // could be bool, List, or Map
    } else if (response.statusCode == 401) {
      throw const AuthFailure();
    } else {
      String message = 'Server error (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          message = body['message'] as String;
        } else if (body is String) {
          message = body;
        }
      } catch (_) {}
      throw ServerFailure(message);
    }
  }
}
