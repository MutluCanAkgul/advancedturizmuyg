import 'dart:convert';
import 'package:advancedturizmuyg/model/yorumlar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:advancedturizmuyg/model/adminLogModel.dart';
import 'package:advancedturizmuyg/model/lokasyon.dart';


class AdminDataServices{
Future<AdminLogDataModel> apiCall() async{

  final httpClient = HttpClient();
  const int maxRetries = 3;
  int retries = 0;

  while(retries < maxRetries){
    try{
      final request = await httpClient.getUrl(Uri.parse('http://10.0.2.2:3000/adminLog'));
      final repsonse = await request.close();
      if(repsonse.statusCode == 200){
        final repsoneBody = await repsonse.transform(utf8.decoder).join();
        List<dynamic> jsonRepsonse = json.decode(repsoneBody);
        return AdminLogDataModel.fromJson(jsonRepsonse);
      }
      else
      {
        throw Exception('Bir Hata oluştu : Status code ${repsonse.statusCode}');
      }
    }
    on SocketException catch (e){
      if(retries >= maxRetries -1){
        throw Exception('Bir Hata oluştu $e');
      }
      retries ++;
      await Future.delayed(const Duration(seconds: 1));
    }
    on FormatException catch (e){
      print (e);
      throw Exception('Bir Hata Oluştu : Invalid JSON Format: $e');

    }
  }
  httpClient.close();
  throw Exception('Bir Hata oluştu : Max');
}
}

class LocationsService {
  Future<LokasyonDataModel> lokasyonapiCall() async {
    final httpClient = http.Client();
    const int maxRetries = 3;
    int retries = 0;
    while (retries < maxRetries) {
      try {
        final response = await httpClient.get(Uri.parse('http://10.0.2.2:3000/Lokasyonlar'));
        if (response.statusCode == 200) {
         
          final jsonString = utf8.decode(response.bodyBytes);
          final jsonResponse = jsonDecode(jsonString);
          
          
          print("JSON Yanıtı: $jsonResponse");
          
         
            return LokasyonDataModel.fromJson(jsonResponse);
         
            
          
        } else {
          throw Exception('Bir Hata Oluştu : Durum kodu ${response.statusCode}');
        }
      } catch (e) {
        if (retries >= maxRetries - 1) {
          throw Exception('Bir hata oluştu $e');
        }
        retries++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    httpClient.close();
    throw Exception('Bir Hata Oluştu Max');
  }
}
class YorumlarService{
  Future<YorumlarDataModel> yorumlarapiCall() async{
    final httpClient = http.Client();
    const int maxRetries = 3;
    int retries = 0;
    while(retries < maxRetries){
      try{
        final response = await httpClient.get(Uri.parse('http://10.0.2.2:3000/Yorumlar'));
        if(response.statusCode == 200){
          final jsonString = utf8.decode(response.bodyBytes);
          final jsonResponse = jsonDecode(jsonString);
          print('Json Yanıtı : ${jsonResponse}');
          return YorumlarDataModel.fromJson(jsonResponse);
        }
        else{
          throw Exception('Bir Hata Oluştu : Durum Kodu ${response.statusCode}');
        }
      }
      catch (e){
        if(retries >= maxRetries -1){
          throw Exception('Bir Hata Oluştu $e');
        }
        retries++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    httpClient.close();
    throw Exception('Bir Hata Oluştu Max');
  }
}