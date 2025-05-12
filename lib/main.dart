import 'package:flutter/material.dart';
import 'package:teste_petshop/screens/user_data_screen.dart';
import 'screens/login_screen.dart';
import 'screens/criar_negocio_screen.dart';
import 'screens/meu_negocio_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaaS Petshop',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
          routes: {
      '/login': (context) => LoginScreen(),
      '/userLookup': (context) => UserLookupScreen(),
      '/criar-negocio': (context) => const CriarNegocioScreen(),
      '/meu-negocio': (context) => const MeuNegocioScreen(),
    },
    );
  }
}