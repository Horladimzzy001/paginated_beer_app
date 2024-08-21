import 'package:flutter/material.dart';
import 'package:paginated_beer_app/home_screen.dart';
import 'package:provider/provider.dart';

import 'beer_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostListScreen(),
    );
  }
}

