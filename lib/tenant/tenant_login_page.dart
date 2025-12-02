import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class TenantLoginPage extends StatefulWidget {
  const TenantLoginPage({super.key});

  @override
  State<TenantLoginPage> createState() => _TenantLoginPageState();
}

class _TenantLoginPageState extends State<TenantLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String errorMessage = '';
  bool _obscureText = true;
  bool _isLoading = false;

  Future <void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password:password,
      );

      if(!mounted) return;
      Navigator.pushReplacementNamed(context, '/tenant-unconfirmed');
      } on FirebaseAuthException catch (e){
        String displayMessage;
        if (e.code == 'network-request-failed'){
          displayMessage = 'Network error: Please check your internet connection.';
        } else if (e.code == 'user-not-found'){
          displayMessage = 'Your account does not e exist. Please create an account first.';
        } else if (e.code == 'wrong-password'){
          displayMessage = 'Please double check your password.';
        } else if (e.code == 'too-many-requests'){
          displayMessage = 'Too many failed login attempts. Please try again later.';
        } else {
          displayMessage = 'Login failed: ${e.message}'; // Generic message for other errors
        }

        if (!mounted) return;
        setState(() {
          errorMessage = displayMessage;
        });

        setState(() {
          errorMessage = displayMessage;
        });

    } catch(err) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tenant Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form (
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter your email';
                if (!value.contains('@') || !value.contains('.')) return 'Invalid email';
                return null;
              },
              onSaved: (value) => email = value!,
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Enter password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter your password';
                return null;
              },
              onSaved: (value) => password = value!,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : handleLogin,
              child: _isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : Text('LOG IN'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                const Text("Don't have an account yet?"),
                InkWell(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/tenant-signup');
                    },
                    child: const Text(
                        "Sign up here",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        )
                    )
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ),
    );
  }
}