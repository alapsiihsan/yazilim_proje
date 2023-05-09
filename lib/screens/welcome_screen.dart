import 'package:flutter/material.dart';
import 'package:yazilim_proje/screens/registration_screen.dart';
import 'package:yazilim_proje/screens/signin_screen.dart';
import 'package:yazilim_proje/widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset('images/app_icon.png'),
                ),
                SizedBox(height: 30),
                Text(
                  'Topkapi Chat Room',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2e386b),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            MyButton(
              color: Color(0xff9c2727),
              title: 'Giriş Yap',
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.screenRoute);
              },
            ),
            MyButton(
              color: Color(0xff959393),
              title: 'Yeni Hesap Oluştur',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
              },
            )
          ],
        ),
      ),
    );
  }
}
