import 'package:firebase_auth/firebase_auth.dart';
import 'package:telescope_mart/db/db_helper.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<bool> loginAdmin(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return DbHelper.isAdmin(credential.user!.uid);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
