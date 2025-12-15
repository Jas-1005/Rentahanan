import 'package:flutter/material.dart';
import 'package:rentahanan/entities/tenant.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentahanan/entities/tenant.dart';
import 'manager_helper.dart';


class ManagerViewTenantInfoPage extends StatefulWidget {
  const ManagerViewTenantInfoPage({super.key});

  @override
  State<ManagerViewTenantInfoPage> createState() => _ManagerViewTenantInfoPageState();
}

class _ManagerViewTenantInfoPageState extends State<ManagerViewTenantInfoPage> {

  Future <void> fetchTenantInfo() async {}

  Future <void> tenantActions() async {}

  @override
  Widget build(BuildContext context) {
    final tenant = ModalRoute.of(context)!.settings.arguments as Tenant;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1EC),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                    color: const Color(0xFF3B2418),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Tenant Info",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                          color: Color(0xFF3B2418),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // TENANT INFO CARD
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              tenant.image,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 140,
                                  height: 140,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 60),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tenant Name
                          Text(
                            tenant.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Urbanist',
                              color: Color(0xFF3B2418),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Room Type
                          Text(
                            tenant.roomType,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email
                          _infoField(
                            icon: Icons.email_outlined,
                            label: tenant.email,
                          ),
                          const SizedBox(height: 12),

                          // Phone
                          _infoField(
                            icon: Icons.phone_outlined,
                            label: tenant.contactNumber,
                          ),
                          const SizedBox(height: 12),

                          // Address
                          _infoField(
                            icon: Icons.location_on_outlined,
                            label: tenant.address,
                          ),
                          const SizedBox(height: 24),

                          // View Info and Add Dues Buttons
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: Navigate to payment history
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEFEBE8),
                                      foregroundColor: const Color(0xFF3A2212),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Info',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Urbanist',
                                        color: Color(0xFF3A2212),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: Navigate to view dues
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEFEBE8),
                                      foregroundColor: const Color(0xFF3A2212),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Add Dues',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Urbanist',
                                        color: Color(0xFF3A2212),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoField({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3B2418), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Urbanist',
                color: Color(0xFF222222),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
