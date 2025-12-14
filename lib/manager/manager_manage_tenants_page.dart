import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/tenant.dart';

class ManagerManageTenantsPage extends StatefulWidget {
  const ManagerManageTenantsPage({super.key});

  @override
  State<ManagerManageTenantsPage> createState() => _ManagerManageTenantsPageState();
}

class _ManagerManageTenantsPageState extends State<ManagerManageTenantsPage> {
  late List<Tenant> approvedTenants;

  Future <void> fetchTenants() async { //firebase fetch info from manager info
    var selfDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var selfBoardingHouseId = selfDoc['boardingHouseId'];

    var pendingTenantCollection = await FirebaseFirestore.instance.collection('users')
        .where('boardingHouseId', isEqualTo: selfBoardingHouseId)
        .where('role', isEqualTo: 'tenant')
        .where('confirmedByManager', isEqualTo: 'approved')
        .get();

    List<Tenant> approvedList = [];
    for (var tenantDoc in pendingTenantCollection.docs){
      var tenant = Tenant(
          id: tenantDoc.id,
          fullName: tenantDoc['fullName'],
          email: tenantDoc['email'],
          contactNumber: tenantDoc['contactNumber']);
      approvedList.add(tenant);
    }

    setState(() {
      approvedTenants = approvedList;
    });
  }

  @override
  void initState() {
    fetchTenants();
    super.initState();
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
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: approvedTenants.length,
                          itemBuilder: (context, index) {
                            return _buildTenantCard(tenant: approvedTenants[index]);
                          },
                        )
                      ],
                    ),
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

  Widget _buildTenantCard({required Tenant tenant}) {
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
              tenant.image,
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
                  tenant.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B2418),
                  ),
                ),
                Text(
                  tenant.roomName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontFamily: 'Urbanist',
                  ),
                ),
                Text(
                  tenant.paymentStatus,
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
                          arguments: tenant,
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
                          arguments: tenant,
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



