import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'manager_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: const Color(0xFFF3F1EC),
      body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(padding: const EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                  color: const Color(0xFF3B2418),
                ),
                const Text(
                  "Tenants",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Urbanist',
                    color: Color(0xFF3B2418),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
            _buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                )
                            ),
                            // List of tenants
                            child: Column(
                              children: [
                                Text("Name"),
                                Text("Room name and type"),
                                Text("Payment status and due date"),
                                Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/manager-view-tenant-info',
                                            arguments: "tenant ID",
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFEFEBE8),
                                          foregroundColor: Colors.white,
                                          elevation: 6,
                                          shadowColor: Colors.black54,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                            "VIEW INFO",
                                          style: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Color(0xFF3A2212),
                                          ),
                                        )
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/manager-input-tenant-due',
                                            arguments: "tenant ID",
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF3A2212), // dark brown
                                          foregroundColor: Colors.white,
                                          elevation: 6,
                                          shadowColor: Colors.black54,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                            "ADD DUES",
                                          style: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ),
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

// add class for tenant card widget
class TenantCard extends StatelessWidget {
  final String image;
  final String name;
  final String roomType;

  const TenantCard({
    super.key,
    required this.image,
    required this.name,
    required this.roomType,
});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    fontSize: 18,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B2418),
                  ),
                ),
                Text(
                  "Room Type: $roomType",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            )
          )
        ],
      )
    );
  }
}



