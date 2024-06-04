import 'package:flutter/material.dart';

class GiaNgoaiTe2 extends StatelessWidget {
  final dynamic item;

  const GiaNgoaiTe2({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Implement UI to display based on the type of item (DataTyGiaVCB, DataTyGiaTC, DataBIDV)
    return SizedBox(
      child: SizedBox(
        child: Text(item.toString()),
      ),
    );
  }
}
