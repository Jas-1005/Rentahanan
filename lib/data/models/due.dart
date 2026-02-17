class Due {
  String id;
  String type;
  double amountPayed;
  double amountToPay;
  String status;

  @override
  String toString() {
    return 'Due(id: $id, type: $type, amountToPay: $amountToPay, amountPayed: $amountPayed, remaining: ${amountToPay - amountPayed}, status: $status)';
  }

  Due({
    required this.id,
    required this.type,
    required this.amountPayed,
    required this.amountToPay,
    required this.status
  });
}