import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'manager_helper.dart';


class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({super.key});

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  // User? manager = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;
  String managerName = "";
  String boardingHouseName = "";
  String email = "";
  String contactNumber = "";
  String boardingHouseCode = "";

  @override
  void initState() {
    super.initState();
    _listenAndLoadManagerData(); // Start listening and loading when widget initializes
  }

  Future <void> changePassword() async {

  }

  Future <void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  void _listenAndLoadManagerData() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      // This listener will give you the most up-to-date user object
      // whenever the auth state changes.
      if (user != null) {
        // User is signed in, proceed to load data
        setState(() {
          _isLoading = true; // Show loading indicator
        });
        await _loadManagerData(user); // Pass the user object to the loading function
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      } else {
        // User is signed out or not logged in. Clear data and show signed out state.
        setState(() {
          managerName = "Not logged in";
          boardingHouseName = "";
          email = "";
          contactNumber = "";
          boardingHouseCode = "";
          _isLoading = false;
        });
      }
    });
  }


  Future<void> _loadManagerData(User user) async { // Now accepts User object
    print("Manager is not null, UID: ${user.uid}");

    try {
      final managerUserQuery = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isEqualTo: user.uid)
          .where('role', isEqualTo: 'manager')// Use the user object passed to the function
          .get();

      if(managerUserQuery.docs.isEmpty){
        print("No manager found with UID: ${user.uid}");
        setState(() {
          managerName = "Manager profile not found";
          boardingHouseName = "";
          email = user.email ?? "N/A";
          contactNumber = "";
          boardingHouseCode = "";
        });
        return;
      }

      print("Manager Collection Exists: YES");
      final managerData = managerUserQuery.docs.first.data();


      // Corrected: Assuming boardingHouseID is a String
      final String? boardingHouseId = managerData["boardingHouseId"] as String?;
      print("Manager's boardingHouseId: $boardingHouseId"); // Crucial print

      if (boardingHouseId != null && boardingHouseId.isNotEmpty) {
        final boardingHouseDoc = await FirebaseFirestore.instance
            .collection('boardingHouses')
            .doc(boardingHouseId) // Corrected access
            .get();

        if (boardingHouseDoc.exists) {
          final boardingHouseData = boardingHouseDoc.data()!;
          setState(() {
            managerName = managerData['fullName'] as String? ?? "N/A";
            boardingHouseName = boardingHouseData['name'] as String? ?? "N/A";
            email = managerData['email'] as String? ?? user.email ?? "N/A";
            contactNumber = managerData['contactNumber'] as String? ?? "N/A";
            boardingHouseCode = boardingHouseData['shareCode'] as String? ?? "N/A";
          });
        } else {
          print("Boarding House document not found for ID: $boardingHouseId");
          setState(() {
            managerName = managerData['fullName'] as String? ?? "N/A";
            boardingHouseName = "Boarding House not found";
            email = managerData['email'] as String? ?? user.email ?? "N/A";
            contactNumber = managerData['contactNumber'] as String? ?? "N/A";
            boardingHouseCode = "";
          });
        }
      } else {
        print("No boardingHouseID found for manager.");
        setState(() {
          managerName = managerData['fullName'] as String? ?? "N/A";
          boardingHouseName = "No Boarding House assigned";
          email = managerData['email'] as String? ?? user.email ?? "N/A";
          contactNumber = managerData['contactNumber'] as String? ?? "N/A";
          boardingHouseCode = "";
        });
      }


    } catch (e) {
      print("Error loading manager data: $e");
      setState(() {
        managerName = "Error loading data";
        boardingHouseName = "Error loading data";
        email = "Error loading data";
        contactNumber = "Error loading data";
        boardingHouseCode = "Error loading data";
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadManagerData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Text("Manager Profile"),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Text("Manager Name: $managerName"),
                    Text("Boarding House Name: $boardingHouseName"),
                    Text("Email Address: $email"),
                    Text("Contact Number: $contactNumber"),
                    Text("Boarding House Code: $boardingHouseCode"),
                    ElevatedButton(
                        onPressed: () => Clipboard.setData(ClipboardData(text: boardingHouseCode)), 
                        child: Text("Copy to clipboard"),
                    )
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
                children: ManagerHelper.buildNavItems(context),
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
// children: ManagerHelper.buildNavItems(context)
// ),
// ]
// ),