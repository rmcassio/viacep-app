// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum EscolherOpcao { cep, endereco }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EscolherOpcao? _opcao;
  bool _enderecoSelected = false;
  TextEditingController txtendereco = TextEditingController();
  TextEditingController txtuf = TextEditingController();
  TextEditingController txtcidade = TextEditingController();
  TextEditingController txtcep = TextEditingController();
  late String resultadoEndereco;
  late String resultado;

  Future<void> consultaCep() async {
    String cepValue = txtcep.text;

    String url = 'http://viacep.com.br/ws/${cepValue}/json/';

    http.Response response;

    response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = json.decode(response.body);

    String uf = retorno["uf"];
    String cidade = retorno["localidade"];

    String endereco = "O endereço é ${uf}, ${cidade}";

    setState(() {
      resultado = endereco;
      print(resultado);
    });
  }

  Future<void> consultaEndereco() async {
    String ufValue = txtuf.text.toUpperCase();
    String cidadeValue = txtcidade.text.toLowerCase();
    String enderecoValue = txtendereco.text.toLowerCase();
    String url =
        'http://viacep.com.br/ws/${ufValue}/${cidadeValue}/${enderecoValue}/json/';

    http.Response response;

    response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = json.decode(response.body);

    String uf1 = retorno["uf"];
    String cidade1 = retorno["localidade"];
    String cep1 = retorno["cep"];
    String logradouro1 = retorno["logradouro"];

    String endereco =
        "O endereço é ${uf1}, ${cidade1}, ${cep1}, ${logradouro1}";

    setState(() {
      resultadoEndereco = endereco;
      print(resultadoEndereco);
    });
  }

  void handleSelection(EscolherOpcao? value) {
    setState(() {
      _opcao = value;
      _enderecoSelected = value == EscolherOpcao.endereco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RadioListTile(
              title: const Text('Consulta por CEP'),
              value: EscolherOpcao.cep,
              groupValue: _opcao,
              onChanged: handleSelection,
            ),
            if (!_enderecoSelected)
              TextFormField(
                controller: txtcep,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu CEP',
                ),
              ),
            RadioListTile(
              title: const Text('Consulta por Endereço'),
              value: EscolherOpcao.endereco,
              groupValue: _opcao,
              onChanged: handleSelection,
            ),
            if (_enderecoSelected)
              Column(
                children: <Widget>[
                  TextFormField(
                    controller: txtuf,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite seu Estado',
                    ),
                  ),
                  Divider(color: Colors.white),
                  TextFormField(
                    controller: txtcidade,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite sua Cidade',
                    ),
                  ),
                  const Divider(color: Colors.white),
                  TextFormField(
                    controller: txtendereco,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite seu Logradouro',
                    ),
                  ),
                ],
              ),
            Divider(),
            !_enderecoSelected
                ? ElevatedButton(
                    onPressed: consultaCep,
                    child: const Text('Consultar'),
                  )
                : ElevatedButton(
                    onPressed: consultaEndereco,
                    child: const Text('Consultar'),
                  ),
          ],
        ),
      ),
    );
  }
}
