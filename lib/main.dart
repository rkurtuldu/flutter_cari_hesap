import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'giris.dart';

void main() {
  runApp(const ProviderScope(child: CariApp()));
}

class CariApp extends StatelessWidget {
  const CariApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor gri = MaterialColor(
      const Color.fromRGBO(113, 113, 113, 1).value,
      const <int, Color>{
        50: Color.fromRGBO(110, 110, 110, 0.1),
        100: Color.fromRGBO(110, 110, 110, 0.2),
        200: Color.fromRGBO(110, 110, 110, 0.3),
        300: Color.fromRGBO(110, 110, 110, 0.4),
        400: Color.fromRGBO(110, 110, 110, 0.5),
        500: Color.fromRGBO(110, 110, 110, 0.6),
        600: Color.fromRGBO(110, 110, 110, 0.7),
        700: Color.fromRGBO(110, 110, 110, 0.8),
        800: Color.fromRGBO(113, 113, 113, 0.9),
        900: Color.fromRGBO(113, 113, 113, 1),
      },
    );
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
      title: 'CariApp',
      theme: ThemeData(
        primarySwatch: gri,
      ),
      home: const Splash(),
    );
  }
}
