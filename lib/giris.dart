import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'anasayfa.dart';
import 'google_signin.dart';
import 'kayit.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final formkey = GlobalKey<FormState>();
  bool isfirebaseinitialized = false;
  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isfirebaseinitialized
              ? Form(
                  key: formkey,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/logogiris.png', height: 50),
                          const Text("Cari Hesap Yönetimi",
                              style: TextStyle(
                                  color: Colors.black54,
                                  height: 1.3,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                  wordSpacing: 3)),
                          const SizedBox(
                            width: 20,
                            height: 50,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r" ")),
                            ],
                            validator: (value) {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);
                              if (value.isEmpty) {
                                return "Lütfen E-Posta Adresinizi Girin";
                              } else if (emailValid == false) {
                                return 'Lütfen Geçerli Bir E-Posta Adresi Girin';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text("E-Posta Adresi")),
                            onSaved: (value) {
                              email = value;
                            },
                          ),
                          const SizedBox(
                            width: 50,
                            height: 25,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Lütfen Parolanızı Girin";
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(label: Text("Parola")),
                            onSaved: (value) {
                              password = value;
                            },
                          ),
                          const SizedBox(
                            width: 50,
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                final formState = formkey.currentState;
                                if (formState == null) return;
                                if (formState.validate() == true) {
                                  formState.save();
                                }
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email!, password: password!);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Bu Kullanıcı Kayıtlı Değil")));
                                  } else if (e.code == 'wrong-password') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Parola Yanlış")));
                                  }
                                }
                                if (FirebaseAuth.instance.currentUser != null) {
                                  anasayfayagit();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                child: Text("Giriş Yap"),
                              )),
                          TextButton(
                              onPressed: () async {
                                final formState = formkey.currentState;
                                if (formState == null) return;
                                {
                                  formState.save();
                                }
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: email!);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Bu Kullanıcı Kayıtlı Değil")));
                                  } else if (e.code == 'invalid-email') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Geçerli Bir E-Posta Adresi Girin")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Şifre Sıfırlama E-Postası Gönderildi")));
                                  }
                                }
                              },
                              child: const Text("Şifremi Unuttum")),
                          const SizedBox(
                            width: 50,
                            height: 25,
                          ),
                          Row(
                            children: const [
                              Expanded(
                                  child: Divider(
                                thickness: 1,
                              )),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("veya"),
                              ),
                              Expanded(
                                  child: Divider(
                                thickness: 1,
                              )),
                            ],
                          ),
                          const SizedBox(
                            width: 50,
                            height: 25,
                          ),
                          SignInButton(
                              elevation: 5,
                              Buttons.Google,
                              text: "Google ile Giriş Yap",
                              onPressed: () async {
                            await signInWithGoogle();
                            anasayfayagit();
                          }),
                          const SizedBox(
                            width: 50,
                            height: 15,
                          ),
                          SignInButtonBuilder(
                              elevation: 5,
                              icon: Icons.edit_note,
                              backgroundColor: Colors.blue,
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const Kayit();
                                }));
                              },
                              text: "Kayıt Ol"),
                        ],
                      ),
                    ),
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isfirebaseinitialized = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      anasayfayagit();
    }
  }

  void anasayfayagit() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Anasayfa(),
      ),
    );
  }
}
