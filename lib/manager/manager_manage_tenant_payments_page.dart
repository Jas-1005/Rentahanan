import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentahanan/entities/payment.dart';

class ManagerManageTenantPaymentsPage extends StatefulWidget {
  const ManagerManageTenantPaymentsPage({super.key});

  @override
  State<ManagerManageTenantPaymentsPage> createState() => _ManagerManageTenantPaymentsPageState();
}

class _ManagerManageTenantPaymentsPageState extends State<ManagerManageTenantPaymentsPage> {
  List<Payment> pendingPayments = [];
  List<Payment> approvedPayments = [];
  List<Payment> rejectedPayments = [];

  final dateFormatter = DateFormat('MMMM dd, yyyy');

  Future<void> fetchPayments() async {
    var pendingCollection = await FirebaseFirestore.instance
        .collection('payments')
        .where('status', isEqualTo: 'pending')
        .get();

    List<Payment> pendingList = pendingCollection.docs.map((doc) {
      return Payment(
        id: doc.id,
        date: (doc['datePaid'] as Timestamp).toDate(),
        type: doc['type'],
        status: doc['status'],
        amount: doc['amount'],
        note: doc['remarks'],
      );
    }).toList();

    var rejectedCollection = await FirebaseFirestore.instance
        .collection('payments')
        .where('status', isEqualTo: 'rejected')
        .get();

    List<Payment> rejectedList = rejectedCollection.docs.map((doc) {
      return Payment(
        id: doc.id,
        date: (doc['datePaid'] as Timestamp).toDate(),
        type: doc['type'],
        status: doc['status'],
        amount: doc['amount'],
        note: doc['remarks'],
      );
    }).toList();

    var approvedCollection = await FirebaseFirestore.instance
        .collection('payments')
        .where('status', isEqualTo: 'approved')
        .get();

    List<Payment> approvedList = approvedCollection.docs.map((doc) {
      return Payment(
        id: doc.id,
        date: (doc['datePaid'] as Timestamp).toDate(),
        type: doc['type'],
        status: doc['status'],
        amount: doc['amount'],
        note: doc['remarks'],
      );
    }).toList();

    setState(() {
      pendingPayments = pendingList;
      approvedPayments = approvedList;
      rejectedPayments = rejectedList;
    });
  }

  Future<void> approvePayment(String paymentId) async {
    await FirebaseFirestore.instance
        .collection('payments')
        .doc(paymentId)
        .update({'status': 'approved'});
    await fetchPayments();
  }

  Future<void> rejectPayment(String paymentId) async {
    await FirebaseFirestore.instance
        .collection('payments')
        .doc(paymentId)
        .update({'status': 'rejected'});
    await fetchPayments();
  }

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F1EC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F1EC),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Approve Tenant Payments",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist',
              color: Color(0xFF3B2418),
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
            color: Color(0xFF3B2418),
          ),
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFF3B2418),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF3B2418),
              tabs: [
                Tab(text: "Pending"),
                Tab(text: "Approved"),
                Tab(text: "Rejected"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPaymentList(pendingPayments, status: "pending", isPending: true),
                  _buildPaymentList(approvedPayments, status: "approved", isPending: false),
                  _buildPaymentList(rejectedPayments, status: "rejected", isPending: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentList(List<Payment> payments, {required String status, required bool isPending}) {
    if (payments.isEmpty) {
      String initialText;
      if (status == "pending") {
        initialText = "No pending payments.";
      } else if (status == "approved") {
        initialText = "No approved payments.";
      } else {
        initialText = "No rejected payments.";
      }
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status == "pending" ? Icons.inbox_outlined : Icons.hourglass_empty,
              size: 56,
              color: const Color(0xFFBDBDBD),
            ),
            const SizedBox(height: 12),
            Text(
              initialText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
                color: Color(0xFF3B2418),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: ListTile(
            title: Text(
              "₱${payment.amount.toStringAsFixed(2)} - ${payment.type}",
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B2418),
              ),
            ),
            subtitle: Text(
              DateFormat('MMMM dd, yyyy').format(payment.date),
              style: const TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.black54,
              ),
            ),
            trailing: isPending
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => approvePayment(payment.id),
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
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => rejectPayment(payment.id),
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
            )
                : null,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Remarks"),
                  content: Text(payment.note ?? 'No remarks'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
