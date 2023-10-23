import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'view/screens/camera_screen.dart';
import 'view/screens/home_screen.dart';
import 'controller/home_screen_controller.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeScreenController>(
      create: (_) => HomeScreenController(),
      child: MaterialApp(
      title: 'Firebase Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        CameraScreen.routeName: (ctx) => CameraScreen(cameraList: _cameras,),
      },
    ),
    );
  }
}