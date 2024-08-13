import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/extensions/list.dart';
import 'package:my_portfolio/core/extensions/string.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/provider/amplitutde.dart';

class JsonToDartScreen extends ConsumerStatefulWidget {
  const JsonToDartScreen({super.key});

  @override
  ConsumerState<JsonToDartScreen> createState() => _JsonToDartScreenState();
}

class _JsonToDartScreenState extends ConsumerState<JsonToDartScreen> {
  TextEditingController classNameController = TextEditingController();
  TextEditingController controller = TextEditingController();
  String output = "";
  late AmplitutdeProvider _amplitutdeProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _amplitutdeProvider = ref.read(amplitudeProvider);
      await _amplitutdeProvider.logStartupEvent();
      await _amplitutdeProvider.logAScreen("json_to_dart");
    });
    super.initState();
  }

  String _getConvertedClass(List<(String, String)> attributes,
      {String? className = ""}) {
    String convertedClass = "";

    className =
        (className == "" || className == null) ? "Autogenerated" : className;
    className = className.capitalize();
    convertedClass = "class $className{\n";
    convertedClass += attributes.getRawAttributes;
    convertedClass += "${attributes.getConstructor(className)}\n";
    convertedClass += "\t\t$className.fromJson(Map<String, dynamic> json) {\n";
    convertedClass += attributes.getFromJson;
    convertedClass += "\t\t}\n";
    convertedClass += "\t\tMap<String, dynamic> toJson() {\n";
    convertedClass += attributes.getToJson;
    convertedClass += "\t\t}\n";
    convertedClass += "}\n\n";
    return convertedClass;
  }

  (List<(String, String)>, List<(String, Map<String, dynamic>)>)
      getAttributesFromJson(Map<String, dynamic> parsedJson) {
    List<(String, String)> attributes = [];
    List<(String, Map<String, dynamic>)> otherJson = [];
    for (var mapEntry in parsedJson.entries) {
      if (mapEntry.value is Map<String, dynamic>) {
        otherJson.add((mapEntry.key, mapEntry.value));
        attributes.add(((mapEntry.key.capitalize()), mapEntry.key));
      } else if (mapEntry.value is List) {
        final mapList = (mapEntry.value as List);
        try {
          final value =
              mapList.map((e) => Map<String, dynamic>.from(e)).toList();
          otherJson.add((mapEntry.key, value.first));
          attributes.add(('List<${mapEntry.key.capitalize()}>', mapEntry.key));
        } catch (e) {
          final typ = mapList.first.runtimeType;
          Type type = List<String>;
          if (typ == int) {
            type = List<int>;
          } else if (typ == double) {
            type = List<double>;
          } else if (typ == bool) {
            type = List<bool>;
          }
          attributes.add(('$type', mapEntry.key));
        }
      } else {
        attributes.add(("${mapEntry.value.runtimeType}", mapEntry.key));
      }
    }
    return (attributes, otherJson);
  }

  String getOutput(List<(String, Map<String, dynamic>)> extraJson) {
    String o = "";
    if (extraJson.isNotEmpty) {
      for (var element in extraJson) {
        final (attributes, otherJson1) = getAttributesFromJson(element.$2);
        o += _getConvertedClass(attributes, className: element.$1);
        o += getOutput(otherJson1);
      }
    }
    return o;
  }

  void _convertToClass() {
    try {
      output = "";
      setState(() {});
      final parsed = jsonDecode(controller.text);
      Map<String, dynamic> parsedJson = {};
      if (parsed is List) {
        parsedJson = parsed.firstOrNull;
      }
      final (attributes, otherJson) = getAttributesFromJson(parsedJson);
      output +=
          _getConvertedClass(attributes, className: classNameController.text);
      output += getOutput(otherJson);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something wrong with the JSON, please check"),
          backgroundColor: Colors.red,
        ),
      );
      final json = {
        "error": e.toString(),
        "json": controller.text,
      };
      _amplitutdeProvider.logJsonParseError(json);
    }
  }

  static const subTitle =
      "Paste you json on the below TextField and get your generated Dart class";
  static const title = "Json to Dart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Semantics(
          label: title,
          hint: title,
          value: title,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Semantics(
              label: subTitle,
              hint: subTitle,
              value: subTitle,
              child: Text(
                subTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            return SizedBox(
                              width: constraints.maxWidth / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    label: "Textfield for entering JSON data",
                                    hint: "Textfield for entering JSON data",
                                    value: "Textfield for entering JSON data",
                                    child: TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        alignLabelWithHint: true,
                                        border: OutlineInputBorder(),
                                        labelText: "Enter Json",
                                      ),
                                      maxLines: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Semantics(
                                    label: "Textfield for entering class name",
                                    hint: "Textfield for entering class name",
                                    value: "Textfield for entering class name",
                                    child: TextField(
                                      controller: classNameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Enter class name",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Semantics(
                                      label:
                                          "Button for generating the Json to Dart output",
                                      hint:
                                          "Button for generating the Json to Dart output",
                                      value:
                                          "Button for generating the Json to Dart output",
                                      child: ElevatedButton.icon(
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  kPrimaryColor),
                                        ),
                                        onPressed: _convertToClass,
                                        icon: Icon(
                                          Icons.restore_rounded,
                                          color: Colors.grey[800],
                                        ),
                                        label: Text(
                                          "Generate Code",
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (output != "")
                          Semantics(
                            label: "Copy to clipboard button",
                            hint: "Copy to clipboard button",
                            value: "Copy to clipboard button",
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: output));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Copied to clipboard"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy),
                                ),
                              ),
                            ),
                          ),
                        Semantics(
                          label: "Generated Json to Dart output",
                          hint: "Generated Json to Dart output",
                          value: "Generated Json to Dart output",
                          child: SelectableText(output),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
