import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_form_fields/dynamic_form_fields.dart';

void main() {
  group('DynamicFieldModel Tests', () {
    test('creates field model with default values', () {
      final field = DynamicFieldModel(index: 0);

      expect(field.fieldName, '');
      expect(field.fieldType, FieldType.shortAnswer);
      expect(field.isRequired, false);
      expect(field.options, const []);
      expect(field.index, 0);
      expect(field.id, isNotNull);
    });

    test('creates field model from json', () {
      final json = {
        'id': '123',
        'fieldName': 'Test Field',
        'fieldType': 'drop-down',
        'isRequired': true,
        'options': ['Option 1', 'Option 2'],
        'index': 1,
      };

      final field = DynamicFieldModel.fromJson(json);

      expect(field.id, '123');
      expect(field.fieldName, 'Test Field');
      expect(field.fieldType, FieldType.dropDown);
      expect(field.isRequired, true);
      expect(field.options, ['Option 1', 'Option 2']);
      expect(field.index, 1);
    });

    test('converts field model to json', () {
      final field = DynamicFieldModel(
        id: '123',
        fieldName: 'Test Field',
        fieldType: FieldType.dropDown,
        isRequired: true,
        options: const ['Option 1', 'Option 2'],
        index: 1,
      );

      final json = field.toJson();

      expect(json['id'], '123');
      expect(json['fieldName'], 'Test Field');
      expect(json['fieldType'], 'drop-down');
      expect(json['isRequired'], true);
      expect(json['options'], ['Option 1', 'Option 2']);
      expect(json['index'], 1);
    });
  });

  group('DynamicFieldWidget Tests', () {
    testWidgets('renders field widget correctly', (WidgetTester tester) async {
      final field = DynamicFieldModel(
        fieldName: 'Test Field',
        index: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicFieldWidget(
              field: field,
            ),
          ),
        ),
      );

      expect(find.text('Test Field'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows options for dropdown field type', (WidgetTester tester) async {
      final field = DynamicFieldModel(
        fieldName: 'Dropdown Field',
        fieldType: FieldType.dropDown,
        options: const ['Option 1', 'Option 2'],
        index: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicFieldWidget(
              field: field,
            ),
          ),
        ),
      );

      expect(find.text('Add Option'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });
  });

  group('DynamicFieldList Tests', () {
    testWidgets('renders list of fields', (WidgetTester tester) async {
      final fields = [
        DynamicFieldModel(
          fieldName: 'Field 1',
          index: 0,
        ),
        DynamicFieldModel(
          fieldName: 'Field 2',
          index: 1,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: DynamicFieldList(
                fields: fields,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);
      expect(find.byType(DynamicFieldWidget), findsNWidgets(2));
    });

    testWidgets('handles delete callback', (WidgetTester tester) async {
      String? deletedId;
      final fields = [
        DynamicFieldModel(
          id: '123',
          fieldName: 'Field 1',
          index: 0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: DynamicFieldList(
                fields: fields,
                onDelete: (id) {
                  deletedId = id;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(deletedId, '123');
    });
  });
}