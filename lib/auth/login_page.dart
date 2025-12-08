import 'package:cloud_firestore/cloud_firestore.dart';
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

  Widget buildRoundedField(String label, Function(String?) onSaved,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.3)
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFFDDDDDD),
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFF8B5E3C),
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFFB63B2E),
            width: 1.8,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFFB63B2E),
            width: 1.8,
          ),
        ),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.3)
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFFDDDDDD),
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFF8B5E3C),
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFFB63B2E),
            width: 1.8,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFFB63B2E),
            width: 1.8,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      onSaved: (v) => password = v!,
    );
  }

  Future <void> fetchUserRole(user) async{
    String userRole = "";


  }

  Future <void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email.trim(),
        password:password,
      );

      final user = userCredential.user;

      if(!mounted) return;

      if(!mounted) return;
      await fetchUserRole(user)
      if(await isManager(user)) {
        Navigator.pushReplacementNamed(context, '/manager-dashboard');
        return;
      }
      if(await isTenant(user)) {
        Navigator.pushReplacementNamed(context, '/tenant-dashboard');
        return;
      }

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
      backgroundColor: const Color(0xFFFBF7F0), // match your design background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // title + logo here
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
                        "Welcome back.",
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
              // FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildRoundedField("Email Address", (v) => email = v!),
                    const SizedBox(height: 16),
                    buildPasswordField(),
                    const SizedBox(height: 28),
                    // add button here
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5E3C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            elevation: 0, // Turn off native elevated button shadow
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                              : const Text(
                            "LOG IN",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Urbanist',
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const Text(
                            "Don't have an account yet?",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF4E2F1A),
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pushReplacementNamed(context, '/manager-signup');
                            },
                            child: const Text(
                                "Sign up here",
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12,
                                  color: Colors.blue,
                                  //decoration: TextDecoration.underline,
                                )
                            )
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}