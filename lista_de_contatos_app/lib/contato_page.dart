import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lista_de_contatos_app/cadastro_page.dart';
import 'package:lista_de_contatos_app/data/contatos_back4app.dart';
import 'package:lista_de_contatos_app/data/contatos_bd.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  Dio dio = Dio();
  var server = ContatosBack4App();
  List<ContatosRepository> contatos = [];

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  Future<void> carregarContatos() async {
    try {
      var listaContatos = await server.obterContatos();
      setState(() {
        contatos = listaContatos;
      });
    } catch (e) {
      // print("ERRO: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double halfScreenHeight = screenHeight / 2; // Metade da altura da tela

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: const Text("Contatos"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: server.quantidadeContato(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child:
                          Text('Erro ao carregar a lista: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      itemCount: contatos.length,
                      itemBuilder: (context, index) {
                        final contato = contatos[index];
                        ImageProvider profileImage;
                        if (contato.profile != null &&
                            contato.profile!.isNotEmpty) {
                          profileImage = FileImage(File(contato.profile!));
                        } else {
                          profileImage =
                              const AssetImage("lib/images/user.png");
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 5.0),
                          color: const Color.fromARGB(255, 14, 14, 14),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.grey[900],
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        CircleAvatar(
                                            backgroundColor: Colors.grey[600],
                                            radius: 70,
                                            backgroundImage: profileImage),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                "${contato.nomeCompleto}",
                                                style: const TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${contato.telefone}",
                                                style: const TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            contato.email != null &&
                                                    contato.email!.isNotEmpty
                                                ? Center(
                                                    child: Text(
                                                      "${contato.email}",
                                                      style: const TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 18),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {},
                                                    child: const Text(
                                                      "Adicionar email",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ), // Ou qualquer outro widget que você deseja exibir se o email for nulo ou vazio

                                            contato.empresa != null &&
                                                    contato.empresa!.isNotEmpty
                                                ? Center(
                                                    child: Text(
                                                      "${contato.empresa}",
                                                      style: const TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 18),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {},
                                                    child: const Text(
                                                      "Adicionar empresa",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  await server.deletarContato(
                                                      contato.telefone!);
                                                  carregarContatos();
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Excluir contato",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 17, 0),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[600],
                                backgroundImage: profileImage,
                              ),
                              title: Text(
                                "${contato.nomeCompleto}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Retorna algo, por exemplo, uma mensagem de que não há dados
                    return const Text("Nenhum contato disponível.");
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FloatingActionButton(
                  mini: false,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SizedBox(
                          height: halfScreenHeight +
                              200, // Ajuste a altura conforme necessário
                          child: const CadastroPage(),
                        );
                      },
                    ).then((value) {
                      if (value == true) {
                        carregarContatos();
                      }
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.userPlus,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
