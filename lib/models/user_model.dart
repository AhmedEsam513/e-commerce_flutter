class UserModel {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String createdAt;
  List<String>? favorites;
  String? profilePhotoUrl;
  bool? isEmailVerified;

  //final String password;

  UserModel({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
    this.favorites,
    this.profilePhotoUrl,
    this.isEmailVerified = false,
    //required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "createdAt": createdAt,
      "favorites": favorites,
      "profilePhotoUrl": profilePhotoUrl,
      "isEmailVerified":isEmailVerified
    };
  }

  static UserModel fromMap(Map<String, dynamic> data,String userId) {
    return UserModel(
      userID: data["userID"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      createdAt: data["createdAt"],
      favorites: List<String>.from(data["favorites"]?? []),
      profilePhotoUrl: data["profilePhotoUrl"],
      isEmailVerified: data["isEmailVerified"]
    );
  }
}
