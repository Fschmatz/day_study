import 'package:day_study/pages/home.dart';
import 'package:day_study/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
      builder:(context, ThemeNotifier notifier, child){
        return MaterialApp(
          theme: notifier.darkTheme ? dark : light,
          home: Home(),
        );
      },
    ),
  )
  );
}

