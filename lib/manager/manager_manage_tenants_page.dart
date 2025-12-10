import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
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
                            child: Column(
                              children: [
                                Text("Name"),
                                Text("Room name and type"),
                                Text("Payment status and due date"),
                                Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(context, '/manager-view-tenant-info', arguments: "tenant ID"),
                                        child: Text("VIEW INFO")
                                    ),
                                    ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(context, '/manager-input-tenant-due', arguments: "tenant ID"),
                                        child: Text("ADD DUES")
                                    )
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
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
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
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Search tenant...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Sort Button
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                Text("Sort By",
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600)),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Filter Button
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Color(0xFF3A2212),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.filter_list, color: Colors.white, size: 22),
                SizedBox(width: 4),
                Text("Filter",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

