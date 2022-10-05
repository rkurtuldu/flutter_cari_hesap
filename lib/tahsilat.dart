import 'package:cari/dataservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Tahsilat extends ConsumerStatefulWidget {
  const Tahsilat({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _TahsilatState();
}

class _TahsilatState extends ConsumerState<Tahsilat> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late String ay;
  late String yil;
  List<String> carilist = [];
  final Map<String, dynamic> girilen = {};
  final _formkey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  Future<void> carialma() async {
    final hes = FirebaseFirestore.instance
        .collection("kullanıcılar")
        .doc(uid!)
        .collection("cariler")
        .orderBy("cariadi");
    final resp = await hes.get();
    final list = resp.docs;
    for (int i = 0; i < list.length; i++) {
      carilist.add(list[i]["cariadi"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "tr_TR";
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Tahsilat"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                      future: carialma(),
                      builder: (context, snapshot) {
                        return DropdownButtonFormField<String>(
                          value: girilen["cari"],
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person), label: Text("Cari")),
                          items: carilist.map((val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (value) {
                            girilen["cari"] = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Lütfen Cari Seçin";
                            }
                            return null;
                          },
                        );
                      }),
                  const SizedBox(
                    height: 25,
                    width: 50,
                  ),
                  TextFormField(
                    controller: dateinput,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), labelText: "Tarih"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        var saat = DateFormat("HH.mm").format(DateTime.now());
                        ay = DateFormat("MMMM").format(pickedDate);
                        yil = DateFormat("yyyy").format(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd-$saat').format(pickedDate);
                        dateinput.text = formattedDate;
                      }
                    },
                    onSaved: (formattedDate) {
                      girilen["tarih"] = formattedDate;
                      girilen["ay"] = ay;
                      girilen["yil"] = yil;
                    },
                    validator: (formattedDate) {
                      if (formattedDate?.isNotEmpty != true) {
                        return "Tarih Seçmelisiniz";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                    width: 50,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.edit_note), label: Text("Açıklama")),
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return "Açıklama Girmelisiniz";
                      }
                      return null;
                    },
                    onSaved: (newvalue) {
                      girilen["aciklama"] = newvalue;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                    width: 50,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.currency_lira), label: Text("Tutar")),
                    validator: (value) {
                      if (value == null || value.isNotEmpty != true) {
                        return "Tutarı Girmelisiniz";
                      }
                      if (double.tryParse(value) == null) {
                        return "Tutarı Rakamla Girmelisiniz";
                      }
                      return null;
                    },
                    onSaved: (newvalue) {
                      girilen["tahsilattutari"] = double.parse(newvalue!);
                    },
                    keyboardType: TextInputType.number,
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
                        final formState = _formkey.currentState;
                        if (formState == null) return;
                        if (formState.validate() == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Hata! Bilgileri Kontrol Edin")));
                        }
                        if (formState.validate() == true) {
                          formState.save();

                          final cari = girilen["cari"];

                          final hes = FirebaseFirestore.instance
                              .collection("kullanıcılar")
                              .doc(uid!)
                              .collection("hesaplar")
                              .where("cari", isEqualTo: cari)
                              .orderBy("tarih", descending: true)
                              .limit(1);
                          final resp = await hes.get();
                          final list = resp.docs;
                          double gelenbakiye;
                          double gidenbakiye;
                          double girilentahsilat;
                          if (list.isEmpty) {
                            gelenbakiye = 0;
                          } else {
                            final son = list[0].data();
                            gelenbakiye = son["bakiye"];
                          }
                          girilentahsilat = girilen["tahsilattutari"];
                          gidenbakiye = (gelenbakiye - girilentahsilat);
                          girilen["satistutari"] = 0.0;
                          girilen["bakiye"] = gidenbakiye;
                          await Dataservice().hesapekle(Hesap.fromMap(girilen));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("İşlem Kaydedildi")));
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return const Tahsilat();
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
