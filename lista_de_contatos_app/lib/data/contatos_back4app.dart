import 'package:dio/dio.dart';
import 'package:lista_de_contatos_app/data/contatos_bd.dart';

class ContatosBack4App {
  static var dio = Dio();
  static var resposta = "";

  static salvarContato(contato) async {
    var headers = {
      'X-Parse-Application-Id': 'RUhjn3VXCKzPFF8BfBBv7YQSGIEAN8mbWvkJq76r',
      'X-Parse-REST-API-Key': 'eqWVj7O8awXpHZkdFsvq5EWgt0RuW9cwbjzSplEb',
      'Content-Type': 'application/json',
    };
    var response = await dio.post(
        "https://parseapi.back4app.com/parse/classes/contatos/",
        data: contato,
        options: Options(headers: headers));
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      resposta = "Contato salvo com Sucesso!";
    } else {
      resposta =
          "Erro ao salvar o contato. certifique-se de preencher todos os campos e tente novamente.";
    }
    //print(resposta);
  }

  Future<List<ContatosRepository>> obterContatos() async {
    var headers = {
      'X-Parse-Application-Id': 'RUhjn3VXCKzPFF8BfBBv7YQSGIEAN8mbWvkJq76r',
      'X-Parse-REST-API-Key': 'eqWVj7O8awXpHZkdFsvq5EWgt0RuW9cwbjzSplEb',
      'Content-Type': 'application/json',
    };
    var contatos = await dio.get(
        "https://parseapi.back4app.com/parse/classes/contatos/",
        options: Options(headers: headers));

    if (contatos.statusCode == 200) {
      List data = contatos.data['results'] as List;
      List<ContatosRepository> contatosList =
          data.map((item) => ContatosRepository.fromJson(item)).toList();
      return contatosList;
    } else {
      throw Exception("Falha ao obter contatos.");
    }
  }

  Future<int> quantidadeContato() async {
    var headers = {
      'X-Parse-Application-Id': 'RUhjn3VXCKzPFF8BfBBv7YQSGIEAN8mbWvkJq76r',
      'X-Parse-REST-API-Key': 'eqWVj7O8awXpHZkdFsvq5EWgt0RuW9cwbjzSplEb',
      'Content-Type': 'application/json',
    };
    var response = await dio.get(
      "https://parseapi.back4app.com/parse/classes/contatos/",
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      // Verifique se a resposta contém informações sobre a quantidade de objetos
      if (response.data.containsKey('count')) {
        int totalObjetos = response.data['count'];
        return totalObjetos;
      }
    }
    return 0;
  }

  Future<bool> deletarContato(String telefone) async {
    Dio dio = Dio();
    var headers = {
      'X-Parse-Application-Id': 'RUhjn3VXCKzPFF8BfBBv7YQSGIEAN8mbWvkJq76r',
      'X-Parse-REST-API-Key': 'eqWVj7O8awXpHZkdFsvq5EWgt0RuW9cwbjzSplEb',
      'Content-Type': 'application/json',
    };
    String className = 'contatos'; // Substitua pelo nome da classe

    // Passo 1: Consulta para obter o objectId do objeto com base no CEP
    try {
      Response response = await dio.get(
        'https://parseapi.back4app.com/classes/$className?where={"telefone":"$telefone"}&limit=1',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<dynamic> results = response.data['results'];
        if (results.isNotEmpty) {
          String objectId = results[0]['objectId'];

          // Passo 2: Excluir o objeto com base no objectId
          Response deleteResponse = await dio.delete(
            'https://parseapi.back4app.com/classes/$className/$objectId',
            options: Options(headers: headers),
          );
          if (deleteResponse.statusCode == 200) {
            return true; // Exclusão bem-sucedida
          }
        }
      }
    } catch (e) {
      // print('Erro na solicitação: $e');
    }

    return false; // Falha na exclusão
  }
}
