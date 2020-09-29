import 'dart:convert' show json;
import 'dart:ui';

import 'package:flutter/material.dart'
    show Brightness, WidgetsFlutterBinding, runApp;
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;

import 'env.dart';
import 'models/category.dart';
import 'models/statement.dart';
import 'screens/app.dart';
import 'theme/style.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: appTheme().scaffoldBackgroundColor,
    statusBarColor: appTheme().scaffoldBackgroundColor,
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();

  String raw = await rootBundle.loadString('lib/config.json');
  Map config = json.decode(raw);

  BuildEnvironment.init(
    flavor: BuildFlavor.production,
    baseUrl: config['prod']['baseUrl'] as String,
    defaultStatement: Statement.fromMap(config['defaultStatement']),
    errorStatement: Statement.fromMap(config['errorStatement']),
    categories: [
      Category.fromMap(config['categories']['harmless']),
      Category.fromMap(config['categories']['delicate']),
      Category.fromMap(config['categories']['offensive'])
    ],
    maxPrefetchCalls: config['maxPrefetchCalls'],
    prefetchWaitTime: config['prefetchWaitTime'],
  );
  assert(env != null);

  runApp(App());
}