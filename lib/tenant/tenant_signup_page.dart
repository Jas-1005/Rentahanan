
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
  String confirmPassword = '';
  String boardingHouseCode = '';
  String contactNumber = '';
  String errorMessage = '';
  String isTenantConfirmed = "pending";
  List<bool> _obscureText = [true, true];
  bool _isLoading = false;
  String boardingHouseID = '';

  @override
  void initState() {
    super.initState();// Start listening and loading when widget initializes
  }

  Future <bool> _verifyBHCodeAndFetchBHCode(String tenantShareCode) async {
    try {
      QuerySnapshot bHCodeQuery = await FirebaseFirestore.instance
          .collection('boardingHouses')
          .where('shareCode', isEqualTo: tenantShareCode)
          .limit(1)
          .get();

      if (bHCodeQuery.docs.isNotEmpty) {
        var bHCodeSnapshot = bHCodeQuery.docs.first;
        print("Boarding house ID: ${bHCodeSnapshot.id}");
        boardingHouseID = bHCodeSnapshot.id;
        return true;
      } else {
        print('No bh found with code: $tenantShareCode');
        return false;
      }
    } catch (e) {
      print("Error querying Firestore: $e");
      return false;
    }
  }

  Future <void> handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if(!(await _verifyBHCodeAndFetchBHCode(boardingHouseCode))){
        setState(() {
          errorMessage = "Invalid boarding house code.";
        });
        return;
      }

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

      await FirebaseFirestore.instance.collection('users').doc(userID).set({
        'boardingHouseId': boardingHouseID,
        'fullName': fullName,
        'email': email,
        'contactNumber': contactNumber,
        'confirmedByManager': isTenantConfirmed,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if(!mounted) return;
      //make a firestore query here if tennat is confirmed by manager, if tennat confirmed, go to dashboard,
      // if not, go to unconfirmed (do the same for login??)
      Navigator.pushReplacementNamed(context, '/tenant-dashboard');

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

  Widget buildInfoTextField({
    required String label,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget buildPasswordTextField({
    required String label,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    required int stateIndex,
    TextInputType keyboardType = TextInputType.text,

  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_obscureText[stateIndex] ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureText[stateIndex] = !_obscureText[stateIndex]),
        ),
      ),
      obscureText: _obscureText[stateIndex],
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form (
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                spacing: 20,
                children: [
                  buildInfoTextField(
                    label: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please your full name';
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Please input a valid full name';
                      }
                      return null;
                    },
                    onSaved: (value) => fullName = value!,
                  ),
                  buildInfoTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter your email';
                      if (!value.contains('@') || !value.contains('.')) return 'Invalid email';
                      return null;
                    },
                    onSaved: (value) => email = value!,
                  ),
                  buildPasswordTextField(
                    label: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter your password';
                      return null;
                    },
                    onSaved: (value) => password = value!,
                    stateIndex: 0
                  ),
                  buildPasswordTextField(
                    label: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirm your password';
                      return null;
                    },
                    onSaved: (value) => confirmPassword = value!,
                    stateIndex: 1
                  ),
                  buildInfoTextField(
                    label: 'Boarding House Code',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'You need a boarding house code to create an account.';
                      return null;
                    },
                    onSaved: (value) => boardingHouseCode = value!,
                  ),
                  buildInfoTextField(
                    label: 'Contact Number',
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter your contact number.';
                        if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
                          return 'Please input a valid phone number';
                        }
                        return null;
                      },
                    onSaved: (value) => contactNumber = value!,
                    keyboardType: TextInputType.number
                  ),
                ],
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