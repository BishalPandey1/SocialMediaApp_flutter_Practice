import 'package:flutter/material.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await Supabase.instance.client.auth
                              .signInWithPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login successful")),
                          );

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } on AuthApiException catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.message)));
                        } catch (e) {
                          //j panii hune vayo
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : const Text("Login"),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
