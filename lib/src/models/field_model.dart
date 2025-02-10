import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'field_type.dart';

class DynamicFieldModel extends Equatable {
  final String id;
  final String fieldName;
  final FieldType fieldType;
  final bool isRequired;
  final List<dynamic>? options;
  final int index;
  final DateTime? dateTime;
  final DateTimeRange? dateTimeRange;
  final Map<String, dynamic>? additionalData;

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
