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
  /*
  static final List<Map<String, dynamic>> menuItems = [
    {'image': 'assets/images/manageTenants.png', 'label': 'Tenants', 'route': '/manager-manage-tenants'},
    {'image': 'assets/images/inputDues.png', 'label': 'Input Dues', 'route': '/manager-input-tenant-due', 'tenantID': "T1234",}, //theres a problem with imput tenant dues
    {'image': 'assets/images/approvePayments.png', 'label': 'Approve\nPayments', 'route': '/manager-tenant-requests'},
    {'image': 'assets/images/reportsPage.png', 'label': 'Reports', 'route': '/manager-view-reports'},
    {'image': 'assets/images/aboutPage.png', 'label': 'About', 'route': '/manager-about'}, //where is about page?
  ];
*/
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

// card for announcements
  Widget softCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }

  //card for dashboard overview

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
              color: Color(0xFF9B6A44),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                const Text(
                  "Dashboard Overview:",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                  ),
                ),

                 */
                //const SizedBox(height: 15),

                // Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Total Tenants",
                            style: TextStyle(
                                color: Colors.white,
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
                          Navigator.pushNamed(context, '/manager-tenant-requests'),
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
                          fontSize: 16,
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pending Payments",
                            style: TextStyle(
                                color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        SizedBox(height: 6),
                        //sample only
                        Text(
                          "₱18,450",
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Text(
                              "Pending Reports",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            // view button (compact)
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/manager-reports'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                minimumSize: const Size(36, 20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              child: const Text(
                                "View",
                                style: TextStyle(
                                  //color: Color(0xFF9B6A44),
                                  fontFamily: 'Urbanist',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 6),
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
/*
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
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.75,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: menuItems.map((item) {
                return InkWell(
                  onTap: () => {
                    if (item['tenantID'] != null){
                      Navigator.pushNamed(
                        context,
                        item['route'],
                        arguments: item['tenantID'],   // <-- passes tenantID
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
          */
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7F0),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main content with bottom padding for navbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/LOGO.png',
                        height: 30,
                        errorBuilder: (context, error, stack) {
                          debugPrint('LOGO load error: $error');
                          return const Icon(Icons.broken_image, size: 30, color: Colors.red);
                        },
                      ),
                      /*
                      const SizedBox(width: 80),
                      Text(
                        "Hello, manager!",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4E2F1A),
                        ),
                      ),

                       */
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
                  Text(
                    "Hello, manager!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4E2F1A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  dashboardOverviewCard(context),

              const SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: DashboardButton(
                          image: 'assets/images/tenants.png',
                          title: "Manage\nTenants",
                          //subtitle: "Add, edit, and delete tenants here.",
                          onTap: () {
                            Navigator.pushNamed(context, '/manager-manage-tenants');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: DashboardButton(
                          image: 'assets/images/approve.png',
                          title: "Approve\nPayments",
                          //subtitle: "Approve cash payments here.",
                          onTap: () {
                            Navigator.pushNamed(context, '/manager-manage-tenant-payments');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: DashboardButton(
                          image: 'assets/images/dues.png',
                          title: "Input Dues",
                          //subtitle: "Add tenants rent dues here.",
                          onTap: () {
                            Navigator.pushNamed(
                              context, '/placeholder-page',
                              arguments: {
                              'tenantID': 'T1234',
                            },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: DashboardButton(
                          image: 'assets/images/transactions.png',
                          title: "Transactions",
                          //subtitle: "Check all approved transactions here.",
                          onTap: () {
                            Navigator.pushNamed(context, '/placeholder-page');
                          },
                        ),
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
                                color: Color(0xFF222222),
                              ),
                            ),
                        ),
                        Row(
                          children: [
                            _roundedIconButton(Icons.add),
                            const SizedBox(width:3),
                            _roundedIconButton(Icons.edit),
                            const SizedBox(width: 3),
                            _roundedIconButton(Icons.delete),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //sample only
                    const Text(
                      "Power outage notice: Scheduled maintenance on Oct. 17, 1–3 PM. Expect temporary interruption!",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: Color(0xFF222222)),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/placeholder-page'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              "View",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9B6A44),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF9B6A44)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              // dashboard overview card

              const SizedBox(height: 150),
            ],
          ),
        ),
        // nav bar should be fixed at bottom
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
            )
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String image;
  final String title;
  //final String subtitle;
  final VoidCallback onTap;

  const DashboardButton({
    super.key,
    required this.image,
    required this.title,
    //required this.subtitle,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 84, // explicit height for compact button
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) {
                debugPrint('Dashboard button image load error: $image -> $error');
                return const Icon(Icons.broken_image, size: 28, color: Colors.red);
              },
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  /*
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                   */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
