class UserModel {
  final String token;
  final String error;

  UserModel({
    this.token = '',
    this.error = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'error': error,
    };
  }
}
