class SignUpModel {
  String email;
  String password;
  String repeatPassword;

  String username;
  String phoneNumber;
  String dateOfBirth;
  String address;

  String type ;

  SignUpModel({
    this.email,
    this.password,
    this.repeatPassword,
    this.username,
    this.phoneNumber,
    this.dateOfBirth,
    this.address,
    this.type
  });
}
