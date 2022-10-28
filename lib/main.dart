import 'package:ecsadmin/database/database.dart';
import 'package:ecsadmin/pages/home/homepage.dart';
import 'package:ecsadmin/pages/qr_generator/qr_generator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/": (context) => HomePage(),
        "/qr_page": (context) => QRGeneratorPage(),
      },
    );
  }
}
