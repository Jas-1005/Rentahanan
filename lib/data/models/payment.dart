class Payment {
  String id;
  DateTime date;
  String type;
  String status;
  double amount;
  String? note;

  Payment({required this.id, required this.date, required this.type, required this.status, required this.amount, this.note});
}