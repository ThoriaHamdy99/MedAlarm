import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:med_alarm/providers/firebase_provider.dart';
import 'package:med_alarm/screens/home_screen.dart';
import 'package:med_alarm/utilities/sql_helper.dart';
import 'package:med_alarm/config/ColorConstants.dart';
import 'package:med_alarm/config/language.dart';
import 'package:med_alarm/custom_widgets/logging_widgets/login_fresh_loading.dart';

class LoginFreshUserAndPassword extends StatefulWidget {
  static const id = 'SIGN_UP_SCREEN';
  final Color backgroundColor;
  final String logo;
  final Color textColor;

  final bool isFooter;
  final Widget widgetFooter;

  final bool isResetPassword;
  final Widget widgetResetPassword;

  final bool isSignUp;
  final Widget signUp;

  final Function callLogin;

  final LoginFreshWords loginFreshWords;

  LoginFreshUserAndPassword(
      {@required this.callLogin,
      this.backgroundColor,
      this.loginFreshWords,
      this.logo,
      this.isFooter,
      this.widgetFooter,
      this.isResetPassword,
      this.widgetResetPassword,
      this.isSignUp,
      this.signUp,
      this.textColor});

  @override
  _LoginFreshUserAndPasswordState createState() =>
      _LoginFreshUserAndPasswordState();
}

class _LoginFreshUserAndPasswordState extends State<LoginFreshUserAndPassword> {
  TextEditingController _textEditingControllerPassword =
      TextEditingController();
  TextEditingController _textEditingControllerUser = TextEditingController();

  String typo = "";

  bool isNoVisiblePassword = true;

  bool isRequest = false;

  final focus = FocusNode();

  final bool isLoginRequest = false;

  LoginFreshWords loginFreshWords;

  @override
  Widget build(BuildContext context) {
    loginFreshWords = (widget.loginFreshWords == null)
        ? LoginFreshWords()
        : widget.loginFreshWords;
    double headerSize = MediaQuery.of(context).size.height * 0.3
        - MediaQuery.of(context).padding.top;
    return Scaffold(
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: MediaQuery.of(context).padding.top,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'hero-login1',
                              child: Container(
                                height: headerSize / 3,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      './assets/logo_MED_ALARM.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Hero(
                          tag: 'hero-login',
                          child: Container(
                            width: headerSize * 2 / 3,
                            height: headerSize * 2 / 3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  './assets/logo.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: Color(0xFFF3F3F5),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
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
        SizedBox(
          height: 0,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                      controller: this._textEditingControllerUser,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: widget.textColor ?? Color(0xFF0F2E48),
                          fontSize: 14),
                      autofocus: false,
                      onSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/icon_user.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: widget.backgroundColor ??
                                      ColorConstants.PrimaryColor)),
                          hintText: this.loginFreshWords.hintLoginUser)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: TextField(
                      focusNode: focus,
                      controller: this._textEditingControllerPassword,
                      obscureText: this.isNoVisiblePassword,
                      style: TextStyle(
                          color: widget.textColor ?? Color(0xFF0F2E48),
                          fontSize: 14),
                      onSubmitted: (value) {
                        widget.callLogin(
                            context,
                            setIsRequest,
                            this._textEditingControllerUser.text,
                            this._textEditingControllerPassword.text);
                      },
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/icon_password.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
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
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          filled: true,
                          fillColor: Color(0xFFF3F3F5),
                          focusColor: Color(0xFFF3F3F5),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Color(0xFFAAB5C3))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: widget.backgroundColor ??
                                      ColorConstants.PrimaryColor)),
                          hintText: this.loginFreshWords.hintLoginPassword)),
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
                        onTap: () async {
                          widget.callLogin(
                              context,
                              setIsRequest,
                              this._textEditingControllerUser.text,
                              this._textEditingControllerPassword.text);
                          try {
                            await FirebaseProvider.instance.auth
                                .signInWithEmailAndPassword(
                                    email: this
                                        ._textEditingControllerUser
                                        .text
                                        .trim(),
                                    password: this
                                        ._textEditingControllerPassword
                                        .text
                                        .trim()).timeout(Duration(seconds: 5));

                            await FirebaseProvider.instance.getLoggedUserInfo();
                            await FirebaseProvider.instance.registerDeviceToken();
                            await SQLHelper.getInstant().insertUser();

                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                          } on Auth.FirebaseAuthException catch (e) {
                            String message = 'error Occurred';
                            if (e.code == 'user-not-found') {
                              message = 'No user found for that email';
                            } else if (e.code == 'wrong-password') {
                              message = 'Wrong password provided for that user';
                            }else if (e.code == 'ERROR_INVALID_EMAIL') {
                              message = 'Your email address appears to be malformed';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              duration: Duration(seconds: 3),
                              backgroundColor: Theme.of(context).errorColor,
                            ));
                          } catch (e) {
                            print(this._textEditingControllerUser.text.trim());
                            print(e);
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Check your internet Connection'),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Theme
                                        .of(context)
                                        .errorColor,
                                  ));
                            } catch (e) {}
                          }

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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Center(
                                      child: Text(
                                    this.loginFreshWords.login,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ))),
                      ),
                (widget.isResetPassword == null ||
                        widget.isResetPassword == false)
                    ? SizedBox()
                    : GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 10, right: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color:
                                          widget.textColor ?? Color(0xFF0F2E48),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15)),
                              TextSpan(
                                  text: this.loginFreshWords.recoverPassword,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color:
                                          widget.textColor ?? Color(0xFF0F2E48),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ]),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => widget.widgetResetPassword,
                          ));
                        },
                      ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: this.loginFreshWords.notAccount + ' \n',
                            style: TextStyle(
                                color: widget.textColor ?? Color(0xFF0F2E48),
                                fontWeight: FontWeight.normal,
                                fontSize: 15)),
                        TextSpan(
                            text: this.loginFreshWords.signUp,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: widget.textColor ?? Color(0xFF0F2E48),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ]),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_buildContext) => widget.signUp));
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: (widget.isFooter == null || widget.isFooter == false)
              ? SizedBox()
              : widget.widgetFooter,
        ),
      ],
    );
  }

  void setIsRequest(bool isRequest) {
    setState(() {
      this.isRequest = isRequest;
    });
  }
}
