import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing_app/features/auth/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/bloc/auth_event.dart';
import 'package:product_listing_app/features/auth/bloc/auth_state.dart';
import 'package:product_listing_app/features/auth/repository/auth_repository.dart';

void main() {
  group('AuthBloc', () {
    late AuthRepository authRepository;
    late AuthBloc authBloc;

    setUp(() {
      authRepository = AuthRepository();
      authBloc = AuthBloc(authRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    test('emits PhoneVerified when VerifyPhone with valid number', () async {
      final expectedStates = [
        isA<AuthLoading>(),
        isA<PhoneVerified>(),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(VerifyPhone('1234567890'));
    });
  });
}
