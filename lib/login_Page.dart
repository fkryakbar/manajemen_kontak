import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulasi login
                if (usernameController.text == 'admin' &&
                    passwordController.text == 'admin') {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Login Berhasil')));
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomePage()));
                } else {
                  // Tampilkan pesan error
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Username atau Password Salah')));
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
