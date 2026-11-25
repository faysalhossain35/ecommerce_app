import 'package:flutter/foundation.dart';

abstract class FeatureProvider extends ChangeNotifier {
  int _activeOperations = 0;
  bool _isDisposed = false;
  String? _errorMessage;

  bool get isLoading => _activeOperations > 0;
  String? get errorMessage => _errorMessage;

  Future<T> runOperation<T>(Future<T> Function() operation) async {
    _activeOperations++;
    _errorMessage = null;
    _notifyListeners();
    try {
      return await operation();
    } on Exception catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _activeOperations--;
      _notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    _notifyListeners();
  }

  void _notifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
