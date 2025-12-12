import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/services.dart';
import 'manager_helper.dart';


class ManagerInputTenantDuePage extends StatefulWidget {
  const ManagerInputTenantDuePage({super.key});

  @override
  State<ManagerInputTenantDuePage> createState() => _ManagerInputTenantDuePageState();
}

class _ManagerInputTenantDuePageState extends State<ManagerInputTenantDuePage> {
  final newDueController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();
  bool newDueShowing = false;
  String? dueType;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateController.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }


  Future <void> fetchTenantInfo() async { //firebase fetch info from manager info

  }

  Future <void> tenantActions() async {

  }


  @override
  Widget build(BuildContext context) {
    final tenantID = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      //appBar: AppBar(title: Text("Add Tenant Due (id: $tenantID)")),
      body: Column(
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
              children: [
                Text("Get tenant name"),
                Text("Get room number and room type"),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Text("Dues"),
                        Text("Remaining Amount"),
                      ]
                    ),
                    TableRow(
                        children: [
                          Text("Rent"),
                          Text("3000"),
                        ]
                    ),
                    TableRow(
                        children: [
                          Text("Electricity"),
                          Text("800"),
                        ]
                    ),
                    TableRow(
                        children: [
                          Text("Water"),
                          Text("500"),
                        ]
                    ),
                    TableRow(
                      children: newDueShowing
                          ? [
                        TextField(
                          controller: newDueController,
                          decoration: InputDecoration(
                            hintText: "New due name...",
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => setState(() => newDueShowing = false),
                              icon: Icon(Icons.check),
                            ),
                            IconButton(
                              onPressed: () => setState(() => newDueShowing = false),
                              icon: Icon(Icons.close),
                            ),
                          ],
                        ),
                      ]
                          : [
                        ElevatedButton(
                          onPressed: () => setState(() => newDueShowing = true),
                          child: Text("Add New Charge"),
                        ),
                        SizedBox(),
                      ],
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
                        Text("4300"),
                      ]
                    ),
                  ],
                )
              ],
            ),
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
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("Due Type:"),
                        DropdownButton<String>(
                          value: dueType,
                          hint: Text("Select an option"),
                          isExpanded: true, // optional, makes it full width
                          items: [
                            "Rent",
                            "Electricity",
                            "Water",
                          ].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dueType = value!;
                            });
                          },
                        ),
                      ]
                    ),
                    TableRow(
                      children: [
                        Text("Amount:"),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: "Amount",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ]
                    ),
                    TableRow(
                      children: [
                        Text("Due Date:"),
                        TextField(
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Select Date",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () => pickDate(context),
                        )
                      ]
                    ),
                    TableRow(
                      children: [
                        Text("Note:"),
                        TextField(
                          controller: noteController,
                          maxLines: null,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "Note",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                            hintText: "Enter note or additional details…",
                          ),
                        )
                      ]
                    )
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Clear")
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Add")
                    )
                  ],
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}
