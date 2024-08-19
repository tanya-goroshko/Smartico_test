import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // paste url here
    final url =
        'https://libs.smartico.ai/wrapper-popup.html?label_name=ea09da99-7be3-4a25-8493-b293a179175f-5&brand_key=b82f937b&user_ext_id=200002340';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        height: 500,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(url),
          ),
          onWebViewCreated: (controller) async {
            controller.addJavaScriptHandler(
              handlerName: 'SmarticoBridge',
              callback: (value) async {
                log('value: $value');

                if (value.isNotEmpty) {
                  final map = jsonDecode(value[0] as String) as Map;

                  if (map.containsKey('bcid')) {
                    //READY_TO_BE_SHOWN
                    if (map['bcid'] == 5) {}
                  }
                }
              },
            );
          },
          onLoadStop: (controller, url) async {
            // here data from event with cid 110
            final data = '';

            await controller.evaluateJavascript(
              source: '''
                var object = $data;
                console.log(JSON.stringify(object));
                window.postMessage(object, '*');
              ''',
            );
          },
        ),
      ),
    );
  }
}
