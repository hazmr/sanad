class PatientModel {
  final int id;
  final String name;
  final String? phoneNumber;
  final DateTime? createdAt;

  PatientModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.createdAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }
}
