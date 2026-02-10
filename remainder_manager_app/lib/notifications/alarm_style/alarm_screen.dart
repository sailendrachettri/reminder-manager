import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

class AlarmScreen extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onDismiss;

  const AlarmScreen({
    super.key,
    required this.title,
    required this.description,
    required this.onDismiss,
  });

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  bool _vibrating = true;
  bool _isDragging = false;

  late AnimationController _hintController;
  late Animation<double> _hintAnimation;

  static const double _sliderWidth = 300;
  static const double _knobSize = 56;

  @override
  void initState() {
    super.initState();
    _startVibration();

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _hintAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeOutCubic),
    );

    _startHintLoop();
  }

  @override
  void dispose() {
    _stopVibration();
    _hintController.dispose();
    super.dispose();
  }

  void _startHintLoop() async {
    while (mounted) {
      if (!_isDragging && _dragX == 0) {
        await _hintController.forward();
        await _hintController.reverse();
      }
      await Future.delayed(const Duration(milliseconds: 1200));
    }
  }

  void _startVibration() async {
    while (_vibrating) {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 900));
    }
  }

  void _stopVibration() => _vibrating = false;

  void _onDragUpdate(DragUpdateDetails d) {
    _isDragging = true;
    _hintController.stop();

    setState(() {
      _dragX += d.delta.dx;
      _dragX = _dragX.clamp(0, _sliderWidth - _knobSize);
    });
  }

  void _onDragEnd(_) {
    _isDragging = false;

    if (_dragX > (_sliderWidth - _knobSize) * 0.9) {
      _stopVibration();
      widget.onDismiss();
      Navigator.pop(context);
    } else {
      setState(() => _dragX = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background (iOS dark call style)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 52, 101, 161),
                  Color.fromARGB(255, 52, 101, 161),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 1),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      /// Icon / Alarm glyph
                      // Container(
                      //   width: 88,
                      //   height: 88,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     color: Colors.white.withOpacity(0.15),
                      //   ),
                      //   child: const Icon(
                      //     Icons.alarm_rounded,
                      //     size: 62,
                      //     color: Colors.white,
                      //   ),
                      // ),

                      // const SizedBox(height: 22),

                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                /// Bottom Slider
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: AnimatedBuilder(
                    animation: _hintAnimation,
                    builder: (_, __) => _buildSlider(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Center(
      child: Container(
        width: _sliderWidth,
        height: 64,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            /// Text
            Center(
              child: Opacity(
                opacity: 1 - (_dragX / (_sliderWidth - _knobSize)),
                child: const Text(
                  "slide to dismiss",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            /// Draggable Knob
            Positioned(
              left: _dragX + (_dragX == 0 ? _hintAnimation.value : 0),
              child: GestureDetector(
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: Container(
                  width: _knobSize,
                  height: _knobSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.keyboard_double_arrow_right,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
