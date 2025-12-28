import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        TextEditingController,
        BuildContext,
        Widget,
        Text,
        InputDecoration,
        AppBar,
        ConnectionState,
        TextInputType,
        TextField,
        TextButton,
        Center,
        Column,
        FutureBuilder,
        Scaffold;
import 'package:sanman/firebase_options.dart' show DefaultFirebaseOptions;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),

        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'enter your email',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'enter your Password',
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          print(userCredential);
                        } on FirebaseException catch (e) {
                          if (e.code == 'weak-password') {
                            print('weak password');
                          } else if (e.code == ' email-already-in-use') {
                            print('email already in use');
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ),
                ],
              );
            default:
              return const Text('Loading....');
          }
        },
      ),
    );
  }
}
