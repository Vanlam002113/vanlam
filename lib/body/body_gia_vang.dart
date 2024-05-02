import 'package:flutter/material.dart';

import 'package:gia_tien/board/broad_gia_vang.dart';
import 'package:gia_tien/modal/gia_vang_sjc.dart';

class MyGiaVang extends StatefulWidget {
  @override
  State<MyGiaVang> createState() => _MyGiaVangState();
}

class _MyGiaVangState extends State<MyGiaVang>
    with SingleTickerProviderStateMixin {
  final List<bool> _isSelected = [
    true,
    false,
    false,
    false
  ]; // Trạng thái chọn của các nút

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

  final List<DataGiaVangSJC> item1s = [
    DataGiaVangSJC(
        name: "SJC 1L, 10L ,1KG", muaVao: '83,000,000', banRa: '85,200,00'),
    DataGiaVangSJC(name: "SJC 5C", muaVao: '83,000,000', banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "SJC 2C, 1C, 5P", muaVao: '83,000,000', banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "VÀNG NHẪN SJC 99,99 1C, 2C, 5C",
        muaVao: '83,000,000',
        banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "VÀNG NHẪN SJC 99,99 1C, 2C, 5C",
        muaVao: '83,000,000',
        banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "SJC 1L, 10L ,1KG", muaVao: '83,000,000', banRa: '85,200,00'),
    DataGiaVangSJC(name: "SJC 5C", muaVao: '83,000,000', banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "SJC 2C, 1C, 5P", muaVao: '83,000,000', banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "VÀNG NHẪN SJC 99,99 1C, 2C, 5C",
        muaVao: '83,000,000',
        banRa: '85,200,00'),
    DataGiaVangSJC(
        name: "VÀNG NHẪN SJC 99,99 1C, 2C, 5C",
        muaVao: '83,000,000',
        banRa: '85,200,00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Giá Vàng',
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
                            '${i == 0 ? 'SJC' : i == 1 ? 'PNJ' : i == 2 ? 'DOJI' : 'Mi Hồng'}'),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Loại Vàng"),
            Text("Mua Vào"),
            Text("Bán Ra"),
          ],
        ),
        if (_isSelected[0])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Hồ Chí Minh'),
                  Column(
                    children:
                        item1s.map((item) => GiaVang(item: item)).toList(),
                  ),
                ],
              ),
            ),
          ),
        if (_isSelected[1])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Đà Nẵng'),
                  Column(
                    children:
                        item1s.map((item) => GiaVang(item: item)).toList(),
                  ),
                ],
              ),
            ),
          ),
        if (_isSelected[2])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Huế'),
                  Column(
                    children:
                        item1s.map((item) => GiaVang(item: item)).toList(),
                  ),
                ],
              ),
            ),
          ),
        if (_isSelected[3])
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Hà Nội'),
                  Column(
                    children:
                        item1s.map((item) => GiaVang(item: item)).toList(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
