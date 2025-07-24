import 'package:flutter/material.dart';
import 'package:flutter_welcome_kit/core/tour_step.dart';
import 'package:flutter_welcome_kit/widgets/spotlight.dart';
import 'package:flutter_welcome_kit/widgets/tooltip_card.dart';

class TourController {
  final List<TourStep> steps;
  final BuildContext context;

  OverlayEntry? _overlayEntry;
  int _currentStepIndex = 0;

  TourController({
    required this.context,
    required this.steps,
  });

  void start() {
    _currentStepIndex = 0;
    _showStep();
  }

  void next() {
    if (_currentStepIndex < steps.length - 1) {
      _currentStepIndex++;
      _showStep();
    } else {
      end();
    }
  }

  void previous() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      _showStep();
    }
  }

  void end() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showStep() {
    _overlayEntry?.remove();

    final step = steps[_currentStepIndex];
    final renderBox = step.key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);
    final isLastStep = _currentStepIndex == steps.length - 1;

    if (renderBox == null) return;

    final target = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final inflated = target.inflate(8.0); // same padding used in Spotlight

        return Stack(
          children: [
            // 1. Fullscreen tap-blocker
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // DO NOTHING — absorb all taps
                  print('[Overlay] blocked tap');
                },
                child: const SizedBox(),
              ),
            ),

            // 2. Draw the spotlight visuals (not using real hole)
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: SpotlightPainter(
                target: inflated,
                color: const Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),

            // 3. Tap-blocker over the spotlight hole
            Positioned(
              left: inflated.left,
              top: inflated.top,
              width: inflated.width,
              height: inflated.height,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // Also block tap inside spotlight hole
                  print('[Overlay] blocked tap inside hole');
                },
                child: const SizedBox(),
              ),
            ),

            // 4. The TooltipCard that allows interaction
            TooltipCard(
              isLastStep: isLastStep,
              step: step,
              targetRect: target,
              onNext: next,
              onSkip: end,
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }
}
