enum FieldType {
  shortAnswer('short-answer'),
  paragraph('paragraph'),
  number('number'),
  email('email'),
  dateTime('dateTime'),
  rangeDatetime('range-dateTime'),
  multiDropDown('multi-drop-down'),
  dropDown('drop-down'),
  checkbox('checkbox'),
  radio('radio'),
  fileUpload('file-upload');

  final String value;
  const FieldType(this.value);

  static FieldType fromString(String value) {
    return FieldType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FieldType.shortAnswer,
    );
  }
}
