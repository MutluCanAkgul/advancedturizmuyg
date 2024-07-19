class Yorumlar {
  final String id; // ID'yi String olarak tanımlıyoruz
  final String? kulId;
  final String? lokasyonId;
  final String? yorum;
   double? puan; 
  final String? name;
  final String? surname;
  final String yorumTarih;

  Yorumlar({
    required this.id,
    required this.kulId,
    required this.lokasyonId,
    this.yorum,
    this.puan,
    required this.name,
    required this.surname,
    required this.yorumTarih,
  });

  factory Yorumlar.fromJson(Map<String, dynamic> json) {
    return Yorumlar(
      id: json['id'] as String,
      kulId: json['kulId'] as String?, 
      lokasyonId: json['lokasyonId'] as String?,
      yorum: json['yorum'] as String?,
      puan: (json['puan'] is num) ? (json['puan'] as num).toDouble() : double.tryParse(json['puan'].toString()),
      name: json['name'] as String?, 
      surname: json['surname'] as String?, 
      yorumTarih: json['yorumTarih'],
    );
  }
}

class YorumlarDataModel {
  final List<Yorumlar> items;

  YorumlarDataModel({required this.items});

  factory YorumlarDataModel.fromJson(List<dynamic> jsonList) {
    List<Yorumlar> yorumlarList = jsonList.map((json) => Yorumlar.fromJson(json)).toList();
    return YorumlarDataModel(
      items: yorumlarList,
    );
  }
}
