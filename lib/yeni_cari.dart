import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dataservice.dart';

class Yenicari extends ConsumerWidget {
  const Yenicari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> carilist = [];
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final Map<String, dynamic> girilen = {};
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Yeni Cari"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onTap: () async {
                      final hes = FirebaseFirestore.instance
                          .collection("kullanıcılar")
                          .doc(uid)
                          .collection("cariler");
                      final resp = await hes.get();
                      final list = resp.docs;
                      for (int i = 0; i < list.length; i++) {
                        carilist.add(list[i]["cariadi"]);
                      }
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.corporate_fare),
                        label: Text("Cari Adı")),
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return "Cari Adı Girmelisiniz";
                      }
                      if (carilist.contains(value)) {
                        return "Bu Cari Adı Zaten Mevcut";
                      }
                      return null;
                    },
                    onSaved: (newvalue) {
                      girilen["cariadi"] = newvalue;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                    width: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person), label: Text("Yetkili Kişi")),
                    onSaved: (newvalue) {
                      girilen["cariyetkili"] = newvalue;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                    width: 50,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        label: Text("Telefon Numarası")),
                    onSaved: (newvalue) {
                      girilen["caritelefon"] = newvalue;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 35,
                    width: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.location_pin), label: Text("Adresi")),
                    onSaved: (newvalue) {
                      girilen["cariadres"] = newvalue;
                    },
                  ),
                  const SizedBox(
                    height: 35,
                    width: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        label: Text("E-Posta Adresi")),
                    onSaved: (newvalue) {
                      girilen["carieposta"] = newvalue;
                    },
                  ),
                  const SizedBox(
                    height: 35,
                    width: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.notes), label: Text("Notlar")),
                    onSaved: (newvalue) {
                      girilen["carinot"] = newvalue;
                    },
                  ),
                  const SizedBox(
                    height: 35,
                    width: 50,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final formState = formkey.currentState;
                        if (formState == null) return;
                        if (formState.validate() == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Hata! Bilgileri Kontrol Edin")));
                        }
                        if (formState.validate() == true) {
                          formState.save();

                          await Dataservice().cariekle(Cari.fromMap(girilen));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("İşlem Kaydedildi")));
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return const Yenicari();
                            },
                          ));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Kaydet"),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
