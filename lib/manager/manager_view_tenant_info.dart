import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'manager_helper.dart';


class ManagerViewTenantInfoPage extends StatefulWidget {
  const ManagerViewTenantInfoPage({super.key});

  @override
  State<ManagerViewTenantInfoPage> createState() => _ManagerViewTenantInfoPageState();
}

class _ManagerViewTenantInfoPageState extends State<ManagerViewTenantInfoPage> {

  Future <void> fetchTenantInfo() async { //firebase fetch info from manager info

  }

  Future <void> tenantActions() async {

  }


  @override
  Widget build(BuildContext context) {
    final tenantID = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        backgroundColor: const Color(0xFFF3F1EC),
        //appBar: AppBar(title: Text("Tenant Info (id: $tenantID)")),
        body: SafeArea(
          child: Column(
            children: [
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
              ],
            ),
        ),
    );
  }
}
