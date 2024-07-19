import 'package:get/get.dart';

class Lokasyon {
  final String? id;
  final String? lokasyonAdi;
  final String? lokasyonAdresi;
  final String? sehir;
  final String? icerik;
  final String? icerikDili;
  RxList<String>? images; // Base64 encoded image strings
  late double puan;

  Lokasyon({
    required this.id,
    required this.lokasyonAdi,
    required this.lokasyonAdresi,
    required this.sehir,
    required this.icerik,
    required this.icerikDili,
    List<String>? images,
    required this.puan,
  }) : this.images = RxList<String>(images ?? []);

  factory Lokasyon.fromJson(Map<String, dynamic> json) {
    RxList<String> imageList = RxList<String>();

    for (int i = 1; i <= 5; i++) {
      if (json['image$i'] != null) {
        imageList.add(json['image$i']);
      }
    }

    return Lokasyon(
      id: json['id'],
      lokasyonAdi: json['lokasyonAdi'],
      lokasyonAdresi: json['lokasyonAdresi'],
      sehir: json['sehir'],
      icerik: json['icerik'],
      icerikDili: json['icerikDili'],
      images: imageList.isNotEmpty ? imageList : null,
      puan: (json['puan'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lokasyonAdi': lokasyonAdi,
      'lokasyonAdresi': lokasyonAdresi,
      'sehir': sehir,
      'icerik': icerik,
      'icerikDili': icerikDili,
      'image1': images!.length > 0 ? images![0] : null,
      'image2': images!.length > 1 ? images![1] : null,
      'image3': images!.length > 2 ? images![2] : null,
      'image4': images!.length > 3 ? images![3] : null,
      'image5': images!.length > 4 ? images![4] : null,
      'puan': puan,
    };
  }
}
class LokasyonDataModel {
  final List<Lokasyon> items;

  LokasyonDataModel({required this.items});

  factory LokasyonDataModel.fromJson(List<dynamic> jsonList) {
    List<Lokasyon> lokasyonList = jsonList.map((json) => Lokasyon.fromJson(json)).toList();
    return LokasyonDataModel(
      items: lokasyonList,
    );
  }
}
