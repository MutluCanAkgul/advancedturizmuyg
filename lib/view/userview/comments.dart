import 'dart:convert';
import 'package:advancedturizmuyg/model/lokasyon.dart';
import 'package:advancedturizmuyg/model/services/apiConnection.dart';
import 'package:advancedturizmuyg/model/yorumlar.dart';
import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class YorumLength extends GetxController{
  final RxString yorumLength = "".obs;
 
}
class LokasyonComments extends StatefulWidget {
  const LokasyonComments({super.key});

  @override
  State<LokasyonComments> createState() => _LokasyonCommentsState();
}

class _LokasyonCommentsState extends State<LokasyonComments> {
  final LokasyonController _lcontroller = Get.put(LokasyonController());
  final LocationsService _locationsService = LocationsService();
  final YorumlarService _yorumlarService = YorumlarService();
  final YorumLength _yorumLengthController = Get.put(YorumLength());
  late Lokasyon _lokasyon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LokasyonDataModel>(
      future: _locationsService.lokasyonapiCall(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Veri Yok'));
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        } else {
          _lokasyon = snapshot.data!.items.firstWhere(
            (lokasyon) => lokasyon.id == _lcontroller.selectedId.value,
          );
          return Scaffold(
            appBar: AppBar(
              title: Text(
                _lokasyon.lokasyonAdi ?? "",
                style: Theme.of(context).textTheme.headline6,
              ),
              centerTitle: true,
              elevation: 1,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < _lokasyon.puan ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                              size: 30,
                            );
                          }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${_lokasyon.puan} | Comments (${_yorumLengthController.yorumLength.value})",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _yorumlarService.yorumlarapiCall(),
                      builder: (context, yorumlarSnapshot) {
                        if (yorumlarSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!yorumlarSnapshot.hasData) {
                          return const Center(child: Text("Yorumlar boş"));
                        } else if (yorumlarSnapshot.hasError) {
                          return Center(child: Text("Hata: ${yorumlarSnapshot.error}"));
                        } else {
                          final yorumlar = yorumlarSnapshot.data!.items
                              .where((yorum) => yorum.lokasyonId == _lokasyon.id)
                              .toList();
                          _yorumLengthController.yorumLength.value = yorumlar.length.toString();
                          return ListView.builder(
                            itemCount: yorumlar.length,
                            itemBuilder: (context, index) {
                              final yorum = yorumlar[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(top: BorderSide(color: Colors.black)),
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${yorum.name!} ${yorum.surname!}'),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: List.generate(5, (starIndex) {
                                                return Icon(
                                                  starIndex < yorum.puan! ? Icons.star : Icons.star_border,
                                                  color: Colors.yellow,
                                                );
                                              }),
                                            ),
                                            Text(yorum.yorumTarih),
                                          ],
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(yorum.yorum!),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customButton(
                      text: "Add Comment",
                      onTap: () {
                        _lcontroller.updateSelectedId(_lokasyon.id ?? "");
                        Get.to(() => const CreateComment());
                      },
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class CreateComment extends StatefulWidget {
  const CreateComment({super.key});

  @override
  State<CreateComment> createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  final UserController _ucontroller = Get.put(UserController());
  final LokasyonController _lcontroller = Get.put(LokasyonController());
  final TextEditingController yorumController = TextEditingController();
  final LocationsService _locationsService = LocationsService();
  final YorumlarService _yorumlarService = YorumlarService();
  int _puan = 0;
void yorumEkle() async {
  final userId = _ucontroller.kulId.value;
  final lokasyonId = _lcontroller.selectedId.value;
  final name = _ucontroller.userName.value;
  final surname = _ucontroller.userSurname.value;
  final yorum = yorumController.text;
  final puan = _puan;
  final String yorumTarih = DateFormat('dd-MM-yyyy').format(DateTime.now());
  if (puan == 0) {
    Get.snackbar("Hata!", "Puan seçimi zorunludur");
  } else {
    // JSON yapısını oluştur
    final Map<String,dynamic> yorumData = {    
          'kulId': userId,
          'lokasyonId': lokasyonId,
          'name': name,
          'surname': surname,
          'yorum': yorum,
          'puan': puan,
          'yorumTarih':yorumTarih
    };

    // JSON stringine dönüştür
    final String body = jsonEncode(yorumData);

    // HTTP POST isteği gönder
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/Yorumlar'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Get.snackbar("Başarılı", "Yorumunuz başarıyla eklendi.");
      yorumController.text = "";
    } else {
      Get.snackbar("Hata", "Yorum eklenemedi. Lütfen tekrar deneyin! Durum Kodu = ${response.statusCode}");
    }
  }
}
 Future<void> ortalamaPuaniHesapla() async {
  final List<Lokasyon> allLokayonlar = await _locationsService.lokasyonapiCall().then((response) => response.items);
  
  final Lokasyon? selectedLokasyon = allLokayonlar.firstWhere(
    (lokasyon) => lokasyon.id == _lcontroller.selectedId.value,
  );

  if (selectedLokasyon != null) {
    final List<Yorumlar> allYorumlar = await _yorumlarService.yorumlarapiCall().then((response) => response.items);
    
    double totalPuan = 0;
    int yorumSayisi = allYorumlar.where((yorum) => yorum.lokasyonId == selectedLokasyon.id).length;

    if (yorumSayisi > 0) {
      totalPuan = allYorumlar.where((yorum) => yorum.lokasyonId == selectedLokasyon.id).fold(0, (sum, yorum) => sum + yorum.puan!);
    }

    double ortalamaPuan = yorumSayisi > 0 ? totalPuan / yorumSayisi : 0;

   
    Lokasyon updatedLokasyon = Lokasyon(
      id: selectedLokasyon.id,
      lokasyonAdi: selectedLokasyon.lokasyonAdi,
      lokasyonAdresi: selectedLokasyon.lokasyonAdresi,
      sehir: selectedLokasyon.sehir,
      icerik: selectedLokasyon.icerik,
      icerikDili: selectedLokasyon.icerikDili,
      images: selectedLokasyon.images,
      puan: ortalamaPuan, 
    );

    await updateLokasyonPuan(updatedLokasyon); // Güncelleme isteği gönder
  }
}

Future<void> updateLokasyonPuan(Lokasyon lokasyon) async {
  final Map<String, dynamic> lokasyonData = lokasyon.toJson(); // Tüm veriyi JSON'a çevir

  final String body = jsonEncode(lokasyonData);

  final response = await http.put(
    Uri.parse('http://10.0.2.2:3000/Lokasyonlar/${lokasyon.id}'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Lokasyon puanı başarıyla güncellendi.");
  } else {
    print("Lokasyon puanı güncellenemedi. Durum Kodu = ${response.statusCode}");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yorum Yap",
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Overall Rating:",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
            const SizedBox(height: 10,),
            Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                        onPressed: () {
                          setState(() {
                            _puan = index + 1;
                          });
                        },
                        icon: Icon(
                            index < _puan ? Icons.star : Icons.star_border,size: 30,color: Colors.yellow,));
                  },
                  ),
                ),
                const SizedBox(height: 30,),
            Column(children: [
              textFormField(hintText: "Comment Write:", controller: yorumController,maxLines: 5)
            ],),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: customButton(text: "Send", onTap: (){
                 yorumEkle();
                 ortalamaPuaniHesapla();
                 Get.back();
                }, height: 60)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

