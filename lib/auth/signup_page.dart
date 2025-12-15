
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentahanan/tenant/tenant_signup_page.dart';
import 'package:rentahanan/manager/manager_signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFBF7F0),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFBF7F0),
              title: Text(
                  "Signup",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF301600),
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Manager",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF301600),
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Tenant",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ManagerSignupPage(),
                TenantSignupPage()
              ],
            ),
          ),
        )
    );
  }
}
