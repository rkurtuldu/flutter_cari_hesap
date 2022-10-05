import 'package:cari/istatistikler.dart';
import 'package:cari/satis.dart';
import 'package:cari/tahsilat.dart';
import 'package:cari/yeni_cari.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'giris.dart';
import 'cari_goruntuleme.dart';
import 'google_signin.dart';

class Anasayfa extends StatelessWidget {
  const Anasayfa({Key? key}) : super(key: key);

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5),
                        fixedSize:
                            MaterialStateProperty.all(const Size.square(120)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "Satış",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )
                          ])),
                  const SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5),
                        fixedSize:
                            MaterialStateProperty.all(const Size.square(120)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "Tahsilat",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )
                          ])),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5),
                        fixedSize:
                            MaterialStateProperty.all(const Size.square(120)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.list,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "Bakiye",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )
                          ])),
                  const SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5),
                        fixedSize:
                            MaterialStateProperty.all(const Size.square(120)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "Yeni Cari",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )
                          ])),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5),
                        fixedSize:
                            MaterialStateProperty.all(const Size(280, 80)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const Istatistik();
                          },
                        ));
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.query_stats,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "İstatistikler",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )
                          ])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
