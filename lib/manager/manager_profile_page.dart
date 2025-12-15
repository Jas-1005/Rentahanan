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
      backgroundColor: const Color(0xFFFBF7F0),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (back + centered title)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF3B2418)),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Profile',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Urbanist', color: Color(0xFF3B2418)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Avatar + name
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEFE9E4),
                          image: null,
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            managerName.isNotEmpty ? managerName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join() : 'M',
                            style: const TextStyle(fontFamily: 'Urbanist', fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF3B2418)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              managerName.isNotEmpty ? managerName.toUpperCase() : 'MANAGER',
                              style: const TextStyle(fontSize: 18, fontFamily:'Urbanist', fontWeight: FontWeight.w800, color: Color(0xFF3B2418)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manager',
                              style: TextStyle(fontSize: 12, fontFamily:'Urbanist', color: Colors.black.withOpacity(0.55)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              boardingHouseName.isNotEmpty ? boardingHouseName : '',
                              style: TextStyle(fontSize: 12, fontFamily: 'Urbanist', color: Colors.black.withOpacity(0.55)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Boarding house share card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9B6A44),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.home_outlined, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                boardingHouseName.isNotEmpty ? boardingHouseName : 'Your Boarding House',
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Urbanist', fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        boardingHouseCode.isNotEmpty ? boardingHouseCode : '—',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily:'Urbanist', color: Color(0xFF3B2418)),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF9B6A44),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: GestureDetector(
                                        onTap: () => Clipboard.setData(ClipboardData(text: boardingHouseCode)),
                                        child: const Text('SHARE CODE', style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Urbanist', fontWeight: FontWeight.w700)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use this code when registering your tenants.',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontFamily: 'Urbanist'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Contact info card (email, phone)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6))
                    ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              //decoration: BoxDecoration(color: const Color(0xFFF4ECE7), borderRadius: BorderRadius.circular(10)),
                              child: Image.asset('assets/images/mail.png', width: 20, height: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Email:  $email', style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Urbanist')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              //decoration: BoxDecoration(color: const Color(0xFFF4ECE7), borderRadius: BorderRadius.circular(10)),
                              child: Image.asset('assets/images/contact.png', width: 20, height: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Phone:  $contactNumber', style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Urbanist')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Menu list
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _menuItem(
                            iconWidget: Image.asset(
                              'assets/images/editProfile.png',
                              width: 24,
                              height: 24,
                            ),
                            title: 'Edit Profile',
                            onTap: () {}),
                        _menuItem(
                            iconWidget: Image.asset(
                              'assets/images/changePassword.png',
                              width: 24,
                              height: 24,
                            ),
                            title: 'Change Password',
                            onTap: () {}),
                        //_menuItem(icon: Icons.settings_outlined, title: 'Account Details', onTap: () {}),
                        _menuItem(
                            iconWidget: Image.asset(
                              'assets/images/help.png',
                              width: 30,
                              height: 30,
                            ),
                            title: 'Help & Support',
                            onTap: () {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Large Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await logoutUser();
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC46855),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('LOGOUT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Urbanist', color: Color(0xFFFFFFFF))),
                    ),
                  ),

                  const SizedBox(height: 140),
                ],
              ),
            ),

            // bottom nav (kept for parity)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                bottom: true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 370,
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ManagerHelper.buildNavItems(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontFamily: 'Urbanist', color: Colors.black.withOpacity(0.6))),
        const SizedBox(height: 6),
        Text(value.isNotEmpty ? value : 'N/A', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Urbanist')),
      ],
    );
  }

  Widget _menuItem({required Widget iconWidget, required String title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2))),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              //decoration: BoxDecoration(color: const Color(0xFFF4ECE7), borderRadius: BorderRadius.circular(10)),
              child: iconWidget,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'))),
            const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
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