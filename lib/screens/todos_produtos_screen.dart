import 'package:flutter/material.dart';
import 'package:teste_petshop/services/product_serivce.dart';
import 'package:url_launcher/url_launcher.dart';

class TodosProdutosScreen extends StatefulWidget {
  const TodosProdutosScreen({super.key});

  @override
  State<TodosProdutosScreen> createState() => _TodosProdutosScreenState();
}

class _TodosProdutosScreenState extends State<TodosProdutosScreen> {
  final ProductService _productService = ProductService();
  late Future<List<dynamic>> _todosProdutos;

  @override
  void initState() {
    super.initState();
    _todosProdutos = _productService.findAll();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Todos os Produtos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _todosProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os produtos', style: TextStyle(color: Colors.white)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado', style: TextStyle(color: Colors.white)),
            );
          }

          final produtos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              final nome = produto['nome'] ?? '';
              final descricao = produto['descricao'] ?? '';
              final preco = produto['preco']?.toString() ?? '';
              final link = produto['link'] ?? '';

              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nome, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(descricao, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('R\$ $preco', style: const TextStyle(color: Colors.white, fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _launchUrl(link),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Comprar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
