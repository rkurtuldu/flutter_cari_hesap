import 'package:cari/dataservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bakiyedetay.dart';

class CariGoruntuleme extends ConsumerWidget {
  const CariGoruntuleme({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Cari Görüntüleme"),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(carilistesiProvider);
          },
          child: ref.watch(carilistesiProvider).when(
              data: (data) => ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        Carisatiri(data[index]),
                  ),
              error: (error, stackTrace) {
                return const Text("Hata Oluştu");
              },
              loading: () => const Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}

class Carisatiri extends ConsumerWidget {
  final Cari cari;
  const Carisatiri(
    this.cari, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bakiyecari = cari.cariadi;
    double? bakiye;

    Future<void> bakiyeal(String bakiyecari) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final hes = FirebaseFirestore.instance
          .collection("kullanıcılar")
          .doc(uid!)
          .collection("hesaplar")
          .where("cari", isEqualTo: bakiyecari)
          .orderBy("tarih", descending: true)
          .limit(1);
      final resp = await hes.get();
      final list = resp.docs;
      double gelenbakiye;
      if (list.isEmpty) {
        gelenbakiye = 0;
      } else {
        final son = list[0].data();
        gelenbakiye = son["bakiye"];
      }
      bakiye = gelenbakiye;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Bakiye(cari.cariadi);
          }));
        },
        child: Card(
          elevation: 2,
          child: Column(
            children: [
              FutureBuilder(
                  future: bakiyeal(bakiyecari),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 10, top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cari.cariadi,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "$bakiye ₺",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: const [
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
