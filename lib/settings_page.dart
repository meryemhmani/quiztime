import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Set Dark Theme'),
            onTap: () => _setDarkTheme(context, adaptiveTheme),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: const Text('Set Light Theme'),
            onTap: () => _setLightTheme(context, adaptiveTheme),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Set System Theme'),
            onTap: () => _setSystemTheme(context, adaptiveTheme),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Change Language'),
            onTap: () => _showLanguageDialog(context),
          ),
        ],
      ),
    );
  }

  // Méthodes pour gérer les thèmes
  void _setDarkTheme(BuildContext context, AdaptiveThemeManager adaptiveTheme) {
    adaptiveTheme.setDark();
    Navigator.pop(context);
  }

  void _setLightTheme(BuildContext context, AdaptiveThemeManager adaptiveTheme) {
    adaptiveTheme.setLight();
    Navigator.pop(context);
  }

  void _setSystemTheme(BuildContext context, AdaptiveThemeManager adaptiveTheme) {
    adaptiveTheme.setSystem();
    Navigator.pop(context);
  }

  // Affichage du dialogue de sélection de langue
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () => _changeLanguage(context, Locale('en', '')),
              ),
              ListTile(
                title: Text('Français'),
                onTap: () => _changeLanguage(context, Locale('fr', '')),
              ),
              ListTile(
                title: Text('العربية'),
                onTap: () => _changeLanguage(context, Locale('ar', '')),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    MyApp.of(context)?.setLocale(locale);
    Navigator.of(context).pop();
  }
}
