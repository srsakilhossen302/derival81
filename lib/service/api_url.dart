class ApiUrl {
  static const String baseUrl = 'http://10.10.7.23:5000';
  static const String registerUrl = '$baseUrl/api/v1/auth/register';
  static const String verifyEmailUrl = '$baseUrl/api/v1/auth/verify-email';
  static const String resendVerificationCodeUrl =
      '$baseUrl/api/v1/auth/resend-verification-code';
  static const String loginUrl = '$baseUrl/api/v1/auth/login';
  static const String getProfileUrl = '$baseUrl/api/v1/user/me';
  static const String uploadProfileImageUrl =
      '$baseUrl/api/v1/user/upload-profile-image';
  static const String groupsUrl = '$baseUrl/api/v1/groups';
  static const String joinGroupUrl = '$baseUrl/api/v1/group-members/join';
  static String getInviteGroupUrl(String inviteCode) =>
      '$baseUrl/api/v1/groups/invite/$inviteCode';
  static String updateProfileUrl(String userId) =>
      '$baseUrl/api/v1/user/$userId';
  static const String myGroupsUrl = '$baseUrl/api/v1/group-members/my-groups';
  static String groupMembersUrl(String groupId) =>
      '$baseUrl/api/v1/group-members/$groupId';
  static String groupMessagesUrl(String groupId) =>
      '$baseUrl/api/v1/chat/group/$groupId/messages';

  // Payment Methods
  static const String paymentMethodsUrl = '$baseUrl/api/v1/payment-methods';
  static String deletePaymentMethodUrl(String id) =>
      '$baseUrl/api/v1/payment-methods/$id';
  static String setDefaultPaymentMethodUrl(String id) =>
      '$baseUrl/api/v1/payment-methods/$id/default';

  // Stripe Connect
  static const String stripeConnectAccountLinkUrl =
      '$baseUrl/api/v1/stripe/connect/account-link';
  static const String stripeConnectStatusUrl =
      '$baseUrl/api/v1/stripe/connect/status';
  static const String stripeConnectLoginLinkUrl =
      '$baseUrl/api/v1/stripe/connect/login-link';
}
