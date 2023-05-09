import 'package:flutter/material.dart';
import 'package:yazilim_proje/screens/chat_screen.dart';
import 'package:yazilim_proje/screens/registration_screen.dart';
import 'package:yazilim_proje/screens/signin_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Topkapi Chat Room',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: ChatScreen(),

        initialRoute: _auth.currentUser != null
            ? ChatScreen.screenRoute
            : WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
          SignInScreen.screenRoute: (context) => SignInScreen(),
          RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
          ChatScreen.screenRoute: (context) => ChatScreen(),
        });
  }
}
