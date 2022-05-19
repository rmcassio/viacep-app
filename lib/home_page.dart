// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:via_cep_app/endereco.dart';

enum EscolherOpcao { cep, endereco }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController txtcep = TextEditingController();
TextEditingController txtendereco = TextEditingController();
TextEditingController txtuf = TextEditingController();
TextEditingController txtcidade = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  EscolherOpcao? _opcao;
  bool _enderecoSelected = false;
  List<Endereco> myAllData = [];

  @override
  void initState() {
    super.initState();
    !_enderecoSelected ? getCep() : getEndereco();
  }

  void getCep() async {
    myAllData.clear();
    String cepValue = txtcep.text;
    String url = 'http://viacep.com.br/ws/$cepValue/json/';
    final response = await http.get(Uri.parse(url));
    Endereco.fromJson(jsonDecode(response.body));
    myAllData.add;

    setState(() {});
  }

  void getEndereco() async {
    myAllData.clear();
    String ufValue = txtuf.text.toUpperCase();
    String cidadeValue = txtcidade.text.toLowerCase();
    String enderecoValue = txtendereco.text.toLowerCase();
    String urlEndereco =
        'http://viacep.com.br/ws/$ufValue/$cidadeValue/$enderecoValue/json/';

    final response = await http.get(Uri.parse(urlEndereco));
    Endereco.fromJson(jsonDecode(response.body)) as List;

    myAllData.add(Endereco.fromJson(jsonDecode(response.body)));

    setState(() {});
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
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            RadioListTile(
              title: const Text('Consulta por CEP'),
              value: EscolherOpcao.cep,
              groupValue: _opcao,
              onChanged: handleSelection,
            ),
            RadioListTile(
              title: const Text('Consulta por Endereço'),
              value: EscolherOpcao.endereco,
              groupValue: _opcao,
              onChanged: handleSelection,
            ),
            !_enderecoSelected
                ? TextField(
                    controller: txtcep,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite seu CEP',
                    ))
                : Column(
                    children: <Widget>[
                      TextField(
                        controller: txtuf,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Digite seu Estado',
                        ),
                      ),
                      Divider(),
                      TextField(
                        controller: txtcidade,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Digite sua Cidade',
                        ),
                      ),
                      const Divider(),
                      TextField(
                        controller: txtendereco,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Digite seu Logradouro',
                        ),
                      ),
                    ],
                  ),
            Divider(),
            ElevatedButton(
              onPressed: () => {
                if (!_enderecoSelected)
                  {
                    getCep(),
                  }
                else
                  {
                    getEndereco(),
                  }
              },
              child: const Text('Consultar'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myAllData.length,
                itemBuilder: (context, index) {
                  final Endereco endereco = myAllData[index];
                  return ListTile(
                    title: Text('${endereco}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
