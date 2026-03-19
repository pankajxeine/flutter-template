import 'package:equatable/equatable.dart';

class LoginToken extends Equatable {
  final String idToken;
  final String tokenType;
  final String refreshToken;
  final DateTime expiresAt;

  const LoginToken({
    required this.idToken,
    required this.tokenType,
    required this.refreshToken,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [idToken, tokenType, refreshToken, expiresAt];
}
