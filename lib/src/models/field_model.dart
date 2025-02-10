import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'field_type.dart';

/// A model representing a dynamic form field used in dynamic form fields.
///
/// This model encapsulates the properties of a form field such as its name,
/// type, whether it is required, available options for selectable fields,
/// position in the form, and additional metadata like dates or custom data.
class DynamicFieldModel extends Equatable {
  /// A unique identifier for the dynamic form field.
  final String id;

  /// The display name or label of the form field.
  final String fieldName;

  /// The type of the form field, defined by the [FieldType] enum.
  final FieldType fieldType;

  /// Whether the field is required to be filled out.
  final bool isRequired;

  /// A list of options for fields that support multiple choices (e.g., dropdowns).
  final List<dynamic>? options;

  /// The index or position of the field within the form.
  final int index;

  /// A [DateTime] value associated with the field, used for date/time inputs.
  final DateTime? dateTime;

  /// A [DateTimeRange] for fields that require a start and end date.
  final DateTimeRange? dateTimeRange;

  /// Additional data that may be associated with the field.
  final Map<String, dynamic>? additionalData;

  /// Creates a new instance of [DynamicFieldModel].
  ///
  /// If [id] is not provided, a unique identifier is generated automatically.
  /// The [fieldType] defaults to [FieldType.shortAnswer] if not specified.
  DynamicFieldModel({
    String? id,
    this.fieldName = '',
    FieldType? fieldType,
    this.isRequired = false,
    this.options = const [],
    required this.index,
    this.dateTime,
    this.dateTimeRange,
    this.additionalData,
  })  : id = id ?? const Uuid().v4(),
        fieldType = fieldType ?? FieldType.shortAnswer;

  /// Creates a new instance of [DynamicFieldModel] from a JSON map.
  ///
  /// The [json] parameter should contain keys corresponding to the model's
  /// properties. For example:
  ///
  /// ```dart
  /// {
  ///   'id': '123',
  ///   'fieldName': 'Email',
  ///   'fieldType': 'email',
  ///   'isRequired': true,
  ///   'options': [],
  ///   'index': 0,
  ///   'dateTime': '2025-02-10T19:00:00.000',
  ///   'startDate': '2025-02-10T00:00:00.000',
  ///   'endDate': '2025-02-10T23:59:59.999',
  ///   'additionalData': {'key': 'value'}
  /// }
  /// ```
  factory DynamicFieldModel.fromJson(Map<String, dynamic> json) {
    return DynamicFieldModel(
      id: json['id'],
      fieldName: json['fieldName'],
      fieldType: FieldType.fromString(json['fieldType']),
      isRequired: json['isRequired'],
      options: json['options'],
      index: json['index'],
      dateTime:
      json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
      dateTimeRange: json['dateTimeRange'] != null
          ? DateTimeRange(
        start: DateTime.parse(json['startDate']),
        end: DateTime.parse(json['endDate']),
      )
          : null,
      additionalData: json['additionalData'],
    );
  }

  /// Converts the [DynamicFieldModel] instance into a JSON map.
  ///
  /// Returns a map containing keys and values corresponding to the model's properties.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fieldName': fieldName,
      'fieldType': fieldType.value,
      'isRequired': isRequired,
      'options': options,
      'index': index,
      'dateTime': dateTime?.toIso8601String(),
      'startDate': dateTimeRange?.start.toIso8601String(),
      'endDate': dateTimeRange?.end.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  /// Creates a copy of this [DynamicFieldModel] with the given fields replaced by new values.
  ///
  /// This is useful for immutably updating the model. If a parameter is omitted,
  /// the existing value is used.
  DynamicFieldModel copyWith({
    String? fieldName,
    FieldType? fieldType,
    bool? isRequired,
    List<dynamic>? options,
    int? index,
    DateTime? dateTime,
    DateTimeRange? dateTimeRange,
    Map<String, dynamic>? additionalData,
  }) {
    return DynamicFieldModel(
      id: id,
      fieldName: fieldName ?? this.fieldName,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
      index: index ?? this.index,
      dateTime: dateTime ?? this.dateTime,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fieldName,
    fieldType,
    isRequired,
    options,
    index,
    dateTime,
    dateTimeRange,
    additionalData,
  ];
}
