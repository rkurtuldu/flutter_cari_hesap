import 'package:cari/carikart.dart';
import 'package:cari/dataservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Bakiye extends ConsumerStatefulWidget {
  final String cariadi;
  const Bakiye(this.cariadi, {Key? key}) : super(key: key);

  @override
  _BakiyeState createState() => _BakiyeState();
}

class _BakiyeState extends ConsumerState<Bakiye> {
  bool siralama = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const artan = FontAwesomeIcons.sortAmountDown;
    const azalan = FontAwesomeIcons.sortAmountDownAlt;
    IconData icon = siralama ? azalan : artan;
    late double fontsize;
    String islemtipi;
    double islemtutari;
    late List<Hesap> hesaplist;
    Future<Uint8List> pdfolustur() async {
      final font = await rootBundle.load("assets/ARIAL.TTF");
      final ttf = pw.Font.ttf(font);
      final bold = await rootBundle.load("assets/ARIALBD.TTF");
      final bttf = pw.Font.ttf(bold);
      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData(
              defaultTextStyle: pw.TextStyle(font: bttf, fontSize: fontsize)),
          header: (pw.Context context) {
            return pw.Column(children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      width: 75,
                      child: pw.Text(" Tarih"))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      width: 60,
                      child: pw.Text(" İşlem"))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      width: 200,
                      child: pw.Text(" Açıklama"))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerRight,
                      width: 60,
                      child: pw.Text("Tutar "))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerRight,
                      width: 65,
                      child: pw.Text("Bakiye"))
                ]),
                pw.SizedBox(height: fontsize + fontsize),
              ]),
            ]);
          },
          build: (pw.Context context) {
            return [
              pw.ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    final tarih = hesaplist[index].tarih;
                    final listtarih = tarih.split("-");
                    final reverse = listtarih.reversed.toList();
                    final yenitarih = reverse.join("/");
                    final sontarih = yenitarih.substring(6, 16);
                    if (hesaplist[index].satistutari == 0) {
                      islemtipi = "Tahsilat";
                      islemtutari = hesaplist[index].tahsilattutari;
                    } else {
                      islemtipi = "Satış";
                      islemtutari = hesaplist[index].satistutari;
                    }
                    return pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: 75,
                                  child: pw.Text(sontarih,
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: 60,
                                  child: pw.Text(islemtipi,
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: 200,
                                  child: pw.Text(hesaplist[index].aciklama,
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: 60,
                                  child: pw.Text("$islemtutari",
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: 65,
                                  child: pw.Text("${hesaplist[index].bakiye}",
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                          ]),
                      pw.Divider(
                          thickness: 0.5,
                          color: PdfColors.grey400,
                          height: fontsize),
                    ]);
                  },
                  itemCount: hesaplist.length)
            ];
          }));
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
      return pdf.save();
    }

    Future<Uint8List> pdfpaylas() async {
      final font = await rootBundle.load("assets/ARIAL.TTF");
      final ttf = pw.Font.ttf(font);
      final bold = await rootBundle.load("assets/ARIALBD.TTF");
      final bttf = pw.Font.ttf(bold);
      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData(
              defaultTextStyle: pw.TextStyle(font: bttf, fontSize: fontsize)),
          header: (pw.Context context) {
            return pw.Column(children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      width: 75,
                      child: pw.Text(" Tarih"))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      width: 60,
                      child: pw.Text(" İşlem"))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      width: 200,
                      child: pw.Text(" Açıklama"))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerRight,
                      width: 60,
                      child: pw.Text("Tutar "))
                ]),
                pw.Column(children: [
                  pw.Container(
                      alignment: pw.Alignment.centerRight,
                      width: 65,
                      child: pw.Text("Bakiye"))
                ]),
                pw.SizedBox(height: fontsize + fontsize),
              ]),
            ]);
          },
          build: (pw.Context context) {
            return [
              pw.ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    final tarih = hesaplist[index].tarih;
                    final listtarih = tarih.split("-");
                    final reverse = listtarih.reversed.toList();
                    final yenitarih = reverse.join("/");
                    final sontarih = yenitarih.substring(6, 16);
                    if (hesaplist[index].satistutari == 0) {
                      islemtipi = "Tahsilat";
                      islemtutari = hesaplist[index].tahsilattutari;
                    } else {
                      islemtipi = "Satış";
                      islemtutari = hesaplist[index].satistutari;
                    }
                    return pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: 75,
                                  child: pw.Text(sontarih,
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: 60,
                                  child: pw.Text(islemtipi,
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerLeft,
                                  width: 200,
                                  child: pw.Text(hesaplist[index].aciklama,
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: 60,
                                  child: pw.Text("$islemtutari",
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                            pw.Column(children: [
                              pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  width: 65,
                                  child: pw.Text("${hesaplist[index].bakiye}",
                                      style: pw.TextStyle(font: ttf)))
                            ]),
                          ]),
                      pw.Divider(
                          thickness: 0.5,
                          color: PdfColors.grey400,
                          height: fontsize),
                    ]);
                  },
                  itemCount: hesaplist.length)
            ];
          }));
      await Printing.sharePdf(
          bytes: await pdf.save(), filename: 'Hesap_ekstresi.pdf');
      return pdf.save();
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Hesap Detayı"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                siralama ? siralama = false : siralama = true;
              });
            },
            icon: FaIcon(icon, size: 20),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 18),
                            child: Text(
                              "Yazı Tipi Boyutu Seçin",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  fontsize = 8;
                                  pdfpaylas();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 70,
                                          height: 112,
                                          child: const Text(
                                              "A4 formatında yazdırmak için uygun yazı tipi boyutu",
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                        Container(
                                          width: 120,
                                          height: 32,
                                          color: Colors.black54,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.print,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "  8 pt",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ]),
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  fontsize = 12;
                                  pdfpaylas();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 90,
                                          height: 112,
                                          child: const Text(
                                              "Telefon ekranında görüntülemek için uygun yazı tipi boyutu",
                                              style: TextStyle(fontSize: 14)),
                                        ),
                                        Container(
                                          width: 120,
                                          height: 32,
                                          color: Colors.black54,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.phone_android,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  " 12 pt",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ]),
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                      );
                    });
              },
              icon: const Icon(Icons.share)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 18),
                            child: Text(
                              "Yazı Tipi Boyutu Seçin",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  fontsize = 8;
                                  pdfolustur();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 70,
                                          height: 112,
                                          child: const Text(
                                              "A4 formatında yazdırmak için uygun yazı tipi boyutu",
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                        Container(
                                          width: 120,
                                          height: 32,
                                          color: Colors.black54,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.print,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "  8 pt",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ]),
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  fontsize = 12;
                                  pdfolustur();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 120,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 90,
                                          height: 112,
                                          child: const Text(
                                              "Telefon ekranında görüntülemek için uygun yazı tipi boyutu",
                                              style: TextStyle(fontSize: 14)),
                                        ),
                                        Container(
                                          width: 120,
                                          height: 32,
                                          color: Colors.black54,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.phone_android,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  " 12 pt",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ]),
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ]),
                      );
                    });
              },
              icon: const Icon(Icons.print)),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Carikart(widget.cariadi);
                }));
              },
              child: Card(
                elevation: 3,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.cariadi,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        )),
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
                  )
                ]),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("kullanıcılar")
                    .doc(uid!)
                    .collection("hesaplar")
                    .where("cari", isEqualTo: widget.cariadi)
                    .orderBy("tarih", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    hesaplist = snapshot.data!.docs
                        .map(
                          (doc) => Hesap.fromMap(doc.data()),
                        )
                        .toList();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: siralama,
                              itemCount: hesaplist.length,
                              itemBuilder: (context, index) =>
                                  Hesapsatiri(hesaplist[index])),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Hata");
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          )
        ],
      ),
    );
  }
}

class Hesapsatiri extends ConsumerWidget {
  final Hesap hesap;
  const Hesapsatiri(
    this.hesap, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarih = hesap.tarih;
    final listtarih = tarih.split("-");
    final reverse = listtarih.reversed.toList();
    final yenitarih = reverse.join("/");
    final saat = yenitarih.substring(0, 5);
    final sontarih = yenitarih.substring(6, 16);
    String islemtipi;
    double islemtutari;
    if (hesap.satistutari == 0) {
      islemtipi = "Tahsilat";
      islemtutari = hesap.tahsilattutari;
    } else {
      islemtipi = "Satış";
      islemtutari = hesap.satistutari;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "$sontarih $saat",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    islemtipi,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 3),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 120,
                      child: const Text("Açıklama",
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 80,
                      child: const Text("Tutar",
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 120,
                      child: const Text("İşlem Sonu Bakiye",
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 3, bottom: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 120,
                      child: Text(hesap.aciklama),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 80,
                      child: Text("$islemtutari ₺"),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 120,
                      child: Text("${hesap.bakiye} ₺"),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
