import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../widgets/app_drawer.dart';
import '../widgets/labeled_radio.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

ThemeMode _themeKey = ThemeMode.system;

class _SettingScreenState extends State<SettingScreen> {

  void setThemeKey(ThemeMode themeKey) {
    if (themeKey == ThemeMode.dark) {
      EasyDynamicTheme.of(context).changeTheme(dark: true);
    } else if (themeKey == ThemeMode.light) {
      EasyDynamicTheme.of(context).changeTheme(dark: false);
    } else {
      EasyDynamicTheme.of(context).changeTheme(dynamic: true);
    }
    setState(() {
      _themeKey = themeKey;
    });
  }

  bool _isSelectedByThemeKey(ThemeMode themeKeys) {
    var isSelected = _themeKey == themeKeys;
    return isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Settings'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: PlatformText('Theme Settings:', style: const TextStyle(fontSize: 16),),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <LabeledRadio>[
              LabeledRadio(
                label: 'System Theme',
                padding: const EdgeInsets.only(left: 3.0),
                value: _isSelectedByThemeKey(ThemeMode.system),
                groupValue: true,
                onChanged: (bool newValue) {
                  setThemeKey(ThemeMode.system);
                },
              ),
              LabeledRadio(
                label: 'Light Theme',
                padding: const EdgeInsets.only(left: 3.0),
                value: _isSelectedByThemeKey(ThemeMode.light),
                groupValue: true,
                onChanged: (bool newValue) {
                  setThemeKey(ThemeMode.light);
                },
              ),
              LabeledRadio(
                label: 'Dark Theme',
                padding: const EdgeInsets.only(left: 3.0),
                value: _isSelectedByThemeKey(ThemeMode.dark),
                groupValue: true,
                onChanged: (bool newValue) {
                  setThemeKey(ThemeMode.dark);
                },
              ),
            ],
          )
        ],
      ),
      material: (_, __)  => MaterialScaffoldData(
        drawer: AppDrawer()
      )
    );
  }
}
