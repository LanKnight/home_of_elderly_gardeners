// lib/utils/constants.dart
class AppConstants {
  static const String appName = '老园丁之家';
  static const String appEnglishName = 'Home of Elderly Gardeners';
  
  // 路由名称
  static const String routeHome = '/';
  static const String routeUserType = '/user-type';
  static const String routeRegister = '/register';
  static const String routeMain = '/main';
  static const String routeLogin = '/login';
  
  // API端点
  static const String baseUrl = 'https://your-api-domain.com';
  static const String apiLogin = '/auth/login';
  static const String apiRegister = '/auth/register';
  // Scraper backend default base URL. When running Android emulator, use 10.0.2.2 to
  // reach host machine. You can override this in ApiService if needed.
  static const String scraperBaseUrl = 'http://127.0.0.1:8000';
  
  // 存储键名
  static const String keyUserToken = 'user_token';
  static const String keyUserInfo = 'user_info';
  static const String keyIsCareVersion = 'is_care_version';
}