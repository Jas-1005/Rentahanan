import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'manager_helper.dart';


class ManagerTenantRequestsPage extends StatefulWidget {
  const ManagerTenantRequestsPage({super.key});

  @override
  State<ManagerTenantRequestsPage> createState() => _ManagerTenantRequestsPageState();
}

class _ManagerTenantRequestsPageState extends State<ManagerTenantRequestsPage> {

  Future <void> fetchTenants() async { //firebase fetch info from manager info

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
                  Tab(text: "Pending"),
                  Tab(text: "Denied"),
                ],
              ),
              
              // TAB BAR VIEW
              Expanded(
                child: TabBarView(
                  children: [
                    // PENDING TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        children: [
                          _buildRequestCard(
                            name: "Full Name",
                            email: "email@example.com",
                            phone: "(09XX) - XXX - XXXX",
                            onApprove: () {},
                            onDeny: () {},
                          ),
                        ],
                      ),
                    ),

                    // DENIED TAB
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        children: [
                          _buildRequestCard(
                            name: "Full Name",
                            email: "email@example.com",
                            phone: "(09XX) - XXX - XXXX",
                            onApprove: null,
                            onDeny: null,
                            isDenied: true,
                          ),
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

  Widget _buildRequestCard({
    required String name,
    required String email,
    required String phone,
    VoidCallback? onApprove,
    VoidCallback? onDeny,
    bool isDenied = false,
  }) {
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
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    color: Color(0xFF3B2418),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Urbanist',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
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
              onPressed: onApprove,
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
              onPressed: onDeny,
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
                "Deny",
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
