import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManagerSignupPage extends StatefulWidget {
  const ManagerSignupPage({super.key});

  @override
  State<ManagerSignupPage> createState() => _ManagerSignupPageState();
}

class _ManagerSignupPageState extends State<ManagerSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final String role = 'manager';
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String boardingHouseName = '';
  String contactNumber = '';
  String errorMessage = '';
  List<bool> _obscureText = [true, true];
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

  Widget buildPasswordField(String label, Function(String?) onSaved, int index) {
    return TextFormField(
      obscureText: _obscureText[index],
      decoration: InputDecoration(
        hintText: label,
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
          icon: Icon(_obscureText[index] ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText[index] = !_obscureText[index]),
        ),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    );
  }
  
  Future <String> generateUniqueShareCode() async {
    String shareCode;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    
    while(true){
      shareCode = List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
      
      final shareCodeQuery = await FirebaseFirestore.instance
          .collection('boardingHouses')
          .where('shareCode', isEqualTo: shareCode)
          .get();

      if(shareCodeQuery.docs.isEmpty) break;
    }

    return shareCode;
  }

  Future <void> handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {

      if(password != confirmPassword){
        setState(() {
          errorMessage = "Passwords do not match.";
        });
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password:password,
      );

      String userID = userCredential.user!.uid;

      final shareCode = await generateUniqueShareCode();
      final boardingHouse = await FirebaseFirestore.instance
          .collection('boardingHouses')
          .add({
        'name': boardingHouseName,
        'shareCode': shareCode,
        'createdAt': FieldValue.serverTimestamp()
      });

      await FirebaseFirestore.instance.collection('users').doc(userID).set({
        'fullName': fullName,
        'email': email,
        'boardingHouseId': boardingHouse.id,
        'contactNumber': contactNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'role': role,
      });

      if(!mounted) return;
      Navigator.pushReplacementNamed(context, '/manager-dashboard');

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
                  //title and logo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Create Account',
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
              const SizedBox(height: 20),
              // FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildRoundedField("Full Name", (v) => fullName = v!),
                    const SizedBox(height: 16),
                    buildRoundedField("Contact Number",
                            (v) => contactNumber = v!,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    buildRoundedField("Boarding House Name", (v) => boardingHouseName = v!),
                    const SizedBox(height: 16),
                    buildRoundedField("Email Address", (v) => email = v!),
                    const SizedBox(height: 16),
                    buildPasswordField("Password", (v) => password = v!, 0),
                    const SizedBox(height: 16),
                    buildPasswordField("Confirm Password", (v) => confirmPassword = v!, 1),
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
                        onPressed: _isLoading ? null : handleSignup,
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
                          "CONTINUE",
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
                            "Already have an account?",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF4E2F1A),
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w500,
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