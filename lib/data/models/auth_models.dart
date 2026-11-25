class AuthResult {
  const AuthResult({this.token, this.message, this.user});

  final String? token;
  final String? message;
  final Map<String, dynamic>? user;

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;
    final token = source['token'] ?? source['access_token'];
    final user = source['user'];
    return AuthResult(
      token: token is String ? token : null,
      message: json['msg'] is String
          ? json['msg'] as String
          : json['message'] is String
          ? json['message'] as String
          : null,
      user: user is Map<String, dynamic>
          ? user
          : user is Map
          ? Map<String, dynamic>.from(user)
          : null,
    );
  }
}
