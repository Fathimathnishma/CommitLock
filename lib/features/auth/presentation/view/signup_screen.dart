import 'package:commitlock/core/widgets/loading_button.dart';
import 'package:commitlock/core/widgets/custom_textform.dart';
import 'package:commitlock/features/auth/presentation/provider/auth_provider.dart';
import 'package:commitlock/features/home/presentation/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();

      final success = await provider.signup(
        emailController.text,
        passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signup failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.bodyLarge?.color),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Create Account ✨",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Sign up to get started",
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),

                  const SizedBox(height: 30),

                  /// FULL NAME
                  CustomTextFormField(
                    controller: nameController,
                    hintText: "Full Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// EMAIL
                  CustomTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return "Enter valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// PASSWORD
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: "Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Minimum 6 characters required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// CONFIRM PASSWORD
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm your password";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// BUTTON
                  Consumer<AuthProvider>(
                    builder: (context, state, _) {
                      return LoadingButton(
                        label: "Sign Up",
                        isLoading: state.isLoading,
                        onPressed: () {
                          if (!state.isLoading) {
                            signUp();
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Already have an account? Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
