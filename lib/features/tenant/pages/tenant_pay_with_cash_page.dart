import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TenantPayWithCashPage extends StatefulWidget {
  const TenantPayWithCashPage({super.key});

  @override
  State<TenantPayWithCashPage> createState() => _TenantPayWithCashPageState();
}

class _TenantPayWithCashPageState extends State<TenantPayWithCashPage> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  String paymentRemarks = '';
  String paymentStatus = 'pending';
  String paymentType = 'Cash';
  double paymentAmount = 0.0;
  // DateTime? paymentDateReported;

  Future<void> handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    await FirebaseFirestore.instance.collection('payments').add({
      'payerId': userId,
      'type': paymentType,
      'amount': paymentAmount,
      'status': paymentStatus,
      // 'dateReported': paymentDate,
      'remarks': paymentRemarks,
      'datePaid': FieldValue.serverTimestamp(),
    });
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Payment'),
          content: const Text('Are you sure you want to submit this payment?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLandladyNotifiedDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'The landlady has been notified. Check your inbox for confirmation.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _pickDateOfPayment() async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //   // if (pickedDate != null) {
  //   //   setState(() {
  //   //     paymentDate = pickedDate;
  //   //   });
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay via Cash')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // // Payment Date
                // TextFormField(
                //   readOnly: true,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Payment Date',
                //     suffixIcon: Icon(Icons.calendar_month),
                //   ),
                //   onTap: _pickDateOfPayment,
                //   validator: (_) {
                //     if (paymentDate == null) return 'Please select a date';
                //     return null;
                //   },
                //   controller: TextEditingController(
                //     text: paymentDate == null ? '' : formatter.format(paymentDate!),
                //   ),
                // ),
                // const SizedBox(height: 20),

                // Payment Amount
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter payment amount';
                    if (double.tryParse(value) == null) return 'Invalid amount';
                    return null;
                  },
                  onSaved: (value) => paymentAmount = double.parse(value!),
                ),
                const SizedBox(height: 20),

                // Notes (optional)
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Notes (Optional)',
                  ),
                  onSaved: (value) => paymentRemarks = value ?? '',
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    bool? confirmed = await _showConfirmationDialog();
                    if (confirmed == true) {
                      await handlePayment();
                      _showLandladyNotifiedDialog();
                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('Notify Landlady'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
