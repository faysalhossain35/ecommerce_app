import 'package:ecommerce_app/data/models/auth_models.dart';
import 'package:ecommerce_app/data/service/auth_service.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class AuthProvider extends FeatureProvider {
  AuthProvider({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;
  AuthResult? _authResult;

  AuthResult? get authResult => _authResult;

  Future<AuthResult> login(String email, String password) {
    return runOperation(() async {
      _authResult = await _service.login(email: email, password: password);
      return _authResult!;
    });
  }

  Future<AuthResult> register(String email, String password) {
    return runOperation(
      () => _service.register(email: email, password: password),
    );
  }

  Future<AuthResult> verifyOtp(String email, String otp) {
    return runOperation(() async {
      _authResult = await _service.verifyOtp(email: email, otp: otp);
      return _authResult!;
    });
  }

  Future<void> resendOtp(String email) =>
      runOperation(() => _service.resendOtp(email));

  Future<Map<String, dynamic>> getProfile() =>
      runOperation(() => _service.getProfile());

  Future<void> logout() {
    return runOperation(() async {
      await _service.logout();
      _authResult = null;
    });
  }
}
