import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rentahanan/entities/payment.dart';


class TenantPayNowPage extends StatefulWidget {
  const TenantPayNowPage({super.key});

  @override
  State<TenantPayNowPage> createState() => _TenantPayNowPageState();
}

class _TenantPayNowPageState extends State<TenantPayNowPage> {
  List<Payment> paymentHistory = [];
  final dateFormatter = DateFormat('MMMM dd, yyyy');

  static final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.account_balance_wallet, 'label': 'Pay with Gcash', 'route': '/placeholder-page'},
    {'icon': Icons.attach_money, 'label': 'Cash', 'route': '/tenant-pay-with-cash'},
    {'icon': Icons.account_balance, 'label': 'Pay Through Bank', 'route': '/placeholder-page'},
    {'icon': Icons.public, 'label': 'OTC', 'route': '/placeholder-page'},
  ];

  Future<void> fetchTenantPayments() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    var paymentCollection = await FirebaseFirestore.instance.collection('payments')
        .where('payerId', isEqualTo: userId)
        .get();

    List<Payment> paymentList = [];
    for (var paymentDoc in paymentCollection.docs){
      var payment = Payment(
          id: paymentDoc.id,
          date: (paymentDoc['datePaid'] as Timestamp).toDate(),
          type: paymentDoc['type'],
          status: paymentDoc['status'],
          amount: paymentDoc['amount'],
          note: paymentDoc['remarks']);
      paymentList.add(payment);
    }

    setState(() {
      paymentHistory = paymentList;
    });

  }

  @override
  void initState() {
    super.initState();
    fetchTenantPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Now')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Options',
                      style: TextStyle(
                        fontSize: 24
                      ),
                    ),
                  ),
                  Table(
                    children: List.generate(
                      (menuItems.length / 4).ceil(), // number of rows
                          (rowIndex) {
                        final int startIndex = rowIndex * 4;
                        final int endIndex = (startIndex + 4).clamp(0, menuItems.length);
                        final rowItems = menuItems.sublist(startIndex, endIndex);

                        // Fill empty cells if less than 4 items
                        while (rowItems.length < 4) {
                          rowItems.add({'icon': null, 'label': ''});
                        }

                        return TableRow(
                          children: rowItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () => Navigator.pushNamed(context, item['route']),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item['icon'] != null) Icon(item['icon'], size: 50),
                                    if ((item['label'] ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          item['label'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment History',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: paymentHistory.isEmpty
                          ? const Center(child: Text('No payments yet'))
                          : ListView.builder(
                        itemCount: paymentHistory.length,
                        itemBuilder: (context, index) {
                          final payment = paymentHistory[index];
                          return Card(
                            child: ListTile(
                              title: Text(dateFormatter.format(payment.date)),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(payment.type),
                                    Text(payment.status),
                                  ]
                              ),
                              trailing: Text('₱${payment.amount.toStringAsFixed(2)}'),
                              // Add a button to view remarks
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: const Text('Remarks'),
                                      content: Text(payment.note ?? 'No remarks'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Close'),
                                        )
                                      ],
                                    ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }


}
