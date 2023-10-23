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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["telefone"] = telefone;
    _data["nomeCompleto"] = nomeCompleto;
    _data["email"] = email;
    _data["empresa"] = empresa;
    _data["profile"] = profile;
    return _data;
  }
}
