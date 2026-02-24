import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum to define the text field type for automatic configuration
enum AppTextFieldType {
  /// Standard text input with auto-detected direction
  text,
  
  /// Multi-line text area with auto-detected direction
  multiline,
  
  /// Phone number input (always LTR)
  phone,
  
  /// Password input (always LTR)
  password,
  
  /// Email input (always LTR)
  email,
  
  /// Number input (always LTR)
  number,
  
  /// Search input with auto-detected direction
  search,
  
  /// Name input (follows locale direction)
  name,
}

/// A comprehensive text field widget that properly handles:
/// - RTL/LTR text direction based on content and locale
/// - Cursor positioning
/// - Text overflow
/// - Arabic and English input
/// - Material Design 3 styling
class AppTextField extends StatefulWidget {
  /// The controller for the text field
  final TextEditingController? controller;
  
  /// The type of text field (determines keyboard, direction, etc.)
  final AppTextFieldType type;
  
  /// The label text displayed above or inside the field
  final String? labelText;
  
  /// The hint text displayed when the field is empty
  final String? hintText;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Suffix icon widget (for custom suffix like password toggle)
  final Widget? suffixIcon;
  
  /// Whether the text is obscured (for passwords)
  final bool obscureText;
  
  /// Form field validator
  final String? Function(String?)? validator;
  
  /// Called when the field value changes
  final void Function(String)? onChanged;
  
  /// Called when editing is complete
  final void Function()? onEditingComplete;
  
  /// Called when the user submits
  final void Function(String)? onFieldSubmitted;
  
  /// Maximum number of lines (null = infinite for multiline)
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Maximum length of input
  final int? maxLength;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Whether the field is read-only
  final bool readOnly;
  
  /// Autofocus on mount
  final bool autofocus;
  
  /// Focus node
  final FocusNode? focusNode;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Auto-validate mode
  final AutovalidateMode? autovalidateMode;
  
  /// Content padding override
  final EdgeInsetsGeometry? contentPadding;
  
  /// Whether to show counter
  final bool showCounter;
  
  /// Error text to display
  final String? errorText;
  
  /// Helper text to display
  final String? helperText;
  
  /// Whether this is filled style
  final bool? filled;
  
  /// Fill color override
  final Color? fillColor;
  
  /// Border radius override
  final double? borderRadius;

  const AppTextField({
    super.key,
    this.controller,
    this.type = AppTextFieldType.text,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.autovalidateMode,
    this.contentPadding,
    this.showCounter = false,
    this.errorText,
    this.helperText,
    this.filled,
    this.fillColor,
    this.borderRadius,
  });

  /// Creates a phone number text field
  factory AppTextField.phone({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      type: AppTextFieldType.phone,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.phone_outlined,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
    );
  }

  /// Creates a password text field with toggle visibility
  factory AppTextField.password({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      type: AppTextFieldType.password,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.lock_outlined,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.done,
    );
  }

