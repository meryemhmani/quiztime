import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qgithub/home.dart'; // Remplacez par le chemin réel de HomePage
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Assurez-vous que les fichiers l10n sont générés
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Récupération du thème sauvegardé
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  // Permettre l'accès à l'état de l'application pour changer la langue
  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', ''); // Langue par défaut : anglais

  // Méthode pour changer la langue
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        return MaterialApp(
          // Configuration locale
          locale: _locale,
          supportedLocales: const [
            Locale('en', ''), // Anglais
            Locale('fr', ''), // Français
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first; // Langue par défaut si aucune correspondance
          },
          theme: theme,
          darkTheme: darkTheme,
          themeMode: _convertToThemeMode(widget.savedThemeMode),

          // Gestion des erreurs
          builder: (context, widget) {
            ErrorWidget.builder = (FlutterErrorDetails details) {
              return Center(
                child: Text(
                  "Something went wrong!",
                  style: TextStyle(color: Colors.red),
                ),
              );
            };
            return widget!;
          },

          home:   HomePage(), // Assurez-vous que HomePage existe et est importée
        );
      },
    );
  }

  /// Conversion d'AdaptiveThemeMode en ThemeMode
  ThemeMode _convertToThemeMode(AdaptiveThemeMode? mode) {
    switch (mode) {
      case AdaptiveThemeMode.light:
        return ThemeMode.light;
      case AdaptiveThemeMode.dark:
        return ThemeMode.dark;
      case AdaptiveThemeMode.system:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
