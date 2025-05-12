import '../domain/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  @override
  Future<bool> login(String email, String password) async {
    print("Login com: $email"); 
    return true; 
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    print("Registrando: $name ($email)");
    return true; // Simula um registro bem-sucedido
  }

  @override
  Future<void> logout() async {
    print("Usuário deslogado.");
  }
}
