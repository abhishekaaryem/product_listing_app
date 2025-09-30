class UserModel {
  final String phoneNumber;
  final String? firstName;
  final String? token;

  UserModel({required this.phoneNumber, this.firstName, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phone_number'] ?? '',
      firstName: json['first_name'] ?? '',
      token: json['token'] is Map ? json['token']['access'] : json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'first_name': firstName,
      'token': token,
    };
  }
}
