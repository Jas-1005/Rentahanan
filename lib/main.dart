import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rentahanan/auth/auth.dart';
import 'package:rentahanan/manager/manager.dart';
import 'package:rentahanan/tenant/tenant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentahanan',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        // '/manager-login': (context) => const ManagerLoginPage(),
        // '/manager-signup': (context) => const ManagerSignupPage(),
        // '/tenant-login': (context) => const TenantLoginPage(),
        // '/tenant-signup': (context) => const TenantSignupPage(),
        '/tenant-unconfirmed': (context) => const TenantUnconfirmedPage(),
        '/manager-dashboard': (context) => const ManagerDashboardPage(),
        '/manager-manage-tenants': (context) => const ManagerManageTenantsPage(),
        '/manager-view-tenant-info': (context) => const ManagerViewTenantInfoPage(),
        '/manager-tenant-requests': (context) => const ManagerTenantRequestsPage(),
        '/manager-input-tenant-due': (context) => const ManagerInputTenantDuePage(),
        '/manager-profile': (context) => const ManagerProfilePage(),
        '/tenant-dashboard': (context) => const TenantDashboardPage(),
        '/tenant-profile': (context) => const TenantProfilePage(),
      },
    );
  }
}






