import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    User? user = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      print("Login bem-sucedido! ${user.email}");
      
      final userData = await UserService().getProfileData(user.uid);
      if (userData != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(blockExit: true)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha no login. Verifique seus dados!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Bem-vindo",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Entrar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(controller: _emailController, icon: Icons.email, hint: "Digite seu E-mail"),
            CustomTextField(controller: _passwordController, icon: Icons.lock, hint: "Digite sua senha", obscureText: true),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: _login,
                child: Text("Acessar", style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final bool blockExit;
  const ProfileScreen({super.key, this.blockExit = false});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await UserService().getProfileData(user.uid);
      if (userData != null) {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _cpfController.text = userData['cpf'] ?? '';
          _addressController.text = userData['address'] ?? '';
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final success = await UserService().createProfile(
          user.uid,
          _nameController.text,
          _cpfController.text,
          _addressController.text,
        );

        if (success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao atualizar o perfil!")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !widget.blockExit,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: widget.blockExit ? null : AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Perfil', style: TextStyle(color: Colors.white)),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(controller: _nameController, icon: Icons.person, hint: "Nome"),
                      CustomTextField(controller: _cpfController, icon: Icons.badge, hint: "CPF"),
                      CustomTextField(controller: _addressController, icon: Icons.home, hint: "Endereço"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text("Salvar"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
