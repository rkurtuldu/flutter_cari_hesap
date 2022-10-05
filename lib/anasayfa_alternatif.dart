import 'package:cari/istatistikler.dart';
import 'package:cari/satis.dart';
import 'package:cari/tahsilat.dart';
import 'package:cari/yeni_cari.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'giris.dart';
import 'cari_goruntuleme.dart';
import 'google_signin.dart';

class AnasayfaAlt extends StatelessWidget {
  const AnasayfaAlt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black54),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () async {
                        await signoutgoogle();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Splash(),
                          ),
                        );
                      },
                      child: const Text(
                        "Çıkış",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
            ListTile(
              title: const Text('Satış'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const Satis();
                  },
                ));
              },
            ),
            ListTile(
              title: const Text('Tahsilat'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const Tahsilat();
                  },
                ));
              },
            ),
            ListTile(
              title: const Text('Bakiye Görüntüleme'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const CariGoruntuleme();
                  },
                ));
              },
            ),
            ListTile(
              title: const Text('Yeni Cari'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const Yenicari();
                  },
                ));
              },
            ),
            ListTile(
              title: const Text('İstatistikler'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const Istatistik();
                  },
                ));
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 75,
          elevation: 5,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logobar.png',
                height: 65,
                color: Colors.white,
              ),
              const SizedBox(
                width: 45,
              )
            ],
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const Satis();
                      },
                    ));
                  },
                  child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Satış"),
                      ))),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const Tahsilat();
                      },
                    ));
                  },
                  child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Tahsilat"),
                      ))),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const CariGoruntuleme();
                      },
                    ));
                  },
                  child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Bakiye Görüntüleme"),
                      ))),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const Yenicari();
                      },
                    ));
                  },
                  child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Yeni Cari"),
                      ))),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const Istatistik();
                    }));
                  },
                  child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("İstatistikler"),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}