class ContatosRepository {
  String? telefone;
  String? nomeCompleto;
  String? email;
  String? empresa;
  String? profile;

  ContatosRepository({
    this.telefone,
    this.nomeCompleto,
    this.email,
    this.empresa,
    this.profile,
  });

  ContatosRepository.fromJson(Map<String, dynamic> json) {
    telefone = json["telefone"];
    nomeCompleto = json["nomeCompleto"];
    email = json["email"];
    empresa = json["empresa"];
    profile = json["profile"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["telefone"] = telefone;
    data["nomeCompleto"] = nomeCompleto;
    data["email"] = email;
    data["empresa"] = empresa;
    data["profile"] = profile;
    return data;
  }
}
