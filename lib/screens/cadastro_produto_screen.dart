import 'package:flutter/material.dart';
import 'package:teste_petshop/services/product_serivce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_petshop/main.dart';

class CadastroProdutoScreen extends StatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _linkController = TextEditingController(); // Novo campo

  final ProductService _productService = ProductService();

  bool _isLoading = false;

  void _cadastrarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isLoading = true);

    final produto = {
      'nome': _nomeController.text.trim(),
      'descricao': _descricaoController.text.trim(),
      'preco': double.tryParse(_precoController.text.trim()) ?? 0.0,
      'link': _linkController.text.trim(), // Adiciona o link ao produto
      'userId': uid,
    };

    try {
      await _productService.createProduct(produto);
      Navigator.pop(context); // Volta pra tela anterior após cadastro
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar produto')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cadastrar Produto', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField(
                controller: _nomeController,
                label: 'Nome',
                icon: Icons.shopping_bag,
                validator: (value) => value!.isEmpty ? 'Digite o nome do produto' : null,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _descricaoController,
                label: 'Descrição',
                icon: Icons.description,
                validator: (value) => value!.isEmpty ? 'Digite uma descrição' : null,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _precoController,
                label: 'Preço',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Digite o preço' : null,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _linkController,
                label: 'Link para Compra',
                icon: Icons.link,
                keyboardType: TextInputType.url,
                validator: (value) => value!.isEmpty ? 'Digite o link de compra' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _cadastrarProduto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Cadastrar Produto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
