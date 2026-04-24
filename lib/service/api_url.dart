class ApiUrl {
  static const String baseUrl = 'http://10.10.7.23:5000';
  static const String registerUrl = '$baseUrl/api/v1/auth/register';
  static const String verifyEmailUrl = '$baseUrl/api/v1/auth/verify-email';
  static const String resendVerificationCodeUrl = '$baseUrl/api/v1/auth/resend-verification-code';
}
