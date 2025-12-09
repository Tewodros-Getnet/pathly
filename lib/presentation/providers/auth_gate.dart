import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../Auth_UI/login_view..dart';
import 'auth_state_provider.dart';
import 'user_providers.dart';

// NEW final screens we now use
import '../view/student/student_home_view.dart';
import '../view/instructor/instructor_home_view.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);   // listens to login/logout

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (err, _) => Scaffold(
        body: Center(child: Text("Auth error: $err")),
      ),

      data: (firebaseUser) {
        // No Firebase user → go to login
        if (firebaseUser == null) return const LoginView();

        // Now fetch full user profile from Firestore
        final profile = ref.watch(userByIdProvider(firebaseUser.uid));

        return profile.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            body: Center(child: Text("Profile Load Error: $err")),
          ),

          data: (appUser) {
            if (appUser == null) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await UserRepository().saveUser(
                        AppUser(
                          id: firebaseUser.uid,
                          name: firebaseUser.email!.split("@")[0],
                          email: firebaseUser.email!,
                          role: "student",
                          photoUrl: null,
                          createdAt: DateTime.now(),
                        ),
                      );
                    },
                    child: const Text("Create Profile"),
                  ),
                ),
              );
            }


            /// 🔥 FINAL ROLE ROUTING
            return appUser.role == "instructor"
                ? const InstructorHomeView()
                : const StudentHomeView();
          },
        );
      },
    );
  }
}
