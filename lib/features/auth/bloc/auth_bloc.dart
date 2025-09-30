import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<VerifyPhone>(_onVerifyPhone);
    on<VerifyOtp>(_onVerifyOtp);
    on<SaveName>(_onSaveName);
  }

  Future<void> _onVerifyPhone(
      VerifyPhone event, Emitter<AuthState> emit) async {
    if (event.phoneNumber.isEmpty) {
      emit(AuthError('Phone number cannot be empty'));
      return;
    }

    try {
      emit(AuthLoading());
      final isValid = await _authRepository.verifyPhone(event.phoneNumber);

      if (isValid['message'] == "Login Successful") {
        emit(PhoneVerified(event.phoneNumber));
      } else {
        emit(AuthError('Invalid phone number'));
      }
    } catch (e) {
      emit(AuthError('Verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    if (event.otp.isEmpty) {
      emit(AuthError('OTP cannot be empty'));
      return;
    }

    try {
      emit(AuthLoading());
      final isValid =
          await _authRepository.verifyOtp(event.phoneNumber, event.otp);

      if (isValid) {
        emit(OtpVerified(event.phoneNumber));
      } else {
        emit(AuthError('Invalid OTP'));
      }
    } catch (e) {
      emit(AuthError('OTP verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onSaveName(SaveName event, Emitter<AuthState> emit) async {
    if (event.name.trim().isEmpty) {
      emit(AuthError('Name cannot be empty'));
      return;
    }

    try {
      emit(AuthLoading());

      // Save the name - JWT token should already be available from OTP verification
      await _authRepository.saveName(
        event.name,
        event.phoneNumber,
      );

      // Successfully saved name and JWT token is already available
      emit(NameSaved());
    } catch (e) {
      emit(AuthError('Failed to save name: ${e.toString()}'));
    }
  }
}
