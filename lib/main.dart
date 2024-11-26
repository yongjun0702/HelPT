import 'package:camera/camera.dart';
import 'package:helpt/config/color.dart';
import 'package:helpt/screen/login_screen.dart';
import 'package:helpt/screen/splash_screen.dart';
import 'package:helpt/service/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

late Size ratio;
late List<CameraDescription> cameras;

final FlutterLocalNotificationsPlugin _local =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();
  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkLoginStatus(),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: "Pretendard",
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            primaryColor: HelPT.mainBlue,
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(color: HelPT.lightgrey3, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Pretendard"),
              backgroundColor: HelPT.background,
              iconTheme: IconThemeData(color: HelPT.lightgrey3),
            )),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            // MediaQuery가 올바르게 초기화되었는지 확인
            final mediaQuery = MediaQuery.of(context);
            if (mediaQuery.size == null) {
              return const Center(
                  child: CircularProgressIndicator()); // 로딩 화면 표시
            }
            ratio =
                Size(mediaQuery.size.width / 412, mediaQuery.size.height / 892);
            return AuthHandler();
          },
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            boldText: false,
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        ),
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      return LoginScreen();
    } else {
      return SplashScreen();
    }
  }
}
