
class HDUserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarUrl;
  final String college;
  final String? phone;
  final String? address;
  final String? dayOfBirth;
  final String status;


  HDUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarUrl,
    required this.college,
    this.phone,
    this.address,
    this.dayOfBirth,
    required this.status,
  });
}