import 'package:cari/dataservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CariGuncelleme extends StatelessWidget {
  final Cari cari;
  final String docid;
  const CariGuncelleme(this.cari, this.docid, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<void> cariguncelle(Cari cari) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection("kullanıcılar")
          .doc(uid!)
          .collection("cariler")
          .doc(docid)
          .set(cari.toMap());
    }

    final Map<String, dynamic> girilen = {};
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Cari Güncelleme"),
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
                    Row(
                      children: [
                        const Icon(Icons.corporate_fare),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          cari.cariadi,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                      width: 50,
                    ),
                    TextFormField(
                      initialValue: cari.cariyetkili,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("Yetkili Kişi")),
                      onSaved: (newvalue) {
                        girilen["cariyetkili"] = newvalue;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                      width: 50,
                    ),
                    TextFormField(
                      initialValue: cari.caritelefon,
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
                      initialValue: cari.cariadres,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.location_pin),
                          label: Text("Adresi")),
                      onSaved: (newvalue) {
                        girilen["cariadres"] = newvalue;
                      },
                    ),
                    const SizedBox(
                      height: 35,
                      width: 50,
                    ),
                    TextFormField(
                      initialValue: cari.carieposta,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.account_balance),
                          label: Text("Banka Hesabı")),
                      onSaved: (newvalue) {
                        girilen["carieposta"] = newvalue;
                      },
                    ),
                    const SizedBox(
                      height: 35,
                      width: 50,
                    ),
                    TextFormField(
                      initialValue: cari.carinot,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.notes), label: Text("Notlar")),
                      onSaved: (newvalue) {
                        girilen["carinot"] = newvalue;
                        girilen["cariadi"] = cari.cariadi;
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
                        if (formState.validate() == true) {
                          formState.save();

                          await cariguncelle(Cari.fromMap(girilen));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Cari Güncellendi")));
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Kaydet"),
                      ),
                    ),
                  ]),
            )),
      )),
    );
  }
}