  /// Creates a search text field
  factory AppTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    Widget? suffixIcon,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      type: AppTextFieldType.search,
      hintText: hintText,
      prefixIcon: Icons.search,
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
    );
  }

  /// Creates a multiline text area
  factory AppTextField.multiline({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int? maxLines,
    int minLines = 3,
    int? maxLength,
    bool enabled = true,
    bool showCounter = false,
    FocusNode? focusNode,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      type: AppTextFieldType.multiline,
      labelText: labelText,
      hintText: hintText,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      showCounter: showCounter,
      focusNode: focusNode,
    );
  }

  /// Creates a name text field
  factory AppTextField.name({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
  }) {
    return AppTextField(
      key: key,
      controller: controller,
      type: AppTextFieldType.name,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.person_outline,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late bool _obscureText;
  bool _hasFocus = false;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText || widget.type == AppTextFieldType.password;
    
    // Listen to text changes for direction detection
    _controller.addListener(_onTextChanged);
  }
  
  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.removeListener(_onTextChanged);
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
  
  void _onTextChanged() {
    // Trigger rebuild to update text direction
    if (mounted) {
      setState(() {});
    }
  }
  
  /// Detects if the text starts with RTL characters
  bool _startsWithRtl(String text) {
    if (text.isEmpty) return false;
    final trimmed = text.trimLeft();
    if (trimmed.isEmpty) return false;
    
    final firstChar = trimmed[0];
    // Arabic Unicode range: U+0600 to U+06FF
    // Arabic Supplement: U+0750 to U+077F
    // Arabic Extended-A: U+08A0 to U+08FF
    // Hebrew Unicode range: U+0590 to U+05FF
    final rtlRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0590-\u05FF]');
    return rtlRegex.hasMatch(firstChar);
  }
  
  /// Gets the appropriate text direction based on content and type
  TextDirection? _getTextDirection() {
    // These types should always be LTR
    if (widget.type == AppTextFieldType.phone ||
        widget.type == AppTextFieldType.password ||
        widget.type == AppTextFieldType.email ||
        widget.type == AppTextFieldType.number) {
      return TextDirection.ltr;
    }
    
    // For other types, detect based on content
    final text = _controller.text;
    if (text.isEmpty) {
      return null; // Let the system decide based on locale
    }
    
    return _startsWithRtl(text) ? TextDirection.rtl : TextDirection.ltr;
  }
  
  /// Gets the appropriate text alignment based on content and locale
  TextAlign _getTextAlign() {
    // These types should always align left
    if (widget.type == AppTextFieldType.phone ||
        widget.type == AppTextFieldType.password ||
        widget.type == AppTextFieldType.email ||
        widget.type == AppTextFieldType.number) {
      return TextAlign.left;
    }
    
    // For other types, align based on detected direction
    final direction = _getTextDirection();
    if (direction == TextDirection.rtl) {
      return TextAlign.right;
    } else if (direction == TextDirection.ltr) {
      return TextAlign.left;
    }
    
    // If no text, align based on locale
    return TextAlign.start;
  }
  
  /// Gets the keyboard type based on field type
  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.name:
        return TextInputType.name;
      case AppTextFieldType.password:
      case AppTextFieldType.text:
      case AppTextFieldType.search:
        return TextInputType.text;
    }
  }
  
  /// Gets the max lines based on field type
  int? _getMaxLines() {
    if (widget.maxLines != null) return widget.maxLines;
    
    switch (widget.type) {
      case AppTextFieldType.multiline:
        return null; // Unlimited
      case AppTextFieldType.password:
        return 1;
      default:
        return 1;
    }
  }
  
  /// Gets input formatters based on field type
  List<TextInputFormatter> _getInputFormatters() {
    if (widget.inputFormatters != null) return widget.inputFormatters!;
    
    switch (widget.type) {
      case AppTextFieldType.phone:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
          LengthLimitingTextInputFormatter(20),
        ];
      case AppTextFieldType.number:
        return [
          FilteringTextInputFormatter.digitsOnly,
        ];
      default:
        return [];
    }
  }
  
  /// Builds the suffix icon widget
  Widget? _buildSuffixIcon() {
    // For password fields, add toggle visibility button
    if (widget.type == AppTextFieldType.password && _controller.text.isNotEmpty) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    return widget.suffixIcon;
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDirection = _getTextDirection();
    final textAlign = _getTextAlign();
    
    // Determine prefix and suffix based on text direction
    Widget? prefixIconWidget;
    if (widget.prefixIcon != null) {
      prefixIconWidget = Icon(widget.prefixIcon);
    }
    
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: Directionality(
        // For fields that should always be LTR, wrap in LTR directionality
        // but keep the label/hint in the locale direction
        textDirection: (widget.type == AppTextFieldType.phone ||
                widget.type == AppTextFieldType.password ||
                widget.type == AppTextFieldType.email ||
                widget.type == AppTextFieldType.number)
            ? TextDirection.ltr
            : Directionality.of(context),
        child: TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          keyboardType: _getKeyboardType(),
          textDirection: textDirection,
          textAlign: textAlign,
          maxLines: _getMaxLines(),
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          inputFormatters: _getInputFormatters(),
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          // Style configuration
          style: theme.textTheme.bodyLarge?.copyWith(
            // Ensure proper text rendering
            height: 1.4,
            letterSpacing: 0,
          ),
          // Handle text selection properly
          selectionControls: MaterialTextSelectionControls(),
          // Cursor configuration
          cursorColor: theme.colorScheme.primary,
          cursorWidth: 2,
          cursorRadius: const Radius.circular(1),
          // Input decoration
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: prefixIconWidget,
            suffixIcon: _buildSuffixIcon(),
            filled: widget.filled ?? true,
            fillColor: widget.fillColor,
            counterText: widget.showCounter ? null : '',
            contentPadding: widget.contentPadding ?? 
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            // Ensure hint follows the appropriate direction
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            // Floating label configuration
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: TextStyle(
              color: _hasFocus ? theme.colorScheme.primary : null,
            ),
            // Align icons properly based on locale
            alignLabelWithHint: true,
          ),
          // Scroll configuration for long text
          scrollPadding: const EdgeInsets.all(20),
          // Enable text scaling
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}

