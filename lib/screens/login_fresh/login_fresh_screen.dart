import 'package:flutter/material.dart';
import '../../models/sign_up_model.dart';
import 'package:med_alarm/service/type_login.dart';
import 'package:med_alarm/custom_widgets/logging_widgets/footer_login.dart';
import 'login_fresh.dart';
import 'login_fresh_reset_password_screen.dart';
import 'login_fresh_sign_up_screen.dart';
import 'login_user_password_screen.dart';
import '../home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuildLoginFresh extends StatelessWidget {
  static const id = 'LANDING_SCREEN';
  const BuildLoginFresh({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<LoginFreshTypeLoginModel> listLogin = [
      LoginFreshTypeLoginModel(
          callFunction: (BuildContext _buildContext) {
            // develop what they want the facebook to do when the user clicks
          },
          logo: TypeLogo.facebook),
      LoginFreshTypeLoginModel(
          callFunction: (BuildContext _buildContext) {
            // develop what they want the Google to do when the user clicks
          },
          logo: TypeLogo.google),
      LoginFreshTypeLoginModel(
          callFunction: (BuildContext _buildContext) {
            print("APPLE");
            // develop what they want the Apple to do when the user clicks
          },
          logo: TypeLogo.apple),
      LoginFreshTypeLoginModel(
          callFunction: (BuildContext _buildContext) {
            Navigator.of(_buildContext).push(MaterialPageRoute(
              builder: (_buildContext) => widgetLoginFreshUserAndPassword(),
            ));
          },
          logo: TypeLogo.userPassword),
    ];

    return Scaffold(
      body: LoginFresh(
        pathLogo: 'assets/logo.png',
        isExploreApp: true,
        functionExploreApp: () {

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen()));
          // develop what they want the ExploreApp to do when the user clicks
        },
        isFooter: true,
        widgetFooter: this.widgetFooter(),
        typeLoginModel: listLogin,
        isSignUp: true,
        widgetSignUp: this.widgetLoginFreshSignUp(),
      ),
    );
  }

  Widget widgetLoginFreshUserAndPassword() {
    return LoginFreshUserAndPassword(
      callLogin: (BuildContext _context, Function isRequest, String user,
          String password) {
        isRequest(true);

        Future.delayed(Duration(seconds: 5), () {
          // print('-------------- function call----------------');
          // print(user);
          // print(password);
          // print('--------------   end call   ----------------');
          try {
            isRequest(false);
            ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
              content: Text('Check your internet Connection'),
              duration: Duration(seconds: 3),
              backgroundColor: Theme.of(_context).errorColor,
            ));
          } catch (e) {}
        });
      },
      logo: './assets/MED ALARM.png',
      isFooter: true,
      widgetFooter: this.widgetFooter(),
      isResetPassword: true,
      widgetResetPassword: this.widgetResetPassword(),
      isSignUp: true,
      signUp: this.widgetLoginFreshSignUp(),
    );
  }

  Widget widgetResetPassword() {
    return LoginFreshResetPassword(
      logo: 'assets/MED ALARM.png',
      funResetPassword:
          (BuildContext _context, Function isRequest, String email) {
        isRequest(true);

        Future.delayed(Duration(seconds: 5), () async {
          // print('-------------- function call----------------');
          // print(email);
          final _auth = FirebaseAuth.instance;
          _auth.sendPasswordResetEmail(email: email).then((onVal) {
            Navigator.pop(_context, true);

          }).catchError((onError) {
            String message = 'error Occurred';

            if (onError.toString().contains("ERROR_USER_NOT_FOUND")) {
              message= "User Not Found" ;
            }


            ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(_context).errorColor,
            ));

            }
           );

          print('--------------   end call   ----------------');
          isRequest(false);
        });
      },
      isFooter: true,
      widgetFooter: this.widgetFooter(),
    );
  }

  Widget widgetFooter() {
    return LoginFreshFooter(
      logo: 'assets/logo_footer.png',
      text: 'Power by',
      funFooterLogin: () {
        // develop what they want the footer to do when the user clicks
      },
    );
  }

  Widget widgetLoginFreshSignUp() {
    return LoginFreshSignUp(
        isFooter: true,
        widgetFooter: this.widgetFooter(),
        logo: 'assets/MED ALARM.png',
        funSignUp: (BuildContext _context, Function isRequest,
            SignUpModel signUpModel) {
          isRequest(true);
          isRequest(false);
        });
  }
}
