import 'package:commitlock/core/widgets/loading_button.dart';
import 'package:commitlock/core/widgets/custom_textform.dart';
import 'package:commitlock/features/auth/presentation/provider/auth_provider.dart';
import 'package:commitlock/features/auth/presentation/view/signup_screen.dart';
import 'package:commitlock/features/home/presentation/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();

      final success = await provider.login(
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
        ).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 40),

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

                  const SizedBox(height: 24),

                  /// LOGIN BUTTON (FIXED)
                  Consumer<AuthProvider>(
                    builder: (context, state, _) {
                      return LoadingButton(
                        label: "Login",
                        isLoading: state.isLoading,
                        onPressed: () {
                          if (!state.isLoading) {
                            login();
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// SIGN UP
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text("Don't have an account? Sign Up"),
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
