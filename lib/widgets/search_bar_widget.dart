/// A custom search bar widget for city name input.
///
/// Features a glassmorphic design with animated focus states,
/// clear button, and search submission handling.
library;

import 'package:flutter/material.dart';

/// A stylish search bar widget for entering city names.
///
/// Provides a text field with a search icon, clear button,
/// and submit callback. Adapts to the current theme.
class SearchBarWidget extends StatefulWidget {
  /// Callback triggered when the user submits a city name.
  final Function(String) onSearch;

  /// Optional initial text to populate the search field.
  final String? initialCity;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.initialCity,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCity);
    _focusNode = FocusNode();

    // Subtle scale animation on focus
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Listen for focus changes to trigger animation
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Submits the search query if the text field is not empty.
  void _onSubmit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      _focusNode.unfocus();
      widget.onSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          // Glassmorphic background
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isFocused
                ? colorScheme.primary.withValues(alpha: 0.5)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.2)),
            width: _isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: _isFocused ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _onSubmit(),
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search city...',
            hintStyle: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.grey.withValues(alpha: 0.6),
              fontSize: 16,
            ),
            // Search icon
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                Icons.search_rounded,
                color: _isFocused
                    ? colorScheme.primary
                    : (isDark ? Colors.white54 : Colors.grey),
                size: 24,
              ),
            ),
            // Clear / Submit buttons
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Clear button (shown when text exists)
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: isDark ? Colors.white38 : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                  ),
                // Search submit button
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _onSubmit,
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }
}
