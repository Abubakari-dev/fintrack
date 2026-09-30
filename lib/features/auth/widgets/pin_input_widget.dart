// lib/features/auth/widgets/pin_input_widget.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';

class PinInputWidget extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final int pinLength;

  const PinInputWidget({
    super.key,
    required this.onCompleted,
    this.pinLength = 4,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  String _enteredPin = '';

  void _onKeyPressed(String digit) {
    if (_enteredPin.length < widget.pinLength) {
      setState(() {
        _enteredPin += digit;
      });
      if (_enteredPin.length == widget.pinLength) {
        widget.onCompleted(_enteredPin);
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PIN dots display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.pinLength, (index) {
            final isFilled = index < _enteredPin.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.primaryAccent : Colors.transparent,
                border: Border.all(
                  color: isFilled
                      ? AppColors.primaryAccent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 2,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 40),
        // Keypad
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 72, height: 72), // Empty space
                  _buildKey('0'),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: IconButton(
                      onPressed: _onDeletePressed,
                      icon: Icon(
                        Icons.backspace_outlined,
                        color: isDark
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKey(String digit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 72,
      height: 72,
      child: ElevatedButton(
        onPressed: () => _onKeyPressed(digit),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          foregroundColor: isDark
              ? AppColors.darkPrimaryText
              : AppColors.lightPrimaryText,
          shape: const CircleBorder(),
          elevation: 0,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Text(
          digit,
          style: AppTextStyles.sectionTitle(
            context,
            isDark: isDark,
          ).copyWith(fontSize: 24),
        ),
      ),
    );
  }
}
