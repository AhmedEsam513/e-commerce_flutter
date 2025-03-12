class UserModel {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String createdAt;

  //final String password;

  UserModel({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
    //required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "createdAt": createdAt,
    };
  }

  static UserModel fromMap(Map<String, dynamic> data,String userId) {
    return UserModel(
      userID: data["userID"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      createdAt: data["createdAt"],
    );
  }
}
