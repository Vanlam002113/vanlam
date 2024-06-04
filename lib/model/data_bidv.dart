class DataBIDV {
  // Use lowerCamelCase for variable names
  final String dataBIDVType;
  final String dataBIDVImageUrl; // Corrected typo (capital U)
  final int dataBIDVMuatienmat;
  final int dataBIDVMuack;
  final int dataBIDVBantienmat;
  final int dataBIDVBanck;

  DataBIDV({
    required this.dataBIDVType,
    required this.dataBIDVImageUrl,
    required this.dataBIDVMuatienmat,
    required this.dataBIDVMuack,
    required this.dataBIDVBantienmat,
    required this.dataBIDVBanck,
  });

  factory DataBIDV.fromJson(Map<String, dynamic> parsedJson) {
    return DataBIDV(
      dataBIDVType:
          parsedJson['type'] ?? '', // Ensure key matching correct property
      dataBIDVImageUrl:
          parsedJson['imageurl'] ?? '', // Ensure key matching correct property
      dataBIDVMuatienmat: int.tryParse(parsedJson['muatienmat'].toString()) ??
          0, // Assuming these are int types, use tryParse for null/error safe int conversion
      dataBIDVMuack: int.tryParse(parsedJson['muack'].toString()) ?? 0,
      dataBIDVBantienmat:
          int.tryParse(parsedJson['bantienmat'].toString()) ?? 0,
      dataBIDVBanck: int.tryParse(parsedJson['banck'].toString()) ?? 0,
    );
  }
}
