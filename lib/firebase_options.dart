import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyDW2doTnXBnHXMmvMirbDznj_KzUV8Oe0M",
      authDomain: "saaspetshop.firebaseapp.com",
      projectId: "saaspetshop",
      storageBucket: "saaspetshop.firebasestorage.app",
      messagingSenderId: "939120623798",
      appId: "1:939120623798:web:40f297e0078151a530a617",
      measurementId: "G-50G56Z1HJJ", // Para web, pode deixar vazio no mobile
    );
  }
}
