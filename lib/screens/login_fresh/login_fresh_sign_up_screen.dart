import 'package:flutter/material.dart';
import 'package:med_alarm/models/user.dart';
import 'package:med_alarm/providers/user_provider.dart';
import '/providers/firebase_provider.dart';
import '/screens/home_screen.dart';
import '/utilities/sql_helper.dart';
import '/config/ColorConstants.dart';
import '/custom_widgets/logging_widgets/login_fresh_loading.dart';
import '/config/language.dart';
import '../../models/sign_up_model.dart';
import 'package:validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginFreshSignUp extends StatefulWidget {
  static const id = 'LOGIN_SCREEN';
  final Color backgroundColor;

  final Color textColor;

  final LoginFreshWords loginFreshWords;

  final Function funSignUp;

  final bool isFooter;

  final Widget widgetFooter;

  final String logo;

  LoginFreshSignUp(
      {@required this.funSignUp,
      @required this.logo,
      this.isFooter,
      this.widgetFooter,
      this.textColor,
      this.loginFreshWords,
      this.backgroundColor});

  @override
  _LoginFreshSignUpState createState() => _LoginFreshSignUpState();
}

class _LoginFreshSignUpState extends State<LoginFreshSignUp> {
  final _formKey = new GlobalKey<FormState>();

  int _radioSelected;

  SignUpModel signUpModel = SignUpModel();

  bool isRequest = false;

  bool isNoVisiblePassword = true;

  LoginFreshWords loginFreshWords;

