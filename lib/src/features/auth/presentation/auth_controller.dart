import 'package:flutter_boilerplate/src/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> signInWithGoogle() async {
    final authRepository = ref.watch(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await authRepository.signInWithGoogle();
    });
  }

  Future<void> signInWithApple() async {
    final authRepository = ref.watch(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await authRepository.signInWithApple();
    });
  }
}
