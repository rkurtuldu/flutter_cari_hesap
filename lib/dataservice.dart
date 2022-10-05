import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Hesap {
  String cari;
  String tarih;
  String aciklama;
  double satistutari;
  double tahsilattutari;
  double bakiye;
  String ay;
  String yil;

  Hesap(this.cari, this.tarih, this.aciklama, this.satistutari,
      this.tahsilattutari, this.bakiye, this.ay, this.yil);
  Hesap.fromMap(Map<String, dynamic> m)
      : this(
          m["cari"],
          m["tarih"],
          m["aciklama"],
          m["satistutari"],
          m["tahsilattutari"],
          m["bakiye"],
          m["ay"],
          m["yil"],
        );
  Map<String, dynamic> toMap() {
    return {
      "cari": cari,
      "tarih": tarih,
      "aciklama": aciklama,
      "satistutari": satistutari,
      "tahsilattutari": tahsilattutari,
      "bakiye": bakiye,
      "ay": ay,
      "yil": yil,
    };
  }
}

class Cari {
  String cariadi;
  String cariyetkili;
  String caritelefon;
  String cariadres;
  String carieposta;
  String carinot;

  Cari(this.cariadi, this.cariyetkili, this.caritelefon, this.cariadres,
      this.carieposta, this.carinot);
  Cari.fromMap(Map<String, dynamic> c)
      : this(
          c["cariadi"],
          c["cariyetkili"],
          c["caritelefon"],
          c["cariadres"],
          c["carieposta"],
          c["carinot"],
        );
  Map<String, dynamic> toMap() {
    return {
      "cariadi": cariadi,
      "cariyetkili": cariyetkili,
      "caritelefon": caritelefon,
      "cariadres": cariadres,
      "carieposta": carieposta,
      "carinot": carinot,
    };
  }
}

class Dataservice extends ChangeNotifier {
  Future<List<Hesap>> hesaplistesi() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("kullanıcılar")
        .doc(uid!)
        .collection("hesaplar")
        .orderBy("tarih")
        .get();
    return snapshot.docs.map((e) => Hesap.fromMap(e.data())).toList();
  }

  Future<List<Cari>> carilistesi() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("kullanıcılar")
        .doc(uid!)
        .collection("cariler")
        .orderBy("cariadi")
        .get();
    return snapshot.docs.map((e) => Cari.fromMap(e.data())).toList();
  }

  Future<void> hesapekle(Hesap hesap) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("kullanıcılar")
        .doc(uid!)
        .collection("hesaplar")
        .add(hesap.toMap());
    notifyListeners();
  }

  Future<void> cariekle(Cari cari) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("kullanıcılar")
        .doc(uid!)
        .collection("cariler")
        .add(cari.toMap());
  }
}

final dataProvider = ChangeNotifierProvider((ref) {
  return Dataservice();
});

final hesaplistesiProvider = FutureProvider((ref) {
  return ref.watch(dataProvider).hesaplistesi();
});

final carilistesiProvider = FutureProvider((ref) {
  return ref.watch(dataProvider).carilistesi();
});
