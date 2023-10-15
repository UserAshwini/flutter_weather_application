import 'package:flutter/material.dart';
import 'package:flutter_weather_application/data/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String _selectedLanguage = 'en';

  Map<String, String> languageOptions = {
    'en': 'English',
    'hi': 'Hindi',
    'bn': 'Bengali',
    'gu': 'Gujarati',
    'fr': 'French',
  };

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '${AppLocalizations.of(context)!.language} : '  ,
            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                  languageProvider.updateLanguage(Locale(_selectedLanguage));
                });
              }
            },
            items: languageOptions.keys.map((String key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(languageOptions[key]!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