  void _submitAuthForm(BuildContext ctx) async {
    try {
      print(this.signUpModel.username.trim());
      print(this.signUpModel.phoneNumber.trim());
      print(this.signUpModel.type.trim());
      print(this.signUpModel.dateOfBirth.trim());

      Auth.UserCredential auth = await FirebaseProvider.instance.auth
          .createUserWithEmailAndPassword(
              email: this.signUpModel.email.trim(),
              password: this.signUpModel.password.trim());

      String date = this.signUpModel.dateOfBirth.trim().replaceAll('/', '') + 'T';
      date += '000000';

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.user.uid)
          .set({
        'email': this.signUpModel.email.trim(),
        'username': this.signUpModel.username.trim(),
        'type': this.signUpModel.type.trim(),
        'firstname': 'fn',
        'lastname': 'ln',
        'profPicURL': 'pic',
        'phoneNumber': this.signUpModel.phoneNumber.trim(),
        'address': this.signUpModel.address.trim(),
        'dob': Timestamp.fromDate(DateTime.parse(date)),
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.user.uid)
          .collection('Contacts')
          .doc('_init')
          .set({});

      print('+++++++++++++++++++++++ From Sign Up +++++++++++++++++++++++');
      print(auth.user.uid);
      print(this.signUpModel.email.trim());
      print(this.signUpModel.username.trim());
      print(this.signUpModel.type.trim());
      print('fn');
      print('ln');
      print('pic');
      print(this.signUpModel.phoneNumber.trim());
      print(this.signUpModel.address.trim());
      print(Timestamp.fromDate(DateTime.parse(date)));
      print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

      UserProvider.instance.currentUser = User(
        uid: auth.user.uid,
        email: this.signUpModel.email.trim(),
        username: this.signUpModel.username.trim(),
        type: this.signUpModel.type.trim(),
        firstname: 'fn',
        lastname: 'ln',
        profPicURL: 'pic',
        phoneNumber: this.signUpModel.phoneNumber.trim(),
        address: this.signUpModel.address.trim(),
        dob: Timestamp.fromDate(DateTime.parse(date)),
      );

      // await FirebaseProvider.instance.getLoggedUserInfo();
      SQLHelper.getInstant().insertUser();

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen()));
    } on Auth.FirebaseAuthException catch (e) {
      String message = 'error Occurred';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (e) {
      print(this.signUpModel.email.trim());
      print(e);
    }

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       if (Users.patientUser) {
    //         return Patient();
    //       } else if (Users.doctorUser) {
    //         return Doctor();
    //       } else {
    //         return Admin();
    //       }
    //     }
    //     ,
    //   ),
    //);
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      print(signUpModel.email);
      _submitAuthForm(context);
    } else {
      print('form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    loginFreshWords = (widget.loginFreshWords == null)
        ? LoginFreshWords()
        : widget.loginFreshWords;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor:
              widget.backgroundColor ?? ColorConstants.PrimaryColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            this.loginFreshWords.signUp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  (ColorConstants.gradientColor1),
                  (ColorConstants.gradientColor2),
                ],
              )),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 3),
                        child: Hero(
                          tag: 'hero-login',
                          child: Image.asset(
                            widget.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: Color(0xFFF3F3F5),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                    topRight: const Radius.circular(50.0),
                  )),
              child: buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5, left: 20, right: 20, top: 20),
                      child: TextFormField(
                          validator: (value) {
                            if (!value.contains('@')) {
                              return 'Please enter a valid email!';
                            } else if (value.isEmpty) {
                              return 'Email field can\'t be empty!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            this.signUpModel.email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          autofocus: false,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText: this.loginFreshWords.hintLoginUser)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Username field can\'t be empty!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            this.signUpModel.username = value;
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          autofocus: false,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText: this.loginFreshWords.hintName)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Patient'),
                          Radio(
                            value: 1,
                            groupValue: _radioSelected,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              this.signUpModel.type = "Patient";
                              setState(() {
                                _radioSelected = value;
                              });
                            },
                          ),
                          Text('Doctor'),
                          Radio(
                            value: 2,
                            groupValue: _radioSelected,
                            activeColor: Colors.pink,
                            onChanged: (value) {
                              this.signUpModel.type = "Doctor";
                              setState(() {
                                _radioSelected = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                          validator: (value) {
                            if (!isNumeric(value)) {
                              return 'Please enter a valid phone number!';
                            } else if (value.isEmpty) {
                              return 'Phone field can\'t be empty!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            this.signUpModel.phoneNumber = value;
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          autofocus: false,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText: this.loginFreshWords.hintPhone)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                          validator: (value) {
                            if (!value.contains('/')) {
                              return 'Please enter a valid format!';
                            } else if (value.isEmpty) {
                              return 'Birth field can\'t be empty!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            this.signUpModel.dateOfBirth = value;
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          autofocus: false,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText: this.loginFreshWords.hintDateOfBirth)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Address field can\'t be empty!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            this.signUpModel.address = value;
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          autofocus: false,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText: this.loginFreshWords.hintAddress)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: TextFormField(
                          validator: (value) {
                            if (value.length < 7) {
                              return 'Minimum length of password is 7 characters!';
                            } else if (value.isEmpty) {
                              return 'Password field can\'t be empty!';
                            }
                            return null;
                          },
                          onChanged: (String value) {
                            this.signUpModel.password = value;
                          },
                          obscureText: this.isNoVisiblePassword,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (this.isNoVisiblePassword)
                                        this.isNoVisiblePassword = false;
                                      else
                                        this.isNoVisiblePassword = true;
                                    });
                                  },
                                  child: (this.isNoVisiblePassword)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "assets/icon_eye_close.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "assets/icon_eye_open.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                        )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText:
                                  this.loginFreshWords.hintLoginPassword)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: TextFormField(
                          validator: (value) {
                            if (value != this.signUpModel.password) {
                              return 'Repeated password doesn\'t match the original one!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            this.signUpModel.repeatPassword = value;
                          },
                          obscureText: this.isNoVisiblePassword,
                          style: TextStyle(
                              color: widget.textColor ?? Color(0xFF0F2E48),
                              fontSize: 14),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              filled: true,
                              fillColor: Color(0xFFF3F3F5),
                              focusColor: Color(0xFFF3F3F5),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAB5C3))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: widget.backgroundColor ??
                                          ColorConstants.PrimaryColor)),
                              hintText: this
                                  .loginFreshWords
                                  .hintSignUpRepeatPassword)),
                    )
                  ],
                ),
              ),
            ),
          ),
          (this.isRequest)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoadingLoginFresh(
                    textLoading: this.loginFreshWords.textLoading,
                    colorText: widget.textColor,
                    backgroundColor: widget.backgroundColor,
                    elevation: 0,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    widget.funSignUp(context, this.setIsRequest,
                        this.signUpModel, _submit());

                  },
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: widget.backgroundColor ??
                              ColorConstants.PrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                                child: Text(
                              this.loginFreshWords.signUp,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                          ))),
                ),
          (widget.isFooter == null || widget.isFooter == false)
              ? SizedBox()
              : widget.widgetFooter
        ]);
  }

  void setIsRequest(bool isRequest) {
    setState(() {
      this.isRequest = isRequest;
    });
  }
}
