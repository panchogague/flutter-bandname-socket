import 'package:band_name_app/providers/socket_provider.dart';
import 'package:band_name_app/screens/home_screen.dart';
import 'package:band_name_app/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketProvider())],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomeScreen(),
          'status': (context) => const StatusScreen()
        },
      ),
    );
  }
}
