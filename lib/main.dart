import 'package:flutter/material.dart';
import 'package:gia_tien/body/body_gia_vang.dart';

import 'package:gia_tien/body/body_ty_gia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Giá Vàng",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
  final Widget _myTyGia = const MyTyGia();
  final Widget _myTinTuc = const MyTinTuc();
  final Widget _myProfile = const MyProfile();
  final Widget _myQuyDoi = const MyQuyDoi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Tỷ Giá"),
          BottomNavigationBarItem(
              icon: Icon(Icons.money_off_csred_outlined),
              label: "Quy Đổi Tiền"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Giá Vàng"),
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: "Tin Tức"),
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
    } else if (selectedIndex == 3) {
      return _myTinTuc;
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

class MyTinTuc extends StatelessWidget {
  const MyTinTuc({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Tin Tức"));
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile"));
  }
}

class MyQuyDoi extends StatelessWidget {
  const MyQuyDoi({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile"));
  }
}
