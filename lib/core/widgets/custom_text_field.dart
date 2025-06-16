import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

// class CustomTextField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final TextEditingController? controller;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final String? Function(String?)? validator;
//   final List<TextInputFormatter>? inputFormatters;
//   final int? maxLines;
//   final int? maxLength;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final VoidCallback? onTap;
//   final bool readOnly;
//   final Function(String)? onChanged;
//   final bool autofocus;
//   final FocusNode? focusNode;
//   final EdgeInsets? contentPadding;
//   final TextCapitalization textCapitalization;
//
//   const CustomTextField({
//     Key? key,
//     this.label,
//     this.hint,
//     this.controller,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.validator,
//     this.inputFormatters,
//     this.maxLines = 1,
//     this.maxLength,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.onTap,
//     this.readOnly = false,
//     this.onChanged,
//     this.autofocus = false,
//     this.focusNode,
//     this.contentPadding,
//     this.textCapitalization = TextCapitalization.none, required TextStyle labelStyle,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null) ...[
//           Text(
//             label!,
//             style: theme.textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           validator: validator,
//           inputFormatters: inputFormatters,
//           maxLines: maxLines,
//           maxLength: maxLength,
//           readOnly: readOnly,
//           onTap: onTap,
//           onChanged: onChanged,
//           autofocus: autofocus,
//           focusNode: focusNode,
//           textCapitalization: textCapitalization,
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: theme.colorScheme.onSurface,
//           ),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSurface.withOpacity(0.5),
//             ),
//             prefixIcon: prefixIcon,
//             suffixIcon: suffixIcon,
//             contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final Function(String)? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final TextCapitalization textCapitalization;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final TextStyle? hintStyle;


  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.textCapitalization = TextCapitalization.none,
    this.labelStyle,
    this.fillColor,
    this.hintStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: labelStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),

        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          autofocus: autofocus,
          focusNode: focusNode,
          textCapitalization: textCapitalization,

          style: const TextStyle(color: AppColors.kPrimaryColor),

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: hintStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.inputBorderRadius),
            ),
            filled: fillColor != null,
            fillColor: fillColor,
          ),
        ),

      ],
    );
  }
}
