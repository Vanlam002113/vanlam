import 'package:flutter/material.dart';
import 'package:gia_tien/body/body_gia_vang.dart';
import 'package:gia_tien/body/body_quy_doi.dart';
import 'package:gia_tien/body/body_ty_gia.dart';
import 'package:gia_tien/body/body_profile.dart';
import 'package:gia_tien/modal/model_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(
      ModelClassAdapter()); // Register your adapter if using custom data model
  await Hive.openBox('selectedValues');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tỷ Giá",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int tapCount = 0;
  int selectedIndex = 0;
  final Widget _myGiaVang = const MyGiaVang();
  final Widget _myQuyDoi = const MyQuyDoi();
  final Widget _myTyGia = const MyTyGia();
  final Widget _myProfile = const MyProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: "Tỷ Giá"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Quy Đổi VND"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Đổi Ngoại Tệ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _myTyGia;
    } else if (selectedIndex == 1) {
      return _myQuyDoi;
    } else if (selectedIndex == 2) {
      return _myGiaVang;
    } else {
      return _myProfile;
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
