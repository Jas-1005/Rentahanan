import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TenantSignupPage extends StatefulWidget {
  const TenantSignupPage({super.key});

  @override
  State<TenantSignupPage> createState() => _TenantSignupPageState();
}

class _TenantSignupPageState extends State<TenantSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final String role = 'tenant';
  String fullName = '';
  String email = '';
  String password = '';
  String boardingHouseCode = '';
  String contactNumber = '';
  String errorMessage = '';
  bool isTenantConfirmed = false;
  bool _obscureText = true;
  bool _isLoading = false;


  Future <void> handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password:password,
      );

      String userID = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userID).set({
        'fullName': fullName,
        'email': email,
        'boardingHouseCode': boardingHouseCode,
        'contactNumber': contactNumber,
        'confirmedByManager': isTenantConfirmed,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if(!mounted) return;
      Navigator.pushReplacementNamed(context, '/tenant-unconfirmed');

    } on FirebaseAuthException catch (e){
      String displayMessage;
      if (e.code == 'network-request-failed'){
        displayMessage = 'Network error: Please check your internet connection.';
      } else if (e.code == 'email-already-in-use'){
        displayMessage = 'Email is already registered.Try logging in.';
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
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please your full name';
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Please input a valid full name';
                  }
                  return null;
                },
                onSaved: (value) => fullName = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
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
                  labelText: 'Password',
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Boarding House Code',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),   // optional: limit length
                ],
                onSaved: (value) => boardingHouseCode = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number, // shows numeric keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // only allow digits
                  LengthLimitingTextInputFormatter(11),   // optional: limit length
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'You need a boarding house code to create an account';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Contact number can only contain digits';
                  }
                  return null;
                },
                onSaved: (value) => contactNumber = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : handleSignup,
                child: _isLoading
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : Text('SIGN UP'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  const Text("Already have an account?"),
                  InkWell(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/tenant-login');
                      },
                      child: const Text(
                          "Log in here",
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