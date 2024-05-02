import 'package:flutter/material.dart';
import 'package:gia_tien/board/board_gia_ngoai_te.dart';
import 'package:gia_tien/modal/ty_gia_bidv.dart';
import 'package:gia_tien/modal/ty_gia_data.dart';
import 'package:gia_tien/modal/ty_gia_techcom.dart';

class MyTyGia extends StatefulWidget {
  @override
  State<MyTyGia> createState() => _MyTyGiaState();
}

class _MyTyGiaState extends State<MyTyGia> with SingleTickerProviderStateMixin {
  final List<bool> _isSelected = [true, false, false];
  @override
  void dispose() {
    // Không cần giải phóng vì không còn AnimationController
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = (i == index);
      }
    });
  }

  final List<DataTyGiaVCB> item1s = [
    DataTyGiaVCB(
        name: "USD", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
    DataTyGiaVCB(
        name: "USD", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
    DataTyGiaVCB(
        name: "USD", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
    DataTyGiaVCB(
        name: "USD", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaVCB(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaVCB(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
  ];
  final List<DataTyGiaBIDV> item2s = [
    DataTyGiaBIDV(
        name: "USD", muaVao: '27000', banRa: '26000', chuyenKhoan: '29000'),
    DataTyGiaBIDV(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaBIDV(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaBIDV(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaBIDV(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaBIDV(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
  ];
  final List<DataTyGiaTC> item3s = [
    DataTyGiaTC(
        name: "USD", muaVao: '25,800', banRa: '27,000', chuyenKhoan: '29000'),
    DataTyGiaTC(
        name: "ERO", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaTC(
        name: "NDT", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaTC(
        name: "GBP", muaVao: '26000', banRa: '27000', chuyenKhoan: '28000'),
    DataTyGiaTC(
        name: "JPY", muaVao: '25000', banRa: '26000', chuyenKhoan: '25000'),
    DataTyGiaTC(
        name: "AUD", muaVao: '27000', banRa: '28000', chuyenKhoan: '29000'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Tỷ Giá',
          style: TextStyle(color: Colors.yellow),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  for (int i = 0; i < _isSelected.length; i++)
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color:
                            _isSelected[i] ? Colors.yellow : Colors.transparent,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: TextButton(
                        onPressed: () => _onTap(i),
                        child: Text(
                            '${i == 0 ? 'VietCombank' : i == 1 ? 'BIDV' : i == 2 ? 'Techcombank' : ''}'),
                      ),
                    ),
                ],
              ),
              Container(
                height: 5,
                width: double.infinity,
                color: Colors.yellow,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Ngoại Tệ"),
            Text("Mua Vào"),
            Text("Chuyển Khoản"),
            Text("Bán Ra"),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('đ/ngoại tệ'),
            // Other widgets...
          ],
        ),
        SizedBox(height: 5),
        if (_isSelected[0])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: item1s.map((item) => GiaNgoaiTe(item: item)).toList(),
              ),
            ),
          ),
        if (_isSelected[1])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: item2s.map((item) => GiaNgoaiTe(item: item)).toList(),
              ),
            ),
          ),
        if (_isSelected[2])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: item3s.map((item) => GiaNgoaiTe(item: item)).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
