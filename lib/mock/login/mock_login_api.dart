import 'dart:convert';

import 'login_token.dart';

class MockLoginApi {
  Future<LoginToken> authenticate({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 650));

    final now = DateTime.now().toUtc();
    final expiresAt = now.add(const Duration(hours: 2));
    final idToken = _buildJwt(username, expiresAt);

    return LoginToken(
      idToken: idToken,
      tokenType: 'Bearer',
      refreshToken: _randomToken('refresh'),
      expiresAt: expiresAt,
    );
  }

  String _buildJwt(String username, DateTime expiresAt) {
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };
    final payload = {
      'sub': username,
      'name': username,
      'role': ['Admin', 'Teacher'],
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
      'iat': DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
      'iss': 'mock.block_app',
    };

    final headerEncoded = _encodeBase64(header);
    final payloadEncoded = _encodeBase64(payload);
    final signature = _encodeBase64('signature');
    return '$headerEncoded.$payloadEncoded.$signature';
  }

  String _encodeBase64(Object value) {
    final encoded = base64UrlEncode(utf8.encode(jsonEncode(value)));
    return encoded.replaceAll('=', '');
  }

  String _randomToken(String prefix) {
    final millis = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$millis';
  }
}
