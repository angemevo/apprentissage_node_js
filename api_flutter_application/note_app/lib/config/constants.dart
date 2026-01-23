class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Endpoints
  static const String register = ('/auth/register');
  static const String login = ('/auth/login');
  static const String notes = ('/notes');
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
}