class Item{
  final String? personelNo;
  final String? name;
  final String? password;
  Item({this.name,this.personelNo,this.password});

  factory Item.fromJson(Map<String,dynamic> json){
    return Item(
      name: json['name'],
      personelNo: json['personelNo'],
      password: json['password']
    );
  }
}
class AdminLogDataModel{
  final List<Item> items;

  AdminLogDataModel({required this.items});
  factory AdminLogDataModel.fromJson(List<dynamic> json){
    List<Item> itemList = json.map((i)=> Item.fromJson(i)).toList();
    return AdminLogDataModel(items: itemList);
  }
}