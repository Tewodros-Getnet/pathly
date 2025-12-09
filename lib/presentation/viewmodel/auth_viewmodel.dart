import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import 'package:pathlly/data/models/user_model.dart';

// Provider
final authViewModelProvider =
NotifierProvider<AuthViewModel, AsyncValue<User?>>(() {
  return AuthViewModel();
});

// ViewModel (converted to Notifier for Riverpod 3.x)
class AuthViewModel extends Notifier<AsyncValue<User?>> {
  late final AuthRepository _authRepo;
  late final UserRepository _userRepo;

  @override
  AsyncValue<User?> build() {
    _authRepo = AuthRepository();
    _userRepo = UserRepository();
    return const AsyncValue.data(null);
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final user = await _authRepo.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// SIGNUP (and save Firestore user)
  Future<bool> signup(String email, String password, String role) async {
    state = const AsyncValue.loading();

    try {
      final user = await _authRepo.signup(email, password);

      final newUser = AppUser(
        id: user.uid,
        name: email.split("@")[0],
        email: email,
        role: role,
        photoUrl: null,
        createdAt: DateTime.now(),
      );

      await _userRepo.saveUser(newUser);

      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _authRepo.logout();
    state = const AsyncValue.data(null);
  }
}
