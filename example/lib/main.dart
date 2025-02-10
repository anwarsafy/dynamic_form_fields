import 'package:flutter/material.dart';
import 'package:dynamic_form_fields/dynamic_form_fields.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form Fields Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DynamicFieldModel> fields = [
    DynamicFieldModel(
      fieldName: 'Name',
      fieldType: FieldType.shortAnswer,
      index: 0,
    ),
    DynamicFieldModel(
      fieldName: 'Age',
      fieldType: FieldType.number,
      index: 1,
    ),
  ];

  void _printFields() {
    debugPrint('Form Fields:');
    for (var field in fields) {
      debugPrint('''
Field ID: ${field.id}
Field Name: ${field.fieldName}
Field Type: ${field.fieldType}
Is Required: ${field.isRequired}
Options: ${field.options}
Index: ${field.index}
DateTime: ${field.dateTime}
DateTimeRange: ${field.dateTimeRange}
Additional Data: ${field.additionalData}
----------------------------------------
''');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form Fields Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DynamicFieldList(
                fields: fields,
                onFieldChanged: (field) {
                  setState(() {
                    final index = fields.indexWhere((f) => f.id == field.id);
                    if (index != -1) {
                      fields[index] = field;
                    }
                  });
                },
                onDelete: (fieldId) {
                  setState(() {
                    fields.removeWhere((field) => field.id == fieldId);
                  });
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = fields.removeAt(oldIndex);
                    fields.insert(newIndex, item);
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _printFields,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            fields.add(DynamicFieldModel(
              fieldName: 'New Field',
              index: fields.length,
            ));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
