import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key}); // Use UniqueKey

  @override
  Widget build(BuildContext context) {
    return const LoginFormScreen();
  }
}

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key}); // Use UniqueKey

  @override
  _LoginFormScreenState createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove key here
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                // Add validation and login logic here
                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your username and password.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(username: username),
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final String username;

  const UserProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove key here

      body: Center(
        child: Text('Welcome, $username!'),
      ),
    );
  }
}
