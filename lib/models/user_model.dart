class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String imageUrl;
  final int age;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
    required this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'age': age,
    };
  }
}
