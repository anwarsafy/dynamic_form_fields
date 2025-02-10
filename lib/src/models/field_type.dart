/// Represents the different types of form fields supported by the package.
///
/// This enum is used to specify the type of a dynamic form field. Each value
/// corresponds to a specific form field type (e.g., short answer, paragraph, number, etc.)
enum FieldType {
  /// Represents a short answer field.
  shortAnswer('short-answer'),

  /// Represents a paragraph text field.
  paragraph('paragraph'),

  /// Represents a numeric input field.
  number('number'),

  /// Represents an email input field.
  email('email'),

  /// Represents a field for selecting a date and time.
  dateTime('dateTime'),

  /// Represents a field for selecting a range of dates.
  rangeDatetime('range-dateTime'),

  /// Represents a field with multiple dropdown selections.
  multiDropDown('multi-drop-down'),

  /// Represents a field with a single dropdown selection.
  dropDown('drop-down'),

  /// Represents a checkbox field.
  checkbox('checkbox'),

  /// Represents a radio button field.
  radio('radio'),

  /// Represents a file upload field.
  fileUpload('file-upload');

  /// The string value associated with the form field type.
  final String value;

  /// Creates a new instance of [FieldType] with the given [value].
  const FieldType(this.value);

  /// Converts a [String] into a corresponding [FieldType].
  ///
  /// If no matching [FieldType] is found, [FieldType.shortAnswer] is returned by default.
  ///
  /// Example:
  /// ```dart
  /// FieldType type = FieldType.fromString('email');
  /// ```
  static FieldType fromString(String value) {
    return FieldType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => FieldType.shortAnswer,
    );
  }
}
