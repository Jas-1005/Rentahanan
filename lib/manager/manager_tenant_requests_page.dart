import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentahanan/entities/tenant.dart';


class ManagerTenantRequestsPage extends StatefulWidget {
  const ManagerTenantRequestsPage({super.key});

  @override
  State<ManagerTenantRequestsPage> createState() => _ManagerTenantRequestsPageState();
}

class _ManagerTenantRequestsPageState extends State<ManagerTenantRequestsPage> {
  List<Tenant>  pendingTenants = [];
  List<Tenant>  rejectedTenants = [];

  Future<void> fetchUnapprovedTenants() async {
    var selfDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    
    var selfBoardingHouseId = selfDoc['boardingHouseId'];

    // Pending Tenants
    var pendingTenantCollection = await FirebaseFirestore.instance.collection('users')
        .where('boardingHouseId', isEqualTo: selfBoardingHouseId)
        .where('role', isEqualTo: 'tenant')
        .where('confirmedByManager', isEqualTo: 'pending')
        .get();

    List<Tenant> pendingList = [];
    for (var tenantDoc in pendingTenantCollection.docs){
      var tenant = Tenant(
          id: tenantDoc.id,
          fullName: tenantDoc['fullName'],
          email: tenantDoc['email'],
          contactNumber: tenantDoc['contactNumber']);
      pendingList.add(tenant);
    }

    // Rejected Tenants
    var rejectedTenantCollection = await FirebaseFirestore.instance.collection('users')
        .where('boardingHouseId', isEqualTo: selfBoardingHouseId)
        .where('role', isEqualTo: 'tenant')
        .where('confirmedByManager', isEqualTo: 'rejected')
        .get();

    List<Tenant> rejectedList = [];
    for (var tenantDoc in rejectedTenantCollection.docs){
      var tenant = Tenant(
          id: tenantDoc.id,
          fullName: tenantDoc['fullName'],
          email: tenantDoc['email'],
          contactNumber: tenantDoc['contactNumber']);
      rejectedList.add(tenant);
    }

    setState(() {
      pendingTenants = pendingList;
      rejectedTenants = rejectedList;
    });
  }

  Future<void> approveTenant(String tenantId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(tenantId)
        .update({'confirmedByManager': 'approved'});
  }

  Future<void> rejectTenant(String tenantId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(tenantId)
        .update({'confirmedByManager': 'rejected'});
  }

  @override
  void initState() {
    fetchUnapprovedTenants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F1EC),
        body: SafeArea(
          child: Column(
            children: [
              // APP BAR
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
                      "Approve Tenants",
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
              
              // TAB BAR
              const TabBar(
                labelColor: Color(0xFF3B2418),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF3B2418),
                tabs: [
                  Tab(
                    child: Text(
                      "Pending",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Denied",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              // TAB BAR VIEW
              Expanded(
                child: TabBarView(
                  children: [
                    // PENDING TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: pendingTenants.isEmpty
                          ? SizedBox(
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.inbox_outlined, size: 56, color: Color(0xFFBDBDBD)),
                                    SizedBox(height: 12),
                                    Text(
                                      'No pending requests',
                                      style: TextStyle(
                                        fontSize: 16, 
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600, 
                                        color: Color(0xFF3B2418)),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "You don't have any tenant requests right now.",
                                      style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14,
                                          color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: pendingTenants.length,
                                  itemBuilder: (context, index) {
                                    var tenant = pendingTenants[index];
                                    return _buildRequestCard(tenant, false);
                                  },
                                )
                              ],
                            ),
                    ),

                    // DENIED TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: rejectedTenants.isEmpty
                          ? SizedBox(
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.hourglass_empty, size: 56, color: Color(0xFFBDBDBD)),
                                    SizedBox(height: 12),
                                    Text(
                                      'No denied requests',
                                      style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3B2418),
                                          fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "There are no requests you've rejected.",
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: rejectedTenants.length,
                                  itemBuilder: (context, index) {
                                    var tenant = rejectedTenants[index];
                                    return _buildRequestCard(tenant, true);
                                  },
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Tenant tenant, bool isDenied) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tenant.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    color: Color(0xFF3B2418),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tenant.email,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tenant.contactNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (!isDenied) ...[
            ElevatedButton(
              onPressed: () async {
                await approveTenant(tenant.id);
                await fetchUnapprovedTenants();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFEBE8),
                foregroundColor: const Color(0xFF3A2212),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Approve",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                  color: Color(0xFF3A2212),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                await rejectTenant(tenant.id);
                await fetchUnapprovedTenants();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A2212),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Reject",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
