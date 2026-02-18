import 'due.dart';

class Accountability {
  String id;
  String dueDate;
  String? note;
  String dateSent;
  List<Due> dueList = [];

  void addDue(Due due) {
    dueList.add(due);
  }

  double get remainingAmount {
    return dueList.fold(0.0, (sum, due) => sum + (due.amountToPay - due.amountPayed));
  }

  double get totalAmountToPay {
    return dueList.fold(0.0, (sum, due) => sum + due.amountToPay);
  }

  double get totalAmountPayed {
    return dueList.fold(0.0, (sum, due) => sum + due.amountPayed);
  }

  Accountability({
    required this.id,
    required this.dueDate,
    required this.dateSent
  });
}