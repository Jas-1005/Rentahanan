import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      Navigator.pushReplacementNamed(context, '/manager-dashboard');
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
      backgroundColor: const Color(0xFFFBF7F0),
      /*
      appBar: AppBar(title: const Text(
          'Login',
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Urbanist',
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      )),
       */
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form (
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'LOG-IN',
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E2F1A),
                        ),
                      ),
                      Text(
                        "Let's get you settled in.",
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  Image.asset(
                    'assets/images/LOGO.png',
                    height: 55,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                //decoration for form fields
                height: 55,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    hintStyle: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.3)
                    ),
                    border: InputBorder.none, //hide input border
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter your email';
                    if (!value.contains('@') || !value.contains('.')) return 'Invalid email';
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: TextFormField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    hintText: 'Enter password',
                    hintStyle: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.3)
                    ),
                    border: InputBorder.none,
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
              ),

              const SizedBox(height: 20),
              // LOG-IN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9B6A44),
                    foregroundColor: Color(0xFFFFFFFF),
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5, //shadow elevation
                  ),
                  child: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text('LOG-IN'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  const Text("Don't have an account yet?"),
                  InkWell(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/manager-signup');
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