import 'package:cari/cari_guncelleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dataservice.dart';

class Carikart extends StatelessWidget {
  final String cariadi;
  const Carikart(this.cariadi, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    String? docid;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Cari Kart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("kullanıcılar")
                      .doc(uid!)
                      .collection("cariler")
                      .where("cariadi", isEqualTo: cariadi)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<Cari> carilist = snapshot.data!.docs
                          .map(
                            (doc) => Cari.fromMap(doc.data()),
                          )
                          .toList();
                      docid = snapshot.data!.docs[0].id;
                      return ListView.builder(
                          itemCount: carilist.length,
                          itemBuilder: (context, index) =>
                              Kart(carilist[index], docid!));
                    }
                    if (snapshot.hasError) {
                      return const Text("Hata");
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class Kart extends StatelessWidget {
  final String docid;
  final Cari cari;
  const Kart(
    this.cari,
    this.docid, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainAxisAlignment ortala;
    if (cari.caritelefon == "" || cari.cariyetkili == "") {
      ortala = MainAxisAlignment.center;
    } else {
      ortala = MainAxisAlignment.spaceEvenly;
    }
    return Column(
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      cari.cariadi,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: ortala,
                  children: [
                    SelectableText(
                      cari.cariyetkili,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      cari.caritelefon,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: SelectableText(cari.cariadres),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: SelectableText(cari.carieposta),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 20),
                child: SelectableText(cari.carinot),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
          width: 50,
        ),
        ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CariGuncelleme(cari, docid);
              }));
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Cari Bilgilerini Düzenle"),
            )),
      ],
    );
  }
}
