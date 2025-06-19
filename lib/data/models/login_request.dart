class LoginRequest {
  String email;
  String password;
  LoginRequest({required this.email, required this.password});

  //Metodo para convertir a Json
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
