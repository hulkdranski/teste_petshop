import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teste_petshop/screens/criar_negocio_screen.dart';
import 'package:teste_petshop/screens/map_screen.dart';
import 'package:teste_petshop/screens/meu_negocio_screen.dart';
import 'package:teste_petshop/screens/todos_produtos_screen.dart';
import 'dart:convert';
import 'package:teste_petshop/screens/user_data_screen.dart';
import 'package:teste_petshop/screens/login_screen.dart';
import 'package:teste_petshop/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teste_petshop/main.dart'; // importa o RouteObserver

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _news = [];
  bool _isLoading = true;
  bool? _isseller;
  final String placeholderImage = "https://via.placeholder.com/400";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _refreshHome(); // roda ao entrar
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _refreshHome();
  }

  Future<void> _refreshHome() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchNews(),
      _loadUserData(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchNews() async {
    const String pet = 'pet';
    const String apiKey = "e28f78d7b1dc436f847e0551634b1fe3";
    const String url =
        "https://newsapi.org/v2/everything?q=$pet&apiKey=$apiKey&lang=ptbr";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _news = data["articles"].take(10).toList();
      }
    } catch (e) {
      print("Erro ao buscar notícias: $e");
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await UserService().getProfileData(user.uid);
      _isseller = profile?['isseller'] ?? false;
    }
  }

  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Não foi possível abrir o link: $url");
    }
  }

  Widget _buildNewsImage(String? url) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      child: Image.network(
        url ?? placeholderImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(placeholderImage,
              height: 200, fit: BoxFit.cover);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("PetShop News", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle, color: Colors.white, size: 32),
            onSelected: (value) async {
              if (value == "profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserLookupScreen()),
                );
              } else if (value == "logout") {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "profile",
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Perfil"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Sair"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 0, 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pets, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Bem-vindo!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("Início", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: Colors.white),
              title: Text("Chat Bot", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.store, color: Colors.white),
              title: Text("Lojas Parceiras", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.store, color: Colors.white),
              title: Text("Produtos", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodosProdutosScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.store, color: Colors.white),
              title: Text(
                _isseller == true ? "Meu Negócio" : "Criar meu negócio",
                style: TextStyle(color: Colors.white),
              ),
              
              onTap: () {
                Navigator.pop(context);
                if (_isseller == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MeuNegocioScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CriarNegocioScreen()),
                  );
                }
              },
            ),
            Divider(color: Colors.white54),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text("Sair", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _news.length,
              itemBuilder: (context, index) {
                final article = _news[index];
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNewsImage(article["urlToImage"]),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article["title"] ?? "Sem título",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              article["description"] ?? "Sem descrição disponível",
                              style: TextStyle(color: Colors.white70),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _openUrl(article["url"]),
                                child: Text("Leia mais",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
