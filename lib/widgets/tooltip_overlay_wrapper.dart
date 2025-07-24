// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';

import 'tooltip_card.dart';

class TooltipOverlayWrapper extends StatefulWidget {
  final bool isLastStep;
  final TourStep step;
  final Rect targetRect;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const TooltipOverlayWrapper({
    super.key,
    required this.isLastStep,
    required this.step,
    required this.targetRect,
    required this.onNext,
    required this.onSkip,
  });

  @override
  State<TooltipOverlayWrapper> createState() => _TooltipOverlayWrapperState();
}

class _TooltipOverlayWrapperState extends State<TooltipOverlayWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.step.isLast) {
      _timer = Timer(widget.step.duration, widget.onNext);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleOutsideTap() {
    if (!widget.step.isLast) {
      widget.onNext();
    } else {
      widget.onSkip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleOutsideTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.0), // dimmed background
            ),
          ),
          TooltipCard(
            isLastStep: widget.isLastStep,
            step: widget.step,
            targetRect: widget.targetRect,
            onNext: widget.onNext,
            onSkip: widget.onSkip,
            backgroundColor: widget.step.backgroundColor,
          ),
        ],
      ),
    );
  }
}
