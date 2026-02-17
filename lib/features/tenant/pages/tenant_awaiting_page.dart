import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TenantAwaitingPage extends StatefulWidget {
  const TenantAwaitingPage({super.key});

  @override
  State<TenantAwaitingPage> createState() => _TenantAwaitingPageState();
}

class _TenantAwaitingPageState extends State<TenantAwaitingPage> {
  late final String userId;
  late final Stream<DocumentSnapshot> tenantStream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      tenantStream = FirebaseFirestore.instance.collection('tenants').doc(userId).snapshots();

      // Listen to changes
      tenantStream.listen((snapshot) {
        if (!mounted) return;

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final isConfirmed = data['isConfirmedByManager'] ?? false;

          if (isConfirmed) {
            Navigator.pushReplacementNamed(context, '/tenant-dashboard');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Please wait for your boarding house manager\'s confirmation.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}