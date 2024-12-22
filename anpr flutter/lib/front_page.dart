import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInRegisterScreen extends StatefulWidget {
  const SignInRegisterScreen({super.key});

  @override
  _SignInRegisterScreenState createState() => _SignInRegisterScreenState();
}

class _SignInRegisterScreenState extends State<SignInRegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isRegistering = false;

  void _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Handle successful sign-in
      print('Signed in: ${userCredential.user!.uid}');
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: $e');
      _showErrorDialog('Sign-in Error', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Handle successful registration
      print('Registered: ${userCredential.user!.uid}');
    } catch (e) {
      // Handle registration errors
      print('Registration error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In/Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isRegistering ? null : _signIn,
              child: Text('Sign In'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _isRegistering ? null : _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
