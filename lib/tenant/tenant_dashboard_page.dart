import 'package:flutter/material.dart';
import 'tenant_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TenantDashboardPage extends StatefulWidget {
  const TenantDashboardPage({super.key});

  @override
  State<TenantDashboardPage> createState() => _TenantDashboardPageState();
}

class _TenantDashboardPageState extends State<TenantDashboardPage> {
  static final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.payment, 'label': 'Pay', 'route': '/tenant-pay-now'},
    {'icon': Icons.calendar_month, 'label': 'Dues', 'route': '/placeholder-page'},
    {'icon': Icons.cloud_upload_outlined, 'label': 'Upload Proof', 'route': '/placeholder-page'},
    {'icon': Icons.error_outline, 'label': 'Report Issue', 'route': '/placeholder-page'},
    {'icon': Icons.house, 'label': 'About', 'route': '/placeholder-page'},
    {'icon': Icons.notifications, 'label': 'Announcement', 'route': '/placeholder-page'},
  ];

  String tenantName = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenAndLoadTenantFullName(); // Start listening and loading when widget initializes
  }

  void _listenAndLoadTenantFullName() {
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
          tenantName = "Manager profile not found";
        });
        return;
      }


      final tenantData = tenantUserQuery.docs.first.data();
      setState(() {
        tenantName = tenantData['fullName'] as String? ?? "N/A";
      });
      // print("Manager Collection Exists: YES");

    } catch (e) {
      print("Error loading manager data: $e");
      setState(() {
        tenantName = "Error loading data";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tenant Dashboard')),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Hello, Tenant $tenantName!')
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Announcements:',
                        style: TextStyle(
                            fontSize: 24
                        ),
                      )
                  ),
                  Text('Power outage notice: Scheduled maintenance on Oct. 17, 1-3PM. Expect temporary interruption!'),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/announcement');
                          },
                          child: Text('>')
                      )
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Upcoming Dues:',
                        style: TextStyle(
                            fontSize: 24
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Php 2,950',
                            style: TextStyle(
                                fontSize: 28
                            ),
                          ),
                          Text(
                            'Due on 10/31/25',
                            style: TextStyle(
                                fontSize: 12
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/transaction');
                              },
                              child: Text('Pay Now')
                          ),
                          Text(
                            'Tap Pay Now to settle dues securely.',
                            style: TextStyle(
                                fontSize: 8
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('Rent:'),
                            Text('Php 2,500')
                          ],
                        ),
                        Column(
                          children: [
                            Text('Water:'),
                            Text('Php 100')
                          ],
                        ),
                        Column(
                          children: [
                            Text('Electricity:'),
                            Text('Php 350')
                          ],
                        ),
                        Column(
                          children: [
                            Text('Total:'),
                            Text('Php 2,950')
                          ],
                        )
                      ],
                    ),
                  ),
                  Table(
                    children: List.generate(
                      (menuItems.length / 4).ceil(), // number of rows
                          (rowIndex) {
                        final int startIndex = rowIndex * 4;
                        final int endIndex = (startIndex + 4).clamp(0, menuItems.length);
                        final rowItems = menuItems.sublist(startIndex, endIndex);

                        // Fill empty cells if less than 4 items
                        while (rowItems.length < 4) {
                          rowItems.add({'icon': null, 'label': ''});
                        }

                        return TableRow(
                          children: rowItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () => Navigator.pushNamed(context, item['route']),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item['icon'] != null) Icon(item['icon'], size: 50),
                                    if ((item['label'] ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          item['label'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: TenantHelper.buildNavItems(context)
            ),
          ],
        ),
      ),
    );
  }
}