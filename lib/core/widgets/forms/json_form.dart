import 'dart:convert';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Builds a Flutter FormBuilder form from a JSON config file.
/// Supported field types: text, email, number, password, textarea, date,
/// select (dropdown), multiselect (checkbox group), switch, checkbox, radio.
class JsonForm extends StatefulWidget {
  const JsonForm({super.key, required this.assetPath, this.onSubmit});

  final String assetPath;
  final ValueChanged<Map<String, dynamic>>? onSubmit;

  @override
  State<JsonForm> createState() => _JsonFormState();
}

class _JsonFormState extends State<JsonForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_FormConfig>(
      future: _loadConfig(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Text(
              'Failed to load form: ${snapshot.error ?? 'unknown error'}',
            ),
          );
        }

        final config = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (config.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  config.title!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            if (config.description != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  config.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            FormBuilder(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 720;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      for (final field in config.fields)
                        SizedBox(
                          width: isWide
                              ? (constraints.maxWidth / (12 / field.flex))
                                    .clamp(180, constraints.maxWidth)
                              : constraints.maxWidth,
                          child: _buildField(field),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Submit'),
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form?.saveAndValidate() ?? false) {
                    widget.onSubmit?.call(form!.value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form submitted')),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<_FormConfig> _loadConfig() async {
    final raw = await rootBundle.loadString(widget.assetPath);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return _FormConfig.fromJson(map);
  }

  Widget _buildField(_FieldConfig field) {
    final validators = _buildValidators(field.validations);
    switch (field.type) {
      case 'text':
      case 'email':
      case 'number':
      case 'password':
      case 'textarea':
        return FormBuilderTextField(
          name: field.name,
          initialValue: field.initialValue?.toString(),
          maxLines: field.type == 'textarea' ? 3 : 1,
          keyboardType: field._keyboardType,
          obscureText: field.type == 'password',
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          validator: validators,
        );
      case 'date':
        return FormBuilderDateTimePicker(
          name: field.name,
          initialValue: field.initialValue is String
              ? DateTime.tryParse(field.initialValue as String)
              : field.initialValue is int
              ? DateTime.fromMillisecondsSinceEpoch(field.initialValue as int)
              : null,
          inputType: InputType.date,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          validator: validators,
        );
      case 'select':
        return FormBuilderDropdown<String>(
          name: field.name,
          initialValue: field.initialValue?.toString(),
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          items: field.options
              .map(
                (o) => DropdownMenuItem(value: o.value, child: Text(o.label)),
              )
              .toList(),
          validator: validators,
        );
      case 'multiselect':
        return FormBuilderCheckboxGroup<String>(
          name: field.name,
          initialValue: (field.initialValue as List?)
              ?.map((e) => e.toString())
              .toList(),
          decoration: InputDecoration(labelText: field.label),
          options: field.options
              .map(
                (o) => FormBuilderFieldOption<String>(
                  value: o.value,
                  child: Text(o.label),
                ),
              )
              .toList(),
          validator: validators,
        );
      case 'radio':
        return FormBuilderRadioGroup<String>(
          name: field.name,
          initialValue: field.initialValue?.toString(),
          decoration: InputDecoration(labelText: field.label),
          options: field.options
              .map(
                (o) => FormBuilderFieldOption<String>(
                  value: o.value,
                  child: Text(o.label),
                ),
              )
              .toList(),
          validator: validators,
        );
      case 'switch':
        return FormBuilderSwitch(
          name: field.name,
          title: Text(field.label ?? field.name),
          initialValue: field.initialValue is bool
              ? field.initialValue as bool
              : false,
          validator: validators,
        );
      case 'checkbox':
        return FormBuilderCheckbox(
          name: field.name,
          initialValue: field.initialValue is bool
              ? field.initialValue as bool
              : false,
          title: Text(field.label ?? field.name),
          validator: validators,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  FormFieldValidator<dynamic>? _buildValidators(List<_ValidationRule> rules) {
    if (rules.isEmpty) return null;
    final validators = <FormFieldValidator>[];
    for (final rule in rules) {
      switch (rule.type) {
        case 'required':
          validators.add(
            (value) =>
                FormBuilderValidators.required(errorText: rule.message)(value),
          );
          break;
        case 'email':
          validators.add(
            (value) =>
                FormBuilderValidators.email(errorText: rule.message)(value),
          );
          break;
        case 'minlength':
          validators.add(
            (value) => FormBuilderValidators.minLength(
              rule.value ?? 0,
              errorText: rule.message,
            )(value),
          );
          break;
        case 'maxlength':
          validators.add(
            (value) => FormBuilderValidators.maxLength(
              rule.value ?? 9999,
              errorText: rule.message,
            )(value),
          );
          break;
        case 'min':
          validators.add(
            (value) => FormBuilderValidators.min(
              rule.value ?? 0,
              errorText: rule.message,
            )(value),
          );
          break;
        case 'max':
          validators.add(
            (value) => FormBuilderValidators.max(
              rule.value ?? 0,
              errorText: rule.message,
            )(value),
          );
          break;
        case 'regex':
          validators.add(
            (value) => FormBuilderValidators.match(
              RegExp(rule.pattern ?? ''),
              errorText: rule.message,
            )(value as String?),
          );
          break;
        default:
          break;
      }
    }
    return validators.isEmpty
        ? null
        : FormBuilderValidators.compose(validators);
  }
}

class _FormConfig {
  final String? title;
  final String? description;
  final List<_FieldConfig> fields;

  _FormConfig({this.title, this.description, required this.fields});

  factory _FormConfig.fromJson(Map<String, dynamic> json) {
    final fieldsJson = (json['fields'] as List?) ?? [];
    return _FormConfig(
      title: json['title'] as String?,
      description: json['description'] as String?,
      fields: fieldsJson
          .map((e) => _FieldConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class _FieldConfig {
  final String name;
  final String type;
  final String? label;
  final String? placeholder;
  final dynamic initialValue;
  final int flex;
  final List<_Option> options;
  final List<_ValidationRule> validations;

  _FieldConfig({
    required this.name,
    required this.type,
    required this.label,
    required this.placeholder,
    required this.initialValue,
    required this.flex,
    required this.options,
    required this.validations,
  });

  factory _FieldConfig.fromJson(Map<String, dynamic> json) {
    final rawOptions = (json['options'] as List?) ?? [];
    final rawValidations = (json['validations'] as List?) ?? [];
    return _FieldConfig(
      name: json['name'] as String,
      type: (json['type'] as String).toLowerCase(),
      label: json['label'] as String?,
      placeholder: json['placeholder'] as String?,
      initialValue: json['initialValue'],
      flex: (json['flex'] as int?) ?? 12,
      options: rawOptions
          .map((o) => _Option.fromJson(o as Map<String, dynamic>))
          .toList(),
      validations: rawValidations
          .map((v) => _ValidationRule.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  TextInputType? get _keyboardType {
    switch (type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}

class _Option {
  final String label;
  final String value;

  _Option({required this.label, required this.value});

  factory _Option.fromJson(Map<String, dynamic> json) => _Option(
    label: json['label']?.toString() ?? '',
    value: json['value']?.toString() ?? '',
  );
}

class _ValidationRule {
  final String type;
  final String? message;
  final int? value;
  final String? pattern;

  _ValidationRule({required this.type, this.message, this.value, this.pattern});

  factory _ValidationRule.fromJson(Map<String, dynamic> json) =>
      _ValidationRule(
        type: (json['type'] as String).toLowerCase(),
        message: json['message'] as String?,
        value: json['value'] as int?,
        pattern: json['pattern'] as String?,
      );
}
