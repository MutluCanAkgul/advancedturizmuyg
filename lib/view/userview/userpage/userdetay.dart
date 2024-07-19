import 'dart:convert';
import 'package:advancedturizmuyg/model/lokasyon.dart';
import 'package:advancedturizmuyg/model/services/apiConnection.dart';
import 'package:advancedturizmuyg/model/yorumlar.dart';
import 'package:advancedturizmuyg/view/userview/lokasyondetay.dart';
import 'package:advancedturizmuyg/view/widgets/tools.dart';
import 'package:advancedturizmuyg/viewmodel/lokasyonvalidasyon.dart';
import 'package:advancedturizmuyg/viewmodel/services/adminservice.dart';
import 'package:advancedturizmuyg/viewmodel/validasyon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final AdminAddDataBase _userService = AdminAddDataBase();
  final UserController _controller = Get.put(UserController());
  final LocationsService _lokasyonService = LocationsService();
  final LokasyonController _lcontroller = Get.put(LokasyonController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "My Favorite Locations",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              FutureBuilder<List<String>>(
                future: _userService.getFavorite(_controller.kulId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Center(child: Text("Veri Yok")));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  }

                  final favoriteIds = snapshot.data!;
                  return FutureBuilder<LokasyonDataModel>(
                    future: _lokasyonService.lokasyonapiCall(),
                    builder: (context, lokasyonSnapshot) {
                      if (lokasyonSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (lokasyonSnapshot.hasError) {
                        return Center(child: Text("Hata: ${lokasyonSnapshot.error}"));
                      }

                      final lokasyonData = lokasyonSnapshot.data!;
                      final favoriteLokasyonlar = lokasyonData.items
                          .where((lokasyon) => favoriteIds.contains(lokasyon.id))
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: favoriteLokasyonlar.length,
                        itemBuilder: (context, index) {
                          final lokasyon = favoriteLokasyonlar[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              height: 85,
                              decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(16),
                               image: DecorationImage(image: MemoryImage(base64Decode(lokasyon.images?[0] ?? "")),fit: BoxFit.fitWidth)),
                              child: ListTile(
                                title: Container(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(lokasyon.lokasyonAdi ?? "",style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white,fontWeight: FontWeight.bold)),
                                )),
                                subtitle:   Container(color: Colors.black12,
                                  child: Row(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        (lokasyon.puan ?? 0).toInt(),
                                        (index) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5 - (lokasyon.puan ?? 0).toInt(),
                                        (index) => const Icon(
                                          Icons.star_border,
                                          color: Colors.yellow,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      lokasyon.puan.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    )
                                  ],
                                                                ),
                                ),
                                trailing: Container(height: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.black26),
                                  child: IconButton(
                                    
                                    icon:const Icon(Icons.favorite,color: Colors.red,size: 30,),
                                    onPressed: () {
                                      
                                      _userService.removeFavorite(lokasyon.id ?? "", _controller.kulId);
                                      setState(() {}); // Listeyi güncelle
                                    },
                                  ),
                                ), onTap: () {
                                _lcontroller.updateSelectedId(lokasyon.id ?? "");
                                Get.to(()=>const LokasyonDetayView());
                              },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class UserCommentView extends StatefulWidget {
  const UserCommentView({super.key});

  @override
  State<UserCommentView> createState() => _UserCommentViewState();
}

class _UserCommentViewState extends State<UserCommentView> {
  final LocationsService _lservice = LocationsService();
  final YorumlarService _yservice = YorumlarService();
  final UserController _uController = Get.put(UserController());
  
  void showDeleteConfig(String commentId){
    showDialog(context: context, builder:(BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Process"),
        content: const Text("Are you sure delete this comment?"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: Text("No",style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue))),
          TextButton(onPressed: () async{
            await deleteComment(commentId);
            Get.back();
          }, child: Text("Yes",style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),))
        ],
      );
    });
  }
  Future<void> deleteComment (String commentId) async{
    final response = await http.delete(Uri.parse('http://10.0.2.2:3000/Yorumlar/$commentId'));
    if(response.statusCode == 200 || response.statusCode == 201){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This comment delete successfully")));
     setState(() {
       
     });
    }
    else
    {
      
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Error :${response.statusCode}")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text("My Comments"),
      ),
      body: FutureBuilder(
        future: _yservice.yorumlarapiCall(),
        builder: (context, yorumlarSnapshot) {
          if (yorumlarSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (yorumlarSnapshot.hasError) {
            print("Comments Error: ${yorumlarSnapshot.error}");
            return Center(child: Text("Error: ${yorumlarSnapshot.error}"));
          } else if (!yorumlarSnapshot.hasData || (yorumlarSnapshot.data as YorumlarDataModel).items.isEmpty) {
            print("Comments Data is null or empty");
            return const Center(child: Text("No comments found"));
          } else {
            final YorumlarDataModel commentData = yorumlarSnapshot.data as YorumlarDataModel;
            final List<Yorumlar> comments = commentData.items;

            print("All Comments: $comments");

            final userId = _uController.kulId.value;
            final userComments = comments.where((comment) => comment.kulId == userId).toList();

            print("User Comments: $userComments");

            if (userComments.isEmpty) {
              return const Center(child: Text("No comments found for this user"));
            }

            return FutureBuilder(
              future: _lservice.lokasyonapiCall(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Location Error: ${snapshot.error}");
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || (snapshot.data as LokasyonDataModel).items.isEmpty) {
                  print("Location Data is null or empty");
                  return const Center(child: Text("No locations found"));
                } else {
                  final LokasyonDataModel locationData = snapshot.data as LokasyonDataModel;
                  final List<Lokasyon> locations = locationData.items;

                  print("All Locations: $locations");

                  return ListView.builder(
                    itemCount: userComments.length,
                    itemBuilder: (context, index) {
                      final yorum = userComments[index];
                      final location = locations.firstWhere(
                        (loc) => loc.id == yorum.lokasyonId,
                       
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.grey[100]),
                          child: ListTile(
                            trailing: IconButton(onPressed: (){
                               showDeleteConfig(yorum.id);
                            }, icon:const Icon(Icons.delete)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.lokasyonAdi ?? 'Unknown Location',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < (yorum.puan ?? 0) ? Icons.star : Icons.star_border,
                                      color: Colors.yellow,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            subtitle: Text(yorum.yorum!,maxLines: 5,),
                            
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}