import 'package:flutter/material.dart';
import '../../dynamic_form_fields.dart';

class DynamicFieldList extends StatelessWidget {
  final List<DynamicFieldModel> fields;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final void Function(String fieldId)? onDelete;
  final void Function(DynamicFieldModel field)? onFieldChanged;
  final Widget Function(BuildContext, DynamicFieldModel)? itemBuilder;
  final ReorderItemProxyDecorator? proxyDecorator;  // Changed type here

  const DynamicFieldList({
    Key? key,
    required this.fields,
    this.onReorder,
    this.onDelete,
    this.onFieldChanged,
    this.itemBuilder,
    this.proxyDecorator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      proxyDecorator: proxyDecorator ?? defaultProxyDecorator,
      itemCount: fields.length,
      onReorder: onReorder ?? (_, __) {},
      itemBuilder: (context, index) {
        final field = fields[index];

        if (itemBuilder != null) {
          return KeyedSubtree(
            key: ValueKey(field.id),
            child: itemBuilder!(context, field),
          );
        }

        return KeyedSubtree(
          key: ValueKey(field.id),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DynamicFieldWidget(
                    field: field,
                    onFieldChanged: onFieldChanged != null
                        ? (updatedField) => onFieldChanged!(updatedField)
                        : null,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete!(field.id),
                ),
              const Icon(Icons.drag_handle),
            ],
          ),
        );
      },
    );
  }

  // Default proxy decorator function
  Widget defaultProxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0.0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }
}