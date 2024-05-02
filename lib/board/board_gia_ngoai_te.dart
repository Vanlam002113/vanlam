import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GiaNgoaiTe extends StatelessWidget {
  GiaNgoaiTe({
    super.key,
    required this.item,
  });
  var item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.amber,
      ),
      height: 20,
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(item.name),
          Text(item.muaVao),
          Text(item.chuyenKhoan),
          Text(item.banRa),
        ],
      ),
    );
  }
}
