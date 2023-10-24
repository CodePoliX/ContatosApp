import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:lista_de_contatos_app/contato_page.dart';

class SlashPage extends StatefulWidget {
  const SlashPage({super.key});

  @override
  State<SlashPage> createState() => _SlashPageState();
}

class _SlashPageState extends State<SlashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EasySplashScreen(
        logo: Image.network("https://logodix.com/logo/1825885.png"),
        title: const Text(
          "Contatos",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        showLoader: true,
        loadingText: const Text("Created by CodePoliX"),
        navigator: const ContatoPage(),
        durationInSeconds: 4,
      ),
    );
  }
}
