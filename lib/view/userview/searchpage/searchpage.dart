import 'dart:convert';
import 'package:advancedturizmuyg/view/userview/lokasyondetay.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:flutter/material.dart';
import 'package:advancedturizmuyg/model/lokasyon.dart';
import 'package:advancedturizmuyg/model/services/apiConnection.dart';
import 'package:get/get.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key? key}) : super(key: key);

  @override
  _SearchPageViewState createState() => _SearchPageViewState();
}
final LokasyonController _lcontroller = Get.put(LokasyonController());
class _SearchPageViewState extends State<SearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  final LocationsService _locationsService = LocationsService();
  Future<LokasyonDataModel>? _allLocationsFuture;
  List<Lokasyon> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _allLocationsFuture = _locationsService.lokasyonapiCall();
    _allLocationsFuture?.then((data) {
      setState(() {
        _filteredLocations = data.items;
      });
    });
  }

  void _filterLocations(String query) {
    _allLocationsFuture?.then((data) {
      setState(() {
        if (query.isEmpty) {
          _filteredLocations = data.items;
        } else {
          _filteredLocations = data.items.where((location) {
            final locationName = location.lokasyonAdi?.toLowerCase() ?? "";
            final input = query.toLowerCase();
            return locationName.contains(input);
          }).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lokasyonSearch'.tr),
      ),
      body: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "search".tr,
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.lightBlue),
                        onPressed: () => _filterLocations(_searchController.text),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: (value) {
                      _filterLocations(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<LokasyonDataModel>(
                future: _allLocationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                              
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            height: 85,
                            decoration: BoxDecoration(image: DecorationImage(image: MemoryImage(base64Decode(location.images?[1] ?? "")),fit: BoxFit.fitWidth),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                             
                              title: Container(
                                padding: const EdgeInsets.all(8.0),
                                
                                child: Text(
                                  location.lokasyonAdi ?? "",
                                  style: const TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
                                ),
                              ),
                              subtitle: Container(
                                
                                color: Colors.black26,
                                child: Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (starIndex) => Icon(
                                        starIndex < (location.puan ?? 0)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    const SizedBox(width: 12), 
                                    Text(
                                      "${location.puan ?? 0}",
                                      style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                _lcontroller.updateSelectedId(location.id ?? "");
                                Get.to(()=>const LokasyonDetayView());
                              },
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
     
    );

  }
}

