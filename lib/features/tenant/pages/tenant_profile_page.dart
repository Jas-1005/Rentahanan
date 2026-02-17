import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TenantProfilePage extends StatefulWidget {
  const TenantProfilePage({super.key});

  @override
  State<TenantProfilePage> createState() => _TenantProfilePageState();
}

class _TenantProfilePageState extends State<TenantProfilePage> {
  // User? manager = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  String tenantName = "";
  String boardingHouseName = "";
  String email = "";
  String contactNumber = "";

  @override
  void initState() {
    super.initState();
    _listenAndLoadTenantData(); // Start listening and loading when widget initializes
  }

  Future <void> changePassword() async {

  }

  Future <void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  void _listenAndLoadTenantData() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      // This listener will give you the most up-to-date user object
      // whenever the auth state changes.
      if (user != null) {
        // User is signed in, proceed to load data
        setState(() {
          _isLoading = true; // Show loading indicator
        });
        await _loadTenantData(user); // Pass the user object to the loading function
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      } else {
        // User is signed out or not logged in. Clear data and show signed out state.
        setState(() {
          tenantName = "Not logged in";
          boardingHouseName = "";
          email = "";
          contactNumber = "";
          _isLoading = false;
        });
      }
    });
  }


  Future<void> _loadTenantData(User user) async { // Now accepts User object
    print("Tenant is not null, UID: ${user.uid}");

    try {
      final tenantUserQuery = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isEqualTo: user.uid)
          .where('role', isEqualTo: 'tenant')// Use the user object passed to the function
          .get();

      if(tenantUserQuery.docs.isEmpty){
        print("No tenant found with UID: ${user.uid}");
        setState(() {
          tenantName = "tenant profile not found";
          boardingHouseName = "";
          email = user.email ?? "N/A";
          contactNumber = "";
        });
        return;
      }

      print("tenant Collection Exists: YES");
      final tenantData = tenantUserQuery.docs.first.data();


      // Corrected: Assuming boardingHouseID is a String
      final String? boardingHouseId = tenantData["boardingHouseId"] as String?;
      print("tenant's boardingHouseId: $boardingHouseId"); // Crucial print

      if (boardingHouseId != null && boardingHouseId.isNotEmpty) {
        final boardingHouseDoc = await FirebaseFirestore.instance
            .collection('boardingHouses')
            .doc(boardingHouseId) // Corrected access
            .get();

        if (boardingHouseDoc.exists) {
          final boardingHouseData = boardingHouseDoc.data()!;
          setState(() {
            tenantName = tenantData['fullName'] as String? ?? "N/A";
            boardingHouseName = boardingHouseData['name'] as String? ?? "N/A";
            email = tenantData['email'] as String? ?? user.email ?? "N/A";
            contactNumber = tenantData['contactNumber'] as String? ?? "N/A";
          });
        } else {
          print("Boarding House document not found for ID: $boardingHouseId");
          setState(() {
            tenantName = tenantData['fullName'] as String? ?? "N/A";
            boardingHouseName = "Boarding House not found";
            email = tenantData['email'] as String? ?? user.email ?? "N/A";
            contactNumber = tenantData['contactNumber'] as String? ?? "N/A";
          });
        }
      } else {
        print("No boardingHouseID found for tenant.");
        setState(() {
          tenantName = tenantData['fullName'] as String? ?? "N/A";
          boardingHouseName = "No Boarding House assigned";
          email = tenantData['email'] as String? ?? user.email ?? "N/A";
          contactNumber = tenantData['contactNumber'] as String? ?? "N/A";
        });
      }


    } catch (e) {
      print("Error loading tenant data: $e");
      setState(() {
        tenantName = "Error loading data";
        boardingHouseName = "Error loading data";
        email = "Error loading data";
        contactNumber = "Error loading data";
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadtenantData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                Text("Tenant Profile"),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      Text("Tenant Name: $tenantName"),
                      Text("Boarding House Name: $boardingHouseName"),
                      Text("Email Address: $email"),
                      Text("Contact Number: $contactNumber"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Change password"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Edit user information"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await logoutUser();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Logout')
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: TenantHelper.buildNavItems(context),
                ),
              ],
            )
        )
    );
  }
}

// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// ElevatedButton(
// onPressed: () => Navigator.pushReplacementNamed(context, '/'),
// child: Text('Logout')
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: tenantHelper.buildNavItems(context)
// ),
// ]
// ),