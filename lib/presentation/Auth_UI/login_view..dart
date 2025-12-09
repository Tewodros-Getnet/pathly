import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pathlly/presentation/Auth_UI/signup_view.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome To Pathly",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Login",
                    style:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Email field
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email", icon: Icon(Icons.email)),
                ),
                const SizedBox(height: 20),

                // Password field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password", icon: Icon(Icons.lock)),
                ),
                const SizedBox(height: 30),

                // Login button
                state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),

                    onPressed: () {
                      ref
                          .read(authViewModelProvider.notifier)
                          .login(emailController.text.trim(),
                          passwordController.text.trim());
                    },
                    child: const Text("Login"),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupView()),
                      );
                    },
                    child: const Text("Don't have an account? Signup"),
                  ),
                ),

                // Error message (if any)
                state.hasError
                    ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    state.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
