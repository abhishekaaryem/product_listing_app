abstract class AuthEvent {}

class VerifyPhone extends AuthEvent {
  final String phoneNumber;
  VerifyPhone(this.phoneNumber);
}

class VerifyOtp extends AuthEvent {
  final String otp;
  final String phoneNumber;
  VerifyOtp(this.otp, this.phoneNumber);
}

class SaveName extends AuthEvent {
  final String name;
  final String phoneNumber;
  SaveName(this.name, this.phoneNumber);
}
