import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import '../services/pet_service.dart';
import 'add_pet_screen.dart';
import 'profile_screen.dart';

class UserLookupScreen extends StatefulWidget {
  @override
  _UserLookupScreenState createState() => _UserLookupScreenState();
}

class _UserLookupScreenState extends State<UserLookupScreen> {
  Map<String, dynamic>? userData;
  List<dynamic> pets = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        errorMessage = "Usuário não autenticado.";
        isLoading = false;
      });
      return;
    }

    final firebaseuid = user.uid;
    
    final data = await UserService().getProfileData(firebaseuid);
    final petData = await PetService().getPetData(firebaseuid);

    if (data != null) {
      setState(() {
        userData = data;
      });
    } else {
      setState(() {
        errorMessage = "Erro ao buscar usuário. Verifique o UID.";
      });
    }

    if (petData != null) {
      setState(() {
        pets = petData is List ? petData : [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Text(errorMessage, style: TextStyle(color: Colors.red))
                    : userData != null
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileField(
                                    label: "Nome", value: userData!['name']),
                                ProfileField(
                                    label: "Endereço",
                                    value: userData!['address']),
                                ProfileField(
                                    label: "CPF", value: userData!['cpf']),
                                SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ProfileScreen()),);
                                    },
                                    child: Text("Editar",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Pets Cadastrados',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AddPetScreen()),
                                        );
                                        fetchUserData(); // Recarrega os pets após voltar da tela de adicionar pet
                                      },

                                      child: Text("Adicionar Pet",
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                                pets.isEmpty
                                    ? Text("Nenhum pet cadastrado",
                                        style:
                                            TextStyle(color: Colors.white70))
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: pets.length,
                                          itemBuilder: (context, index) {
                                            final pet = pets[index];
                                            return Card(
                                              color: Colors.grey[900],
                                              margin:
                                                  EdgeInsets.symmetric(vertical: 10),
                                              child: ListTile(
                                                title: Text(pet['name'],
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                    "Raça: ${pet['raca']}, Idade: ${pet['idade']} anos",
                                                    style: TextStyle(
                                                        color: Colors.white70)),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Divider(color: Colors.white54),
        ],
      ),
    );
  }
}
