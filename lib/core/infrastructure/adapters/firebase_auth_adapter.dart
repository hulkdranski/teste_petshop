import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/services/auth_service.dart';

class FirebaseAuthAdapter implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      print("Erro no login: $e");
      return false;
    }
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);


      return true;
    } catch (e) {
      print("Erro no registro: $e");
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
