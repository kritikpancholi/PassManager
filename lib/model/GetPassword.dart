import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Password>> GetPassword() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getInt('user_id');

    var response = await http.get(
        Uri.parse('http://192.168.43.77:5000/get_password?user_id=${user_id}'));
    print(response.body);
    if (response.statusCode == 200) {
      return parsePhotos(response.body);
    } else if (response.statusCode == 400) {
      return null;
    } else
      throw Exception('Failed to load album');
  } catch (e) {
    print(e);
  }
}

List<Password> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Password>((json) => Password.fromJson(json)).toList();
}

Future<bool> deletePassword(int id) async {
  var response = await http.delete(
    Uri.parse('http://192.168.43.77:5000/delete_password/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else
    return false;
  //return response;
}
