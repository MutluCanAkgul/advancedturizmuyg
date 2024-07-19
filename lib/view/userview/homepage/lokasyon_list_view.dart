import 'package:advancedturizmuyg/model/lokasyon.dart';
import 'package:advancedturizmuyg/view/userview/homepage/homepage.dart';
import 'package:flutter/material.dart';

class LokasyonListView extends StatefulWidget {
  final LokasyonDataModel lokasyonData;

  LokasyonListView({required this.lokasyonData});

  @override
  State<LokasyonListView> createState() => _LokasyonListViewState();
}

class _LokasyonListViewState extends State<LokasyonListView> {
  late Map<String, List<Lokasyon>> groupedBySehir;
  @override
  initState() {
    super.initState();
    // Şehirlere göre gruplandırma
    groupedBySehir = {};
    for (var lokasyon in widget.lokasyonData.items) {
      String sehir = lokasyon.sehir ?? "Bilinmeyen Şehir";
      if (groupedBySehir.containsKey(sehir)) {
        groupedBySehir[sehir]?.add(lokasyon);
      } else {
        groupedBySehir[sehir] = [lokasyon];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedBySehir.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(entry.key,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  return LokasyonItem(lokasyon: entry.value[index]);
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }
}
