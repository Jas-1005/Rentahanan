import 'package:flutter/material.dart';
import 'manager_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  static final List<Map<String, dynamic>> menuItems = [
    {'image': 'assets/images/manageTenants.png', 'label': 'Tenants', 'route': '/manager-manage-tenants'},
    {'image': 'assets/images/inputDues.png', 'label': 'Input\nDues', 'route': '/manager-input-tenant-due', 'tenantID': "T1234",}, //theres a problem with imput tenant dues
    {'image': 'assets/images/approvePayments.png', 'label': 'Approve\nPayment', 'route': '/manager-tenant-requests'},
    {'image': 'assets/images/aboutPage.png', 'label': 'About', 'route': '/manager-about'}, //where is about page?
    {'image': 'assets/images/reportsPage.png', 'label': 'Reports', 'route': '/manager-view-reports'},
  ];

  String managerName = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenAndLoadManagerFullName(); // Start listening and loading when widget initializes
  }

  void _listenAndLoadManagerFullName() {
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
        });
        return;
      }


      final managerData = managerUserQuery.docs.first.data();
      setState(() {
        managerName = managerData['fullName'] as String? ?? "N/A";
      });
      // print("Manager Collection Exists: YES");

    } catch (e) {
      print("Error loading manager data: $e");
      setState(() {
        managerName = "Error loading data";
      });
    }
  }

  Widget _roundedIconButton(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Color(0xFF3B2418), size: 22),
    );
  }

// two cards for announcements and dashboard overview
  Widget softCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }

  Widget dashboardOverviewCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // top brown section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF3A2212),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dashboard Overview:",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 22),

                // Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("TOTAL TENANTS",
                            style: TextStyle(
                                color: Colors.white70,
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 6),
                        //sample only
                        Text(
                          "20",
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/manager-add-tenant'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                          "+ Add Tenant",
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("PENDING PAYMENTS",
                            style: TextStyle(
                                color: Colors.white70,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        SizedBox(height: 6),
                        //sample only
                        Text(
                          "Php 18,450",
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("PENDING REPORTS",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 6),
                        //sample only
                        Text(
                          "5",
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // bottom white section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: menuItems.map((item) {
                return InkWell(
                  onTap: () => {
                    if (item['tenantID'] != null){
                      Navigator.pushNamed(
                        context,
                        item['route'],
                        arguments: item['tenantID'],
                      )
                    } else {
                      Navigator.pushNamed(context, item['route'])
                    }
                  },
                  child: _BottomIcon(
                    image: item['image'],
                    label: item['label'],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1EC),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/LOGO.png', height: 30),
                          const SizedBox(width: 5),

                          Baseline(
                            baseline: 32,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              "Hello, Mngr. $managerName!",
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4E2F1A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.notifications,
                            size: 30, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  //announcements
                  softCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Announcements:',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3B2418),
                                  ),
                                ),
                            ),
                            Row(
                              children: [
                                _roundedIconButton(Icons.add),
                                const SizedBox(width: 6),
                                _roundedIconButton(Icons.edit),
                                const SizedBox(width: 6),
                                _roundedIconButton(Icons.delete),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Power outage notice: Scheduled maintenance on Oct. 17, 1–3 PM. Expect temporary interruption!",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: Color(0xFF222222)),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/announcement'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "View",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3B2418),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF3B2418)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  dashboardOverviewCard(context),
                  const SizedBox(height: 150),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
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
            )
          ],
        ),
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final String image;
  final String label;

  const _BottomIcon({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        Image.asset(image, width: 40, height: 40),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}
