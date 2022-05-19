import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:via_cep_app/endereco.dart';
import 'package:via_cep_app/home_page.dart';

String cepValue = txtcep.text;

String url = 'http://viacep.com.br/ws/$cepValue/json/';

Future<Endereco> getCep() async {
  final response = await http.get(Uri.parse(url));

  return Endereco.fromJson(jsonDecode(response.body));
}
