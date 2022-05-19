import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:via_cep_app/endereco.dart';
import 'package:via_cep_app/home_page.dart';

String ufValue = txtuf.text.toUpperCase();
String cidadeValue = txtcidade.text.toLowerCase();
String enderecoValue = txtendereco.text.toLowerCase();
String urlEndereco =
    'http://viacep.com.br/ws/$ufValue/$cidadeValue/$enderecoValue/json/';

Future<Endereco> getEndereco() async {
  final response = await http.get(Uri.parse(urlEndereco));

  return Endereco.fromJson(jsonDecode(response.body));
}
