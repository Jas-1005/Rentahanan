import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rentahanan/data/models/due.dart';
import 'package:rentahanan/data/models/tenant.dart';
import 'package:rentahanan/data/models/accountability.dart';


class ManagerInputTenantDuePage extends StatefulWidget {
  const ManagerInputTenantDuePage({super.key});

  @override
  State<ManagerInputTenantDuePage> createState() => _ManagerInputTenantDuePageState();
}

class _ManagerInputTenantDuePageState extends State<ManagerInputTenantDuePage> {
  Tenant tenant = Tenant(id: "", fullName: "", email: "", contactNumber: "");

  String? selectedType;
  Map<String, double> tenantDues = {};
  List<Accountability> accountabilities = [];

  Map<String, double> dueInputs = {};
  late double total = tenantDues.values.fold(0.0, (sum, v) => sum + v);

  List<String> dueTypes = ['Rent', 'Water', 'Internet', 'Custom'];
  TextEditingController newTypeController = TextEditingController();

  final newDueController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dueDateController = TextEditingController();

  bool addingNewDue = false;

  bool newDueShowing = false;
  String? dueType;

  String? addNewDueError;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dueDateController.text =
      "${picked.year}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
    }
  }



  Future <void> fetchTenantDues() async {
    tenantDues.clear();
    accountabilities.clear();

    final dueListSnapshot = await FirebaseFirestore.instance
        .collection('dueLists')
        .where('tenantId', isEqualTo: tenant.id)
        .get();

    for (var dueListDoc in dueListSnapshot.docs) {
      String dueListId = dueListDoc.id;

      Timestamp dueDateTS = dueListDoc['dueDate'] as Timestamp;
      DateTime dueDateDT = dueDateTS.toDate();
      String dueDate = "${dueDateDT.year}-${dueDateDT.month.toString().padLeft(2,'0')}-${dueDateDT.day.toString().padLeft(2,'0')}";

      Timestamp dateSentTS = dueListDoc['createdAt'] as Timestamp;
      DateTime dateSentDT = dateSentTS.toDate();
      String dateSent = "${dateSentDT.year}-${dateSentDT.month.toString().padLeft(2,'0')}-${dateSentDT.day.toString().padLeft(2,'0')}";

      final dueDetailsSnapshot = await FirebaseFirestore.instance
          .collection('dueDetails')
          .where('dueListId', isEqualTo: dueListId)
          .get();

      Accountability accnt = Accountability(id: dueListId, dueDate: dueDate, dateSent: dateSent);
      for (var dueDetailsDoc in dueDetailsSnapshot.docs) {
        String dueDetailsId = dueDetailsDoc.id;
        String dueType = dueDetailsDoc['type'];
        double amountPayed = (dueDetailsDoc['amountPayed'] as num).toDouble();
        double amountToPay = (dueDetailsDoc['amountToPay'] as num).toDouble();
        String status = dueDetailsDoc['status'];

        double remaining = amountToPay - amountPayed;
        tenantDues[dueType] = (tenantDues[dueType] ?? 0.0) + remaining;

        accnt.addDue(Due(id: dueDetailsId, type: dueType, amountPayed: amountPayed, amountToPay: amountToPay, status: status));
      }
      accountabilities.add(accnt);
    }

    total = tenantDues.values.fold(0.0, (sum, v) => sum + v);
    setState(() {});
  }

  Future<void> submitNewTenantDues() async {
    final dueListDoc = await FirebaseFirestore.instance.collection('dueLists').add({
      'tenantId': tenant.id,
      'status': 'pending',
      'note': noteController.text.trim(),
      'dueDate': Timestamp.fromDate(
        DateTime.parse(dueDateController.text.trim()),
      ),
      'createdAt': FieldValue.serverTimestamp(),
    });

    final String dueListId = dueListDoc.id;
    final batch = FirebaseFirestore.instance.batch();

    for (var entry in dueInputs.entries) {
      final docRef = FirebaseFirestore.instance.collection('dueDetails').doc();

      batch.set(docRef, {
        'tenantId': tenant.id,
        'dueListId': dueListId,
        'type': entry.key,
        'amountToPay': entry.value,
        'amountPayed': 0.0,
        'status': 'pending',
      });
    }

    await batch.commit();
  }


  void addDueToList(){
    if (selectedType == null) {
      setState(() => addNewDueError = "Error: Missing due type input");
      return;
    }

    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0.0) {
      setState(() => addNewDueError = "Error: Invalid amount input");
      return;
    }

    String key = selectedType != "Custom"
        ? selectedType!
        : newTypeController.text.trim();

    if (key.isEmpty) {
      setState(() => addNewDueError = "Error: Missing custom due type");
      return;
    }

    dueInputs[key] = amount;

    resetAddDueFields();
  }

  void resetAddDueFields(){
    amountController.clear();
    newTypeController.clear();
    setState(() {
      addNewDueError = null;
      selectedType = null;
      addingNewDue = false;
    });
  }

  void resetAllFields(){
    noteController.clear();
    dueDateController.clear();
    dueInputs.clear();
    resetAddDueFields();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tenant = ModalRoute.of(context)!.settings.arguments as Tenant;
    fetchTenantDues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tenant Due")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  )
              ),
              child: Column(
                spacing: 20,
                children: [
                  Column(
                    children: [
                      Text(tenant.fullName),
                      Text("${tenant.roomName} : ${tenant.roomType}"),
                    ],
                  ),
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Text("Dues", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Remaining Amount", style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                      ),
                      if (tenantDues.isEmpty)
                        TableRow(
                          children: [
                            Text("No dues"),
                            Text("-"),
                          ],
                        ),

                      if (tenantDues.isNotEmpty)
                        ...tenantDues.entries.map((due) => TableRow(
                          children: [
                            Text(due.key),
                            Text("₱${due.value.toStringAsFixed(2)}"),
                          ],
                        )
                      ),
                      TableRow(
                        children: [
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            height: 5
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            height: 5
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text("Total"),
                          Text("₱${total.toStringAsFixed(2)}"),
                        ]
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // action here
                    },
                    child: Text(
                      'Show Breakdown',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 300, // adjust height as needed
              child: buildDueBreakdownCarousel(accountabilities),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  )
              ),
              child: Column(
                children: [
                  Text("Add New Due"),
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Text("Due Type", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ...(
                        dueInputs.isNotEmpty
                            ? dueInputs.entries.map((due) => TableRow(
                          children: [
                            Text(due.key),
                            Text("₱${due.value.toStringAsFixed(2)}"),
                          ],
                        ))
                            : [
                          TableRow(
                            children: [
                              Text("No dues"),
                              Text("-"),
                            ],
                          ),
                        ]
                      ),
                    ],
                  ),

                  addingNewDue
                      ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButton<String>(
                                  value: selectedType,
                                  hint: Text('Select due type'),
                                  items: dueTypes
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedType = value;
                                    });
                                  },
                                ),
                                if (selectedType == 'Custom')
                                  SizedBox(
                                    child: TextField(
                                      controller: newTypeController,
                                      decoration:
                                      InputDecoration(hintText: 'Enter new due type'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: "Amount",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (addNewDueError != null) Text(addNewDueError!, style: TextStyle(color: Colors.red),),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => addDueToList(),
                            icon: Icon(Icons.check)
                          ),
                          IconButton(
                            onPressed: () => resetAddDueFields(),
                            icon: Icon(Icons.close)
                          )
                        ],
                      )
                    ],
                  )
                      : ElevatedButton(
                    onPressed: () => setState(() => addingNewDue = true),
                    child: Text("Add New Due"),
                  ),
                  Column(
                    children: [
                      Text("Due Date:"),
                      TextField(
                        controller: dueDateController,
                        decoration: InputDecoration(
                          hintText: "Enter due date",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () => pickDate(context),
                            icon: Icon(Icons.calendar_today)
                          )
                        ),
                      ),
                      Text("Note:"),
                      TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: "Enter note",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => resetAllFields(),
                        child: Text("Clear"),
                      ),
                      ElevatedButton(
                        onPressed: () async {

                          await submitNewTenantDues();
                          resetAllFields();
                          fetchTenantDues();
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  )

                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDueBreakdownCarousel(List<Accountability> accountList) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        final account = accountList[index];
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.brown.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                Text(
                  "Date Sent: ${account.dateSent}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Table(
                  children: [
                    TableRow(
                        children: [
                          Text("Dues", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                    ),
                    if (account.dueList.isEmpty)
                      TableRow(
                        children: [
                          Text("No dues"),
                          Text("-"),
                        ],
                      ),

                    if (account.dueList.isNotEmpty)
                      ...account.dueList.map((due) => TableRow(
                        children: [
                          Text(due.type),
                          Text("₱${due.amountToPay.toStringAsFixed(2)}"),
                        ],
                      )
                      ),
                    TableRow(
                        children: [
                          Container(height: 1, color: Colors.black),
                          Container(height: 1, color: Colors.black),
                        ]
                    ),
                    TableRow(
                      children: [
                        Text("Total Amount to Pay"),
                        Text("₱${account.totalAmountToPay.toStringAsFixed(2)}"),
                      ]
                    ),
                    TableRow(
                        children: [
                          Text("Total Amount Payed"),
                          Text("₱${account.totalAmountPayed.toStringAsFixed(2)}"),
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(height: 1, color: Colors.black),
                          Container(height: 1, color: Colors.black),
                        ]
                    ),
                    TableRow(
                        children: [
                          Text("Remaining Amount"),
                          Text("₱${account.remainingAmount.toStringAsFixed(2)}"),
                        ]
                    ),
                  ],
                ),
                Text(
                  "Due Date: ${account.dueDate}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (account.note != null) Text("Note: ${account.note}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
