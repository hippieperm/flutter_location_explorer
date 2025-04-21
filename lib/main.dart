import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/provider/place_provider.dart';
import 'package:provider/provider.dart';
import 'ui/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaceProvider(),
      child: MaterialApp(
        title: 'Location Explorer',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity:
              VisualDensity.adaptivePlatformDensity, // 모바일 환경에 맞게 레이아웃 조정
          useMaterial3: true, // 머티리얼 3 테마 사용
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
