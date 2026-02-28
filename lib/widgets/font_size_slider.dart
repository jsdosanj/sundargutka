import 'package:flutter/material.dart';
import '../config/constants.dart';

class FontSizeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const FontSizeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.text_fields, size: 16),
        Expanded(
          child: Slider(
            value: value,
            min: AppConstants.minFontSize,
            max: AppConstants.maxFontSize,
            divisions:
                ((AppConstants.maxFontSize - AppConstants.minFontSize) / 2)
                    .round(),
            label: '${value.round()}',
            onChanged: onChanged,
          ),
        ),
        const Icon(Icons.text_fields, size: 24),
      ],
    );
  }
}
