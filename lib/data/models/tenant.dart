class Tenant {
  String id;
  String fullName;
  String email;
  String contactNumber;
  String image = "assets/images/user1.png";
  String address = "Not stated";
  String roomName = "Unassigned";
  String roomType = "N/A";
  String paymentStatus = "N/A";

  Tenant({required this.id, required this.fullName, required this.email, required this.contactNumber});
}