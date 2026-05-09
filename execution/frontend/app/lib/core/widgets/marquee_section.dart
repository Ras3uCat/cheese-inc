import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/e_colors.dart';

class MarqueeSection extends StatefulWidget {
  const MarqueeSection({super.key});

  @override
  State<MarqueeSection> createState() => _MarqueeSectionState();
}

class _MarqueeSectionState extends State<MarqueeSection> with SingleTickerProviderStateMixin {
  static const _kItems = [
    'Aged in cedar',
    'Cut to order',
    'Small-batch',
    'Stored at 54°F',
    'Wrapped in beeswax paper',
    'Tacoma, WA',
    'Est. 2019',
    'Open Wed–Sun',
  ];

  late Ticker _ticker;
  final ScrollController _scrollCtrl = ScrollController();
  double _pos = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration _) {
    _pos += 0.35;
    if (_scrollCtrl.hasClients && _scrollCtrl.position.maxScrollExtent > 0) {
      final half = _scrollCtrl.position.maxScrollExtent / 2;
      if (_pos >= half) _pos = 0;
      _scrollCtrl.jumpTo(_pos);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: EColors.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: EColors.secondary.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            for (var i = 0; i < 6; i++) ..._kItems.map((text) => _MarqueeItem(text: text)),
          ],
        ),
      ),
    );
  }
}

class _MarqueeItem extends StatelessWidget {
  const _MarqueeItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '✦',
          style: TextStyle(fontSize: 10, color: EColors.primary, decoration: TextDecoration.none),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontStyle: FontStyle.italic,
            fontSize: 15.0,
            color: EColors.onSurface,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
