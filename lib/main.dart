import 'package:flutter/material.dart';
import 'package:socialapp/home.dart';
import 'package:socialapp/logi.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://fcofoalbiqgvisvhrczs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZjb2ZvYWxiaXFndmlzdmhyY
    3pzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3Mjg5NzMsImV4cCI6MjA3OTMwNDk3M30.sM9A7ylxPvFRzlN21zRgFa2m9LZ18G8a
    S9lszEVPE8o',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Supabase.instance.client.auth.currentUser != null
          ? HomePage()
          : LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


