import 'package:flutter/material.dart';
import 'package:teste_petshop/services/store_service.dart';

class CriarNegocioScreen extends StatefulWidget {
  const CriarNegocioScreen({super.key});

  @override
  State<CriarNegocioScreen> createState() => _CriarNegocioScreenState();
}

class _CriarNegocioScreenState extends State<CriarNegocioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _placeIdController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final storeService = StoreService();
      final success = await storeService.createStore(
        _placeIdController.text.trim(),
        _cnpjController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Negócio criado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, '/meu-negocio');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar o negócio')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Criar Meu Negócio', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _cnpjController,
                icon: Icons.badge,
                hint: "CNPJ",
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                controller: _placeIdController,
                icon: Icons.place,
                hint: "Google Place ID",
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: _submit,
                        child: const Text("Criar Negócio", style: TextStyle(color: Colors.black, fontSize: 18)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final TextInputType? keyboardType;

  const CustomTextField({super.key, required this.controller, required this.icon, required this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }
}
