import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentahanan/tenant/tenant_signup_page.dart';
import 'package:rentahanan/manager/manager_signup_page.dart';

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
              title: Text("Signup"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Manager"),
                  Tab(text: "Tenant"),
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
