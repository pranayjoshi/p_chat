import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/screens/auth.dart';
import 'package:p_chat/apps/calculator/screens/calc_page.dart';
import 'package:p_chat/apps/chat/controller/chat_controller.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:p_chat/firebase_options.dart';
import 'package:p_chat/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("hi");
  }
  @override
  Widget build(BuildContext context) {
    // 
    return MaterialApp(
      title: 'P-Chat',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            
            return CalcPage();
            
          }
          return AuthScreen();
        },
      ),
    );
  }
}
