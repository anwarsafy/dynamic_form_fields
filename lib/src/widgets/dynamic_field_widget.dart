import 'package:flutter/material.dart';
import '../models/field_model.dart';
import '../models/field_type.dart';

typedef OnFieldChanged = void Function(DynamicFieldModel updatedField);

class DynamicFieldWidget extends StatefulWidget {
  final DynamicFieldModel field;
  final OnFieldChanged? onFieldChanged;
  final bool showFieldType;
  final InputDecoration? inputDecoration;
  final ButtonStyle? addOptionButtonStyle;
  final Widget? customOptionWidget;

  const DynamicFieldWidget({
    Key? key,
    required this.field,
    this.onFieldChanged,
    this.showFieldType = true,
    this.inputDecoration,
    this.addOptionButtonStyle,
    this.customOptionWidget,
  }) : super(key: key);

  @override
  State<DynamicFieldWidget> createState() => _DynamicFieldWidgetState();
}

class _DynamicFieldWidgetState extends State<DynamicFieldWidget> {
  late TextEditingController fieldNameController;
  late List<TextEditingController> optionControllers;
  late FieldType selectedFieldType;
  late bool isRequired;
  late List<dynamic> options;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    fieldNameController = TextEditingController(text: widget.field.fieldName);
    selectedFieldType = widget.field.fieldType;
    isRequired = widget.field.isRequired;
    options = List.from(widget.field.options ?? []);
    optionControllers = options
        .map((option) => TextEditingController(text: option.toString()))
        .toList();
  }

  void _updateField() {
    final updatedField = widget.field.copyWith(
      fieldName: fieldNameController.text,
      fieldType: selectedFieldType,
      isRequired: isRequired,
      options: options,
    );
    widget.onFieldChanged?.call(updatedField);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_shouldShowOptions()) _buildOptionsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: fieldNameController,
            decoration: widget.inputDecoration?.copyWith(
                  hintText: 'Field Name',
                ) ??
                InputDecoration(
                  hintText: 'Field Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            onChanged: (_) => _updateField(),
          ),
        ),
        if (widget.showFieldType) ...[
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<FieldType>(
              value: selectedFieldType,
              items: FieldType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.value),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFieldType = value;
                    if (_shouldShowOptions()) {
                      _resetOptions();
                    }
                    _updateField();
                  });
                }
              },
              decoration: widget.inputDecoration?.copyWith(
                    hintText: 'Field Type',
                  ) ??
                  InputDecoration(
                    hintText: 'Field Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
            ),
          ),
        ],
      ],
    );
  }

  bool _shouldShowOptions() {
    return [
      FieldType.dropDown,
      FieldType.multiDropDown,
      FieldType.checkbox,
      FieldType.radio,
    ].contains(selectedFieldType);
  }

  Widget _buildOptionsSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        ...List.generate(
          options.length,
          (index) => _buildOptionItem(index),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          style: widget.addOptionButtonStyle,
          onPressed: _addOption,
          child: const Text('Add Option'),
        ),
      ],
    );
  }

  Widget _buildOptionItem(int index) {
    if (widget.customOptionWidget != null) {
      return widget.customOptionWidget!;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: optionControllers[index],
              decoration: widget.inputDecoration?.copyWith(
                    hintText: 'Option ${index + 1}',
                  ) ??
                  InputDecoration(
                    hintText: 'Option ${index + 1}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              onChanged: (value) {
                options[index] = value;
                _updateField();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeOption(index),
          ),
        ],
      ),
    );
  }

  void _addOption() {
    setState(() {
      options.add('');
      optionControllers.add(TextEditingController());
      _updateField();
    });
  }

  void _removeOption(int index) {
    setState(() {
      options.removeAt(index);
      optionControllers[index].dispose();
      optionControllers.removeAt(index);
      _updateField();
    });
  }

  void _resetOptions() {
    setState(() {
      options.clear();
      for (var controller in optionControllers) {
        controller.dispose();
      }
      optionControllers.clear();
      _addOption();
    });
  }

  @override
  void dispose() {
    fieldNameController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
