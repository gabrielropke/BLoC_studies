class Usuario {
  String? _idUser;
  String? _name;
  String? _lastname;
  String? _email;
  String? _password;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "lastname": lastname,
      "email": email,
      "lists": [],
      "login": "e-mail/senha"
    };

    return map;
  }

  String get idUser => _idUser!;

  set idUser(String value) {
    _idUser = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  String get lastname => _lastname!;

  set lastname(String value) {
    _lastname = value;
  }

  String get email => _email!;

  set email(String value) {
    _email = value;
  }

  String get password => _password!;

  set password(String value) {
    _password = value;
  }
}
