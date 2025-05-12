import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_petshop/screens/home_screen.dart';
import 'package:teste_petshop/screens/cadastro_produto_screen.dart';
import 'package:teste_petshop/main.dart';
import 'package:teste_petshop/screens/todos_produtos_screen.dart';
import 'package:teste_petshop/services/product_serivce.dart';


class MeuNegocioScreen extends StatefulWidget {
  const MeuNegocioScreen({super.key});

  @override
  State<MeuNegocioScreen> createState() => _MeuNegocioScreenState();
}

class _MeuNegocioScreenState extends State<MeuNegocioScreen> with RouteAware {
  final ProductService _productService = ProductService();
  late Future<List<dynamic>> _produtos;

  void carregarProdutos() {
    final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
    if (firebaseUid != null) {
      setState(() {
        _produtos = _productService.getProductsByUser(firebaseUid);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Meu Negócio', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _produtos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar produtos', style: TextStyle(color: Colors.white)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum produto cadastrado', style: TextStyle(color: Colors.white)),
            );
          }

          final produtos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  title: Text(produto['nome'] ?? '', style: const TextStyle(color: Colors.white)),
                  subtitle: Text(produto['descricao'] ?? '', style: const TextStyle(color: Colors.white70)),
                  trailing: Text('R\$ ${produto['preco']}', style: const TextStyle(color: Colors.white)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroProdutoScreen()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
