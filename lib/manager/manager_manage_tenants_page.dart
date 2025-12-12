import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manager_helper.dart';

class ManagerManageTenantsPage extends StatefulWidget {
  const ManagerManageTenantsPage({super.key});

  @override
  State<ManagerManageTenantsPage> createState() => _ManagerManageTenantsPageState();
}

class _ManagerManageTenantsPageState extends State<ManagerManageTenantsPage> {

  Future <void> fetchTenants() async { //firebase fetch info from manager info

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Manage Tenants")),
      backgroundColor: const Color(0xFFFBF7F0),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                    color: const Color(0xFF3B2418),
                  ),
                  const Text(
                    "Manage Tenants",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Urbanist',
                      color: Color(0xFF3B2418),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            // TENANT LIST
            Expanded(
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance //firebase firestore path to tenants
                          .collection('tenants')
                          .snapshots(),
                      builder: (context, snapshot) { //builder for tenant list
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) { //loading state
                          return const Center(child: CircularProgressIndicator());
                        }
                        final tenantDocs = snapshot.data!.docs; //list of tenant documents
                        if (tenantDocs.isEmpty) { 
                          return const Center(child: Text('No tenants found'));
                        }
                        return SingleChildScrollView( 
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: tenantDocs.map((doc) { //map each document to TenantCard
                              final tenant = Tenant.fromDoc(doc);
                              return TenantCard(
                                image: tenant.image ?? 'assets/images/user1.png',
                                name: tenant.name,
                                roomInfo: tenant.roomInfo,
                                paymentStatus: tenant.paymentStatus,
                              );
                            }).toList(), 
                          ),
                        );
                      },
                    ),
                    //ICON BUTTON TO ADD TENANT REQUEST PAGE
                    Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xFF9B6A44)
                            ),
                            child: SizedBox(
                              height: 55,
                              width: 55,
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () => Navigator.pushNamed(context, '/manager-tenant-requests'),
                                  color: Colors.white,
                                  icon: Icon(Icons.add, size: 44)
                              ),
                            )
                        )
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.brown.withOpacity(0.4)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Search tenant",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown.withOpacity(0.4),
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Filter Button
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Color(0xFF3A2212),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: const Row(
              children: [
                SizedBox(width: 4),
                Text("Filter",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFBF7F0),
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600)),
                Icon(Icons.filter_list, color: Color(0xFFFBF7F0), size: 22),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Sort Button
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: Row(
              children: [
                Text("Sort By",
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        color: Color(0xFF301600),
                        fontWeight: FontWeight.w600)),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

// Tenant model
class Tenant {
  final String id;
  final String name;
  final String roomInfo;
  final String paymentStatus;
  final String? image;

  Tenant({
    required this.id,
    required this.name,
    required this.roomInfo,
    required this.paymentStatus,
    this.image,
  });

  factory Tenant.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Tenant(
      id: doc.id,
      name: data['fullName'] as String? ?? 'No name',
      roomInfo: data['roomInfo'] as String? ?? '',
      paymentStatus: data['paymentStatus'] as String? ?? '',
      image: data['image'] as String?,
    );
  }
}

// add class for tenant card widget
class TenantCard extends StatelessWidget {
  final String image;
  final String name;
  final String roomInfo;
  final String paymentStatus;

  const TenantCard({
    super.key,
    required this.image,
    required this.name,
    required this.roomInfo,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person),
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B2418),
                  ),
                ),
                Text(
                  roomInfo,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: 'Urbanist',
                  ),
                ),
                Text(
                  paymentStatus,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/manager-view-tenant-info',
                          arguments: name,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEFEBE8),
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "VIEW INFO",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF3A2212),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/manager-input-tenant-due',
                          arguments: name,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A2212),
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "ADD DUES",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



