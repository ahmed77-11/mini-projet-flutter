import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:complete_flutter_app/Provider/favorite_provider.dart';
import 'package:complete_flutter_app/Provider/quantity.dart';
import 'package:complete_flutter_app/Views/login.dart';
import 'package:provider/provider.dart';
import 'Views/app_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ 
        // for favorite provider
        ChangeNotifierProvider(create: (_)=>FavoriteProvider()),
        // for quantity provider
         ChangeNotifierProvider(create: (_) => QuantityProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
