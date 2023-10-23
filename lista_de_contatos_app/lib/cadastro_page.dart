import 'dart:io';
import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_de_contatos_app/data/contatos_back4app.dart';
import 'package:lista_de_contatos_app/data/contatos_bd.dart';
import 'package:path_provider/path_provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  var profile = "lib/images/user.png";
  var nomeController = TextEditingController();
  var sobrenomeController = TextEditingController();
  var empresaController = TextEditingController();
  var telefoneController = TextEditingController();
  var emailController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var contato;
  final ImagePicker picker = ImagePicker();
  XFile? _pickedFile;
  // ignore: unused_field
  CroppedFile? _croppedFile;
  // ignore: prefer_typing_uninitialized_variables
  var response;

  Future<void> saveImageToGallery() async {
    if (_pickedFile != null) {
      final result = await ImageGallerySaver.saveFile(_pickedFile!.path);
      if (result != null) {
      } else {
        response = 'Falha ao salvar a imagem na galeria.';
      }
    } else {
      response = 'A imagem ainda não foi recortada ou não está disponível.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            title: const Text("Novo Contato"),
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.xmark), // Ícone de cancelar
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon:
                    const FaIcon(FontAwesomeIcons.check), // Ícone de adicionar
                onPressed: () {
                  contato = ContatosRepository(
                      telefone: telefoneController.text,
                      nomeCompleto:
                          '${nomeController.text} ${sobrenomeController.text}',
                      email: emailController.text,
                      empresa: empresaController.text,
                      profile: _pickedFile != null ? _pickedFile!.path : "");
                  ContatosBack4App.salvarContato(contato);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.amber,
                          context: context,
                          isScrollControlled: true,
                          builder: (_) {
                            return Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Defina min para ajustar ao tamanho dos elementos
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    // Capture a photo.
                                    Navigator.pop(context);
                                    var aguardando = await picker.pickImage(
                                        source: ImageSource.camera);
                                    await getApplicationDocumentsDirectory();
                                    setState(() {
                                      _pickedFile = aguardando;
                                    });
                                    saveImageToGallery();
                                  },
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.camera,
                                          size: 24,
                                        ),
                                      ),
                                      Text(
                                        "Câmera",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                InkWell(
                                  onTap: () async {
                                    //acessando galeria
                                    Navigator.pop(context);
                                    var aguardando = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    await getApplicationDocumentsDirectory();
                                    setState(() {
                                      _pickedFile = aguardando;
                                    });
                                  },
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.image,
                                          size: 24,
                                        ),
                                      ),
                                      Text(
                                        "Galeria",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 150, // Largura do botão
                        height: 150, // Altura do botão
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _pickedFile != null
                                ? FileImage(File(_pickedFile!.path))
                                : AssetImage(profile) as ImageProvider<
                                    Object>, // Defina o tipo da imagem explicitamente
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ]),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.amber,
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return Column(
                            mainAxisSize: MainAxisSize
                                .min, // Defina min para ajustar ao tamanho dos elementos
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  var aguardando = await picker.pickImage(
                                      source: ImageSource.camera);
                                  await getApplicationDocumentsDirectory();
                                  setState(() {
                                    _pickedFile = aguardando;
                                  });
                                  saveImageToGallery();
                                },
                                child: const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.camera,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      "Câmera",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              InkWell(
                                onTap: () async {
                                  //acessando galeria
                                  Navigator.pop(context);
                                  var aguardando = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  await getApplicationDocumentsDirectory();
                                  setState(() {
                                    _pickedFile = aguardando;
                                  });
                                },
                                child: const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.image,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      "Galeria",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Adicionar foto",
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: nomeController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            hintText: "Nome",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Color.fromARGB(255, 128, 128, 128)),
                      ),
                    ),
                    Expanded(child: Container()),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: sobrenomeController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            hintText: "Sobrenome",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Color.fromARGB(255, 128, 128, 128)),
                      ),
                    ),
                    Expanded(child: Container()),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: empresaController,
                        decoration: const InputDecoration(
                            hintText: "Empresa",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Color.fromARGB(255, 128, 128, 128)),
                      ),
                    ),
                    Expanded(child: Container()),
                  ]),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: telefoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: "Telefone",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Color.fromARGB(255, 128, 128, 128)),
                      ),
                    ),
                    Expanded(child: Container()),
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    Expanded(child: Container()),
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Color.fromARGB(255, 128, 128, 128)),
                      ),
                    ),
                    Expanded(child: Container()),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
