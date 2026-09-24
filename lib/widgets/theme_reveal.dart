import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';

/// Transición entre las dos caras: un círculo del color del nuevo tema
/// crece desde el botón hasta cubrir la pantalla, se cambia el contenido
/// por debajo y el círculo se desvanece.
class ThemeReveal extends StatefulWidget {
  const ThemeReveal({super.key, required this.child});

  final Widget child;

  static ThemeRevealState of(BuildContext context) =>
      context.findAncestorStateOfType<ThemeRevealState>()!;

  @override
  State<ThemeReveal> createState() => ThemeRevealState();
}

class ThemeRevealState extends State<ThemeReveal> with TickerProviderStateMixin {
  late final AnimationController _expand = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  Offset _origin = Offset.zero;
  Color _color = Colors.transparent;
  bool _running = false;

  /// [globalOrigin]: centro del botón en coordenadas globales.
  /// [onCovered]: se llama cuando la pantalla está totalmente cubierta
  /// (buen momento para, por ejemplo, volver arriba del todo).
  Future<void> toggle(Offset globalOrigin, {VoidCallback? onCovered}) async {
    if (_running) return;
    final controller = AppScope.read(context);
    final next = controller.mode.other;

    final box = context.findRenderObject() as RenderBox?;
    final local = box?.globalToLocal(globalOrigin) ?? globalOrigin;

    // Si el usuario prefiere menos animaciones, cambiamos sin más.
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      controller.setMode(next);
      onCovered?.call();
      return;
    }

    setState(() {
      _running = true;
      _origin = local;
      _color = Palette.forMode(next).bg;
    });
    _fade.value = 0;
    await _expand.forward(from: 0);
    if (!mounted) return;
    controller.setMode(next);
    onCovered?.call();
    await _fade.forward(from: 0);
    if (!mounted) return;
    setState(() => _running = false);
  }

  @override
  void dispose() {
    _expand.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        if (_running)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: Listenable.merge([_expand, _fade]),
                builder: (context, _) => Opacity(
                  opacity: 1 - Curves.easeOut.transform(_fade.value),
                  child: CustomPaint(
                    painter: _CirclePainter(
                      origin: _origin,
                      color: _color,
                      progress: Curves.easeInOutCubic.transform(_expand.value),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.origin, required this.color, required this.progress});

  final Offset origin;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // Distancia a la esquina más lejana = radio necesario para cubrir todo.
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    final maxRadius = corners.map((c) => (c - origin).distance).reduce(math.max);
    canvas.drawCircle(origin, maxRadius * progress, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CirclePainter old) =>
      old.progress != progress || old.color != color || old.origin != origin;
}
