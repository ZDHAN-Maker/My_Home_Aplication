import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//Class Untuk Login
class _LoginPageState extends State<LoginPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

    void login() async {
    setState(() => isLoading = true);

    // TODO: Kirim data ke server
    await Future.delayed(const Duration(seconds: 2)); // simulasi delay

    setState(() => isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}