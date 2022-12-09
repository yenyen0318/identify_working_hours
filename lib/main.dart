import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/camera_page.dart';
import 'pages/home_page.dart';
import 'pages/setting_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MyApp(
      camera: firstCamera,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '工時紀錄',
      debugShowCheckedModeBanner: false,
      home: MainPage(camera: camera),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions = <Widget>[
    const GalleryPage(),
    TakePicturePage(
      camera: widget.camera,
    ),
    const SettingPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_open),
            label: '現有照片辨識',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: '拍照辨識',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
