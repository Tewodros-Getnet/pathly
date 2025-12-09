import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/auth_viewmodel.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  String selectedRole = "student";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Let's Get Started",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Signup",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),


                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    icon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  items: const [
                    DropdownMenuItem(
                        value: "student", child: Text("Student")),
                    DropdownMenuItem(
                        value: "instructor", child: Text("Instructor")),
                  ],
                  onChanged: (value) {
                    setState(() => selectedRole = value!);
                  },
                  decoration: const InputDecoration(
                    labelText: "Select Role",
                    icon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 30),

                state.isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),

                    onPressed: state.isLoading
                        ? null // disables button
                        : () async {
                      final success = await ref
                          .read(authViewModelProvider.notifier)
                          .signup(emailController.text.trim(),
                          passController.text.trim(),
                          selectedRole);

                      if (success) {
                        Navigator.pop(context);  // back to AuthGate → Home
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Signup failed! Try again.")),
                        );
                      }
                    },
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Signup"),
                  ),

                ),

                const SizedBox(height: 20),

                state.hasError
                    ? Text(
                  state.error.toString(),
                  style: const TextStyle(color: Colors.red),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
