import 'package:flutter/material.dart';
import '../../dynamic_form_fields.dart';

/// A widget that displays a list of dynamic form fields with support for
/// drag-and-drop reordering, deletion, and real-time field editing.
///
/// This widget renders each [DynamicFieldModel] in a reorderable list. It allows
/// for custom item building via [itemBuilder] and supports callbacks for reordering,
/// deletion, and field updates.
///
/// If [itemBuilder] is not provided, a default layout is used which displays the
/// dynamic field in a row with an optional delete button and a drag handle icon.
class DynamicFieldList extends StatelessWidget {
  /// A list of dynamic field models to display in the list.
  final List<DynamicFieldModel> fields;

  /// Callback function triggered when the user reorders the list.
  ///
  /// Receives the [oldIndex] and [newIndex] of the moved item.
  final void Function(int oldIndex, int newIndex)? onReorder;

  /// Callback function triggered when the user deletes a field.
  ///
  /// Receives the unique [fieldId] of the field to be deleted.
  final void Function(String fieldId)? onDelete;

  /// Callback function triggered when a field is updated.
  ///
  /// Receives the updated [DynamicFieldModel] instance.
  final void Function(DynamicFieldModel field)? onFieldChanged;

  /// A custom builder for rendering individual dynamic field items.
  ///
  /// If provided, this builder is used to render each field. Otherwise, a default
  /// layout is used.
  final Widget Function(BuildContext, DynamicFieldModel)? itemBuilder;

  /// A decorator function that defines how the drag proxy appears during reordering.
  ///
  /// If not provided, the [defaultProxyDecorator] is used.
  final ReorderItemProxyDecorator? proxyDecorator;

  /// Creates a new instance of [DynamicFieldList].
  ///
  /// The [fields] parameter is required and should contain the list of dynamic field models.
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
      // Uses either the provided proxyDecorator or the default one.
      proxyDecorator: proxyDecorator ?? defaultProxyDecorator,
      itemCount: fields.length,
      // If onReorder is not provided, a no-op function is used.
      onReorder: onReorder ?? (_, __) {},
      itemBuilder: (context, index) {
        final field = fields[index];

        // If a custom itemBuilder is provided, use it to build the field widget.
        if (itemBuilder != null) {
          return KeyedSubtree(
            key: ValueKey(field.id),
            child: itemBuilder!(context, field),
          );
        }

        // Default layout for each dynamic field item.
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
              // Show delete icon if onDelete callback is provided.
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete!(field.id),
                ),
              // Drag handle icon for reordering.
              const Icon(Icons.drag_handle),
            ],
          ),
        );
      },
    );
  }

  /// The default proxy decorator used during drag-and-drop reordering.
  ///
  /// This function wraps the dragged item in an [AnimatedBuilder] to allow for
  /// custom animations. The default implementation simply returns the child wrapped
  /// in a transparent [Material] widget.
  Widget defaultProxyDecorator(
      Widget child, int index, Animation<double> animation) {
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
