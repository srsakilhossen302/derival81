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
  static String getInviteGroupUrl(String inviteCode) =>
      '$baseUrl/api/v1/groups/invite/$inviteCode';
  static String updateProfileUrl(String userId) =>
      '$baseUrl/api/v1/user/$userId';
  static const String myGroupsUrl = '$baseUrl/api/v1/group-members/my-groups';
  static String groupMembersUrl(String groupId) => '$baseUrl/api/v1/group-members/$groupId';
}