/// A simple text field without form validation capabilities
/// Useful for search bars and simple inputs
class AppSimpleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final AppTextFieldType type;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;

  const AppSimpleTextField({
    super.key,
    this.controller,
    this.type = AppTextFieldType.text,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.contentPadding,
  });

  factory AppSimpleTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hintText,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    Widget? suffixIcon,
    bool enabled = true,
    bool autofocus = false,
    FocusNode? focusNode,
  }) {
    return AppSimpleTextField(
      key: key,
      controller: controller,
      type: AppTextFieldType.search,
      hintText: hintText,
      prefixIcon: Icons.search,
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
    );
  }

  @override
  State<AppSimpleTextField> createState() => _AppSimpleTextFieldState();
}

class _AppSimpleTextFieldState extends State<AppSimpleTextField> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }
  
  @override
  void didUpdateWidget(AppSimpleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.removeListener(_onTextChanged);
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onTextChanged);
    }
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
  
  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }
  
  bool _startsWithRtl(String text) {
    if (text.isEmpty) return false;
    final trimmed = text.trimLeft();
    if (trimmed.isEmpty) return false;
    
    final firstChar = trimmed[0];
    final rtlRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0590-\u05FF]');
    return rtlRegex.hasMatch(firstChar);
  }
  
  TextDirection? _getTextDirection() {
    if (widget.type == AppTextFieldType.phone ||
        widget.type == AppTextFieldType.password ||
        widget.type == AppTextFieldType.email ||
        widget.type == AppTextFieldType.number) {
      return TextDirection.ltr;
    }
    
    final text = _controller.text;
    if (text.isEmpty) return null;
    
    return _startsWithRtl(text) ? TextDirection.rtl : TextDirection.ltr;
  }
  
  TextAlign _getTextAlign() {
    if (widget.type == AppTextFieldType.phone ||
        widget.type == AppTextFieldType.password ||
        widget.type == AppTextFieldType.email ||
        widget.type == AppTextFieldType.number) {
      return TextAlign.left;
    }
    
    final direction = _getTextDirection();
    if (direction == TextDirection.rtl) {
      return TextAlign.right;
    } else if (direction == TextDirection.ltr) {
      return TextAlign.left;
    }
    
    return TextAlign.start;
  }
  
  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDirection = _getTextDirection();
    final textAlign = _getTextAlign();
    
    Widget? prefixIconWidget;
    if (widget.prefixIcon != null) {
      prefixIconWidget = Icon(widget.prefixIcon);
    }
    
    return TextField(
      controller: _controller,
      keyboardType: _getKeyboardType(),
      textDirection: textDirection,
      textAlign: textAlign,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: theme.textTheme.bodyLarge?.copyWith(
        height: 1.4,
        letterSpacing: 0,
      ),
      cursorColor: theme.colorScheme.primary,
      cursorWidth: 2,
      cursorRadius: const Radius.circular(1),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: prefixIconWidget,
        suffixIcon: widget.suffixIcon,
        filled: true,
        contentPadding: widget.contentPadding ?? 
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      scrollPadding: const EdgeInsets.all(20),
      textAlignVertical: TextAlignVertical.center,
    );
  }
}
