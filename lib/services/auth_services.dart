import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServices {
  Future<bool> logIn(String email, String password);

  Future<bool> signUp(String email, String password);

  User? getCurrentUser();

  Future<void> logOut();

  Future<void> deleteUser();
}

class AuthServicesImpl implements AuthServices {

  final _authServices = FirebaseAuth.instance;

  @override
  User? getCurrentUser() {
    final currentUser = _authServices.currentUser;

    return currentUser;
  }

  @override
  Future<bool> logIn(String email, String password) async {
    final userCredential = await _authServices.signInWithEmailAndPassword(
        email: email, password: password);

    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> signUp(String email, String password) async {
    final userCredential = await _authServices.createUserWithEmailAndPassword(
        email: email, password: password);

    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    await _authServices.signOut();
  }

  @override
  Future<void> deleteUser() async {
    await _authServices.currentUser!.delete();
  }
}
