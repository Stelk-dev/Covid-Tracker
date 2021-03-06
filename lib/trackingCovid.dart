import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future getCovidData(String url) async {
  final data = await http.get(url);
  return convert.jsonDecode(data.body);
}

Future getCovidDataDay(String url) async {
  final data = await http.get(url);
  return convert.jsonDecode(data.body);
}
