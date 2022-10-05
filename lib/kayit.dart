import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'giris.dart';

class Kayit extends StatelessWidget {
  const Kayit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? isim;
    String? pass;
    String? email;
    final formkey = GlobalKey<FormState>();
    TextEditingController password = TextEditingController();
    return Scaffold(
      body: Center(
        child: Form(
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
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "İsim Girin";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            label: Text("Şirket Adı veya Ad Soyad")),
                        onSaved: (value) {
                          isim = value;
                        },
                      ),
                      const SizedBox(
                        width: 50,
                        height: 25,
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
                        controller: password,
                        obscureText: true,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return "Lütfen En Az 6 Karakterle Parolanızı Girin";
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text("Parola")),
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
                          if (value != password.text) {
                            return "Parolanız Eşleşmiyor";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            label: Text("Parola Tekrarı")),
                        onSaved: (value) {
                          pass = value;
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
                                  .createUserWithEmailAndPassword(
                                email: email!,
                                password: pass!,
                              );
                              await FirebaseAuth.instance.currentUser
                                  ?.updateDisplayName(isim);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Şifreniz Çok Zayıf")));
                              } else if (e.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Bu E-Posta Adresi Zaten Kayıtlı")));
                              }
                            }
                            if (FirebaseAuth.instance.currentUser != null) {
                              await FirebaseAuth.instance.signOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content:
                                          Text("Kayıt İşlemi Gerçekleşti")));
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const Splash();
                              }));
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: Text("Kayıt Ol"),
                          )),
                    ],
                  ),
                ))),
      ),
    );
  }
}
