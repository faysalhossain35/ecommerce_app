String requiredJsonString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('Expected a non-empty string for "$key".');
}

String? optionalJsonString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is String) return value;
  throw FormatException('Expected a string or null for "$key".');
}

String? optionalJsonId(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map<String, dynamic>) {
    final id = value['_id'] ?? value['id'];
    if (id is String) return id;
  }
  throw FormatException(
    'Expected an ID, object containing an ID, or null for "$key".',
  );
}

String? optionalJsonEntityId(Map<String, dynamic> json) =>
    optionalJsonString(json, '_id') ?? optionalJsonString(json, 'id');
