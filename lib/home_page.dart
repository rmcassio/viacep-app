// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:via_cep_app/api_cep.dart';
import 'package:via_cep_app/api_endereco.dart';
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

  Future<Endereco> futureCep;
  late Future<Endereco> futureEndereco;

  void handleSelection(EscolherOpcao? value) {
    setState(() {
      _opcao = value;
      _enderecoSelected = value == EscolherOpcao.endereco;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCep = getCep();
    futureEndereco = getEndereco();
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
            !_enderecoSelected
                ? ElevatedButton(
                    onPressed: () {},
                    child: const Text('Consultar'),
                  )
                : ElevatedButton(
                    onPressed: () {},
                    child: const Text('Consultar'),
                  ),
            !_enderecoSelected
                ? Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(15),
                      children: [
                        Column(
                          children: const [
                            Text(
                              'O resultado do cep será exibido aqui',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(15),
                      children: [
                        Column(
                          children: const [
                            Text(
                              'O resultado do endereço será exibido aqui',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
