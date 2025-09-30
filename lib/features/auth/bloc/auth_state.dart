abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class PhoneVerified extends AuthState {
  final String phoneNumber;
  PhoneVerified(this.phoneNumber);
}

class OtpVerified extends AuthState {
  final String phoneNumber;
  OtpVerified(this.phoneNumber);
}

class NameSaved extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
