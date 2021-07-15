class SignUpModel {
  String email;
  String password;
  String repeatPassword;

  String firstname;
  String lastname;
  String phoneNumber;
  String dob;
  String address;

  String type ;

  SignUpModel({
    this.email,
    this.password,
    this.repeatPassword,
    this.firstname,
    this.lastname,
    this.phoneNumber,
    this.dob,
    this.address,
    this.type
  });
}
