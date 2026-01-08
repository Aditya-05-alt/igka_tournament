import 'package:flutter/material.dart';


class DojoFieldConfig {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  DojoFieldConfig({
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.validator,
  });
}



class DojoFormContainer extends StatelessWidget {
  final List<DojoFieldConfig> fields;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final Widget? footer;

  const DojoFormContainer({
    super.key,
    required this.fields,
    required this.submitButtonText,
    required this.onSubmit,
    this.footer,
  });

  // Common Design Constants
  static const Color _redColor = Color(0xFFD32F2F);
  static const Color _textColor = Color(0xFF1A1A1A);
  static const Color _borderColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generate 'n' number of fields dynamically
        ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _buildInputField(field),
            )),

        const SizedBox(height: 10),

        // Primary Action Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _redColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(
              submitButtonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),

        if (footer != null) ...[
          const SizedBox(height: 24),
          footer!,
        ],
      ],
    );
  }

  Widget _buildInputField(DojoFieldConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.label.toUpperCase(),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: config.controller,
          obscureText: config.isPassword,
          validator: config.validator,
          keyboardType: config.keyboardType,
          decoration: InputDecoration(
            hintText: config.hint,
            prefixIcon: Icon(config.icon, color: Colors.grey, size: 22),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _redColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ]
    );
  }
}