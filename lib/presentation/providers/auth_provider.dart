import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'dependency_injection.dart';

// Auth State
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Auth Controller
class AuthController extends StateNotifier<AsyncValue<UserEntity?>> {
  final Ref _ref;

  AuthController(this._ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _ref
        .read(authRepositoryProvider)
        .login(email, password);

    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await _ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserEntity?>>((ref) {
      return AuthController(ref);
    });
