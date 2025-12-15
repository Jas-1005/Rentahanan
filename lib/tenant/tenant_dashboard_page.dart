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
  String tenantName = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenAndLoadTenantFullName();
  }

  void _listenAndLoadTenantFullName() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        setState(() => _isLoading = true);
        await _loadTenantData(user);
        setState(() => _isLoading = false);
      } else {
        setState(() {
          tenantName = "Not logged in";
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _loadTenantData(User user) async {
    try {
      final tenantQuery = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isEqualTo: user.uid)
          .where('role', isEqualTo: 'tenant')
          .get();

      if (tenantQuery.docs.isEmpty) {
        setState(() => tenantName = "Tenant not found");
        return;
      }

      final data = tenantQuery.docs.first.data();
      setState(() => tenantName = data["fullName"] ?? "N/A");
    } catch (_) {
      setState(() => tenantName = "Error loading name");
    }
  }

  // FINAL BUTTON WIDGET
  Widget tenantActionButton(IconData icon, String label, double height) {
    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ANNOUNCEMENTS
  Widget _announcementCard() {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // TITLE + ICON
          Row(
            children: [
              Icon(Icons.notifications_active,
                  size: 22, color: Color(0xFF3A2212)),
              SizedBox(width: 8),
              Text(
                "Announcements",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3A2212),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          // MAIN TEXT
          Text(
            "Power outage notice: Scheduled maintenance on Oct. 17, 1–3 PM. Expect temporary interruption.",
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10),

          // VIEW BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/announcement'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View",
                    style: TextStyle(
                      color: Color(0xFF3A2212),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Color(0xFF3A2212)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // DUES BREAKDOWN CELL
  Widget _duesCol(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // UPCOMING DUES
  Widget _upcomingDuesCard() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upcoming Dues:",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A2212))),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("₱",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB33A2E))),
                          SizedBox(width: 3),
                          Text("2,950",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB33A2E))),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text("Due on 10/31/25",
                          style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/transaction'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB48A74),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Pay Now"),
                  )
                ],
              ),
            ],
          ),
        ),

        // BOTTOM BROWN BAR
        Container(
          height: 85,
          decoration: BoxDecoration(
            color: Color(0xFF3A2212),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _duesCol("Rent", "2500", Color(0xFFB78368)),
              _duesCol("Water", "100", Color(0xFFB78368)),
              _duesCol("Electricity", "350", Color(0xFFB78368)),
              _duesCol("Total", "2,950", Color(0xFFE3C7B9)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Tenant Dashboard")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text("Hello, Tenant $tenantName!",
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),

                    _announcementCard(),
                    SizedBox(height: 20),

                    _upcomingDuesCard(),
                    SizedBox(height: 0),

                    // FINAL 2×2 BUTTONS 
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        tenantActionButton(Icons.payment, "Pay", 85),
                        tenantActionButton(Icons.calendar_month, "Dues", 85),
                        tenantActionButton(Icons.swap_horiz, "Transactions", 85),
                        tenantActionButton(Icons.error_outline, "Report Issue", 85),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // NAVBAR
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: TenantHelper.buildNavItems(context),
            ),
          ),
        ],
      ),
    );
  }
}
