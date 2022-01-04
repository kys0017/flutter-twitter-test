import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:twitter_test_app/TwitDataModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Twitter Test'),
        ),
        body: const TwitWidget(),
      ),
    );
  }
}

class TwitWidget extends StatefulWidget {
  const TwitWidget({Key? key}) : super(key: key);

  @override
  _TwitWidgetState createState() => _TwitWidgetState();
}

class _TwitWidgetState extends State<TwitWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _twits = <dynamic>[];
  final textFormFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        // padding: const EdgeInsets.all(20),
        // child: Column(
        children: [
          _addTwit(),
          futureBuilder(),
        ],
        // ),
      ),
      // ),
    );
  }

  Widget _addTwit() {
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        child: Text('K'),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: textFormFieldController,
                        style: TextStyle(fontSize: 18.0),
                        decoration: const InputDecoration(
                          hintText: "What's happening?",
                        ),
                      ),
                    )),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.0, right: 16.0),
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          // side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (textFormFieldController.text.isEmpty) return;
                      setState(() {
                        _twits.add({
                          'name': 'kys',
                          'twit': textFormFieldController.text
                        });
                      });

                      textFormFieldController.text = '';
                    },
                    child: const Text(
                      'Tweet',
                      style: TextStyle(
                          fontFamily: 'roboto', fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            )));
  }

  Future<List<TwitDataModel>> readJsonData() async {
    if (_twits.length == 0) {
      // read json file
      final jsonData = await rootBundle.loadString('data/data.json');
      // decode json data as list
      _twits.addAll(json.decode(jsonData) as List<dynamic>);
    }

    // map json and initialize using DataModel
    return _twits.reversed.map((e) => TwitDataModel.fromJson(e)).toList();
  }

  Widget futureBuilder() {
    return FutureBuilder(
      future: readJsonData(),
      builder: (contenxt, data) {
        if (data.hasError) {
          return Text("${data.error}");
        } else if (data.hasData) {
          var items = data.data as List<TwitDataModel>;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items == null ? 0 : items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              items[index].name.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      items[index].twit.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
