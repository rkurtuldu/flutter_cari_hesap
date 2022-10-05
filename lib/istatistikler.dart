import 'dart:core';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Istatistik extends ConsumerStatefulWidget {
  const Istatistik({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _IstatistikState();
}

class _IstatistikState extends ConsumerState<Istatistik> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  List<String> carilist = [];
  String? cariadi;
  String? tarih;
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
        title: const Text("İstatistikler"),
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
                          value: cariadi,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person), label: Text("Cari")),
                          items: carilist.map((val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (value) {
                            cariadi = value!;
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
                        icon: Icon(Icons.calendar_today), labelText: "Yıl"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        initialDatePickerMode: DatePickerMode.year,
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy').format(pickedDate);
                        dateinput.text = formattedDate;
                      }
                    },
                    onSaved: (formattedDate) {
                      tarih = formattedDate!;
                    },
                    validator: (formattedDate) {
                      if (formattedDate?.isNotEmpty != true) {
                        return "Yıl Seçmelisiniz";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
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

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) {
                              return Stats(cariadi!, tarih!);
                            },
                          ));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Grafiği Göster"),
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

class Stats extends StatefulWidget {
  final String cariadi;
  final String tarih;
  const Stats(this.cariadi, this.tarih, {Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  late bool listeyukleme;
  @override
  void initState() {
    super.initState();
    carialma();
  }

  final List<Caricirolari> data = [];
  Map<String, dynamic> giri = {};
  final List<Map> hesaplist = [];
  final List liste = [];
  final uid = FirebaseAuth.instance.currentUser?.uid;
  var satisocak = 0.0;
  var satissubat = 0.0;
  var satismart = 0.0;
  var satisnisan = 0.0;
  var satismayis = 0.0;
  var satishaziran = 0.0;
  var satistemmuz = 0.0;
  var satisagustos = 0.0;
  var satiseylul = 0.0;
  var satisekim = 0.0;
  var satiskasim = 0.0;
  var satisaralik = 0.0;

  var tahsilatocak = 0.0;
  var tahsilatsubat = 0.0;
  var tahsilatmart = 0.0;
  var tahsilatnisan = 0.0;
  var tahsilatmayis = 0.0;
  var tahsilathaziran = 0.0;
  var tahsilattemmuz = 0.0;
  var tahsilatagustos = 0.0;
  var tahsilateylul = 0.0;
  var tahsilatekim = 0.0;
  var tahsilatkasim = 0.0;
  var tahsilataralik = 0.0;

  Future<void> carialma() async {
    final hes = FirebaseFirestore.instance
        .collection("kullanıcılar")
        .doc(uid!)
        .collection("hesaplar")
        .where("cari", isEqualTo: widget.cariadi)
        .where("yil", isEqualTo: widget.tarih)
        .orderBy("tarih", descending: false);
    final resp = await hes.get();
    final list = resp.docs;
    for (int i = 0; i < list.length; i++) {
      hesaplist.add(list[i].data());
    }

    for (var element in hesaplist) {
      if (element["ay"] == "Ocak") {
        giri["ay"] = "Ocak";
        giri["ayliksatis"] = satisocak += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatocak += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Şubat") {
        giri["ay"] = "Şubat";
        giri["ayliksatis"] = satissubat += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatsubat += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Mart") {
        giri["ay"] = "Mart";
        giri["ayliksatis"] = satismart += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatmart += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Nisan") {
        giri["ay"] = "Nisan";
        giri["ayliksatis"] = satisnisan += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatnisan += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Mayıs") {
        giri["ay"] = "Mayıs";
        giri["ayliksatis"] = satismayis += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatmayis += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Haziran") {
        giri["ay"] = "Haziran";
        giri["ayliksatis"] = satishaziran += element["satistutari"];
        giri["ayliktahsilat"] = tahsilathaziran += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Temmuz") {
        giri["ay"] = "Temmuz";
        giri["ayliksatis"] = satistemmuz += element["satistutari"];
        giri["ayliktahsilat"] = tahsilattemmuz += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Ağustos") {
        giri["ay"] = "Ağustos";
        giri["ayliksatis"] = satisagustos += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatagustos += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Eylül") {
        giri["ay"] = "Eylül";
        giri["ayliksatis"] = satiseylul += element["satistutari"];
        giri["ayliktahsilat"] = tahsilateylul += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Ekim") {
        giri["ay"] = "Ekim";
        giri["ayliksatis"] = satisekim += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatekim += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Kasım") {
        giri["ay"] = "Kasım";
        giri["ayliksatis"] = satiskasim += element["satistutari"];
        giri["ayliktahsilat"] = tahsilatkasim += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
      if (element["ay"] == "Aralık") {
        giri["ay"] = "Aralık";
        giri["ayliksatis"] = satisaralik += element["satistutari"];
        giri["ayliktahsilat"] = tahsilataralik += element["tahsilattutari"];
        data.add(Caricirolari.fromMap(giri));
      }
    }
    setState(() {
      listeyukleme = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final yilingunu = int.parse(DateFormat("D").format(DateTime.now()));
    final yil = DateFormat("yyyy").format(DateTime.now());
    final toplamsatis = satisocak +
        satissubat +
        satismart +
        satisnisan +
        satismayis +
        satishaziran +
        satistemmuz +
        satisagustos +
        satiseylul +
        satisekim +
        satiskasim +
        satisaralik;
    final toplamtahsilat = tahsilatocak +
        tahsilatsubat +
        tahsilatmart +
        tahsilatnisan +
        tahsilatmayis +
        tahsilathaziran +
        tahsilattemmuz +
        tahsilatagustos +
        tahsilateylul +
        tahsilatekim +
        tahsilatkasim +
        tahsilataralik;
    double ortalamasatis;
    double ortalamatahsilat;
    if (widget.tarih == yil) {
      ortalamasatis = toplamsatis / yilingunu * 30;
    } else {
      ortalamasatis = toplamsatis / 12;
    }
    if (widget.tarih == yil) {
      ortalamatahsilat = toplamtahsilat / yilingunu * 30;
    } else {
      ortalamatahsilat = toplamtahsilat / 12;
    }
    String cari = widget.cariadi;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Cari İstatistikleri"),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: CariChart(data, cari, ortalamasatis, ortalamatahsilat)),
      ),
    );
  }
}

class CariChart extends StatelessWidget {
  final List<Caricirolari> data;
  final String cari;
  final double ortalamasatis;
  final double ortalamatahsilat;

  const CariChart(
      this.data, this.cari, this.ortalamasatis, this.ortalamatahsilat,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int ortsatis = ortalamasatis.round();
    final int orttahsilat = ortalamatahsilat.round();
    List<charts.Series<Caricirolari, String>> series = [
      charts.Series(
        id: 'Satış',
        domainFn: (Caricirolari sales, _) => sales.ay,
        measureFn: (Caricirolari sales, _) => sales.ayliksatis,
        data: data,
        labelAccessorFn: (Caricirolari sales, _) =>
            '${sales.ayliksatis.toString()} ₺',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      charts.Series(
        id: 'Tahsilat',
        domainFn: (Caricirolari sales, _) => sales.ay,
        measureFn: (Caricirolari sales, _) => sales.ayliktahsilat,
        data: data,
        labelAccessorFn: (Caricirolari sales, _) =>
            '${sales.ayliktahsilat.toString()} ₺',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      )
    ];

    return Container(
      height: 600,
      padding: const EdgeInsets.all(5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                "$cari Aylık İşlem Hacmi Grafiği",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  vertical: false,
                  defaultRenderer: charts.BarRendererConfig(
                    maxBarWidthPx: 30,
                    barRendererDecorator: charts.BarLabelDecorator<String>(
                        insideLabelStyleSpec: const charts.TextStyleSpec(
                            color: charts.Color.white),
                        outsideLabelStyleSpec: const charts.TextStyleSpec()),
                  ),
                  barRendererDecorator: charts.BarLabelDecorator<String>(
                      insideLabelStyleSpec:
                          const charts.TextStyleSpec(color: charts.Color.white),
                      outsideLabelStyleSpec: const charts.TextStyleSpec()),
                  behaviors: [charts.SeriesLegend()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  bottom: 8,
                  top: 5,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aylık Ortalama Satış      :  ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("Aylık Ortalama Tahsilat :  ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(" $ortsatis ₺",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(" $orttahsilat ₺",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13))
                      ],
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "*Aylık ortalamalar seçilen yıl içinde yapılan toplam işlem "
                  "tutarının 12 aya bölünmesiyle hesaplanmaktadır.",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Text(
                    "*Seçilen yıl, içinde bulunulan yıl ise toplam tutarın 12 ay"
                    " yerine yılın başından bugüne kadar geçen süreye bölünmesiyle hesaplanır.",
                    style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Caricirolari {
  String ay;
  double ayliksatis;
  double ayliktahsilat;

  Caricirolari(
    this.ay,
    this.ayliksatis,
    this.ayliktahsilat,
  );
  Caricirolari.fromMap(Map<String, dynamic> m)
      : this(
          m["ay"],
          m["ayliksatis"],
          m["ayliktahsilat"],
        );
}
