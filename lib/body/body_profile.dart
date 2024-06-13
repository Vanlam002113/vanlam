import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Future<void> saveCredentialsToLocal(
    String username, String password, String email) async {
  try {
    var box = await Hive.openBox('userCredentials');

    await box.put('username', username);
    await box.put('password', password);
    await box.put('email', email);
    logger.d(
        'Username: $username and Password: ******  and Email: $email - Saved to local storage');
  } catch (e) {
    logger.e('Error saving credentials to local storage');
    // Handle error when saving to local storage
  }
}

// Hàm để đọc giá trị username từ Hive
Future<String?> getUsernameFromLocal() async {
  try {
    var box = await Hive.openBox('userCredentials');
    return box.get('username');
  } catch (e) {
    logger.e('Error retrieving username from local storage');
    return null;
  }
}

// Hàm để đọc giá trị password từ Hive
Future<String?> getPasswordFromLocal() async {
  try {
    var box = await Hive.openBox('userCredentials');
    return box.get('password');
  } catch (e) {
    logger.e('Error retrieving password from local storage');
    return null;
  }
}

// Hàm để đọc giá trị email từ Hive
Future<String?> getEmailFromLocal() async {
  try {
    var box = await Hive.openBox('userCredentials');
    return box.get('email');
  } catch (e) {
    logger.e('Error retrieving email from local storage');
    return null;
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginFormScreen();
  }
}

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  LoginFormScreenState createState() => LoginFormScreenState();
}

//enum FormType { login, register }

class LoginFormScreenState extends State<LoginFormScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TextEditingController _emailController = TextEditingController();
  //FormType _formType = FormType.login;

  void _navigateToRegistrationPage(BuildContext context) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegistrationScreen(),
        ),
      );
    }
  }

  void _login(BuildContext context) {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    String? savedUsername;
    String? savedPassword;

    getUsernameFromLocal().then((value) {
      savedUsername = value;
      getPasswordFromLocal().then((value) {
        savedPassword = value;

        if (savedUsername == enteredUsername &&
            savedPassword == enteredPassword) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(username: savedUsername!),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Username or password is incorrect. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
        actions: [
          TextButton(
            onPressed: () => _navigateToRegistrationPage(context),
            child: const Text('Đăng Ký'),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên Đăng Nhập',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mật Khẩu',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        _login(context);
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            'Đăng Nhập',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    }
  }

  Future<void> _register(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      _showSnackBar(context, 'Please fill in all fields.', Colors.red);
      return;
    }

    await saveCredentialsToLocal(username, password, email);

    // ignore: use_build_context_synchronously
    _showSnackBar(context, 'Registration successful!', Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Tên Đăng Nhập',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật Khẩu',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _register(context);
              },
              child: const Text('Đăng Ký'),
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
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Text('Welcome, $username!'),
      ),
    );
  }
}
