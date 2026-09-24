import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme.dart';

/// Una mancha de luz del aura. Posición y tamaño relativos a la pantalla.
class AuraBlob {
  const AuraBlob(this.x, this.y, this.radius, this.color, this.alpha);
  final double x, y, radius;
  final Color color;
  final double alpha; // 0..1
}

/// 🌙 Aura de la cara "código": luz mantequilla, frambuesa, burdeos y melocotón.
const darkAura = [
  AuraBlob(.78, .30, .42, Color(0xFFF3D774), .60),
  AuraBlob(.92, .70, .38, Color(0xFFE0566A), .68),
  AuraBlob(.60, .78, .34, Color(0xFF8C1C33), .86),
  AuraBlob(.70, .10, .26, Color(0xFFF6B89A), .48),
];

/// ☀️ Aura de la cara "diseño": burdeos, rosa, melocotón y mantequilla.
const lightAura = [
  AuraBlob(.80, .32, .40, Color(0xFF800020), .60),
  AuraBlob(.94, .74, .36, Color(0xFFE0566A), .68),
  AuraBlob(.62, .80, .32, Color(0xFFF3A07A), .75),
  AuraBlob(.70, .08, .26, Color(0xFFF3D774), .86),
];

/// Fondo tipo "aura": manchas de luz difuminadas que se mueven despacio,
/// siguen un poco al ratón y llevan un grano fino por encima.
class AuraBackground extends StatefulWidget {
  const AuraBackground({super.key, required this.dark, required this.child});

  final bool dark;
  final Widget child;

  @override
  State<AuraBackground> createState() => _AuraBackgroundState();
}

class _AuraClock extends ChangeNotifier {
  double t = 0;
  Offset pull = Offset.zero; // hacia dónde tira el ratón (-1..1)
  void tick() => notifyListeners();
}

class _AuraBackgroundState extends State<AuraBackground> with SingleTickerProviderStateMixin {
  final _clock = _AuraClock();
  late final Ticker _ticker = createTicker(_onTick);
  Offset _target = Offset.zero;
  ui.Image? _grain;

  @override
  void initState() {
    super.initState();
    _makeGrain();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respeta "reducir movimiento" del sistema.
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still && _ticker.isActive) {
      _ticker.stop();
    } else if (!still && !_ticker.isActive) {
      _ticker.start();
    }
  }

  /// Textura de ruido de 128×128 que se repite: el "grano" del aura.
  void _makeGrain() {
    const size = 128;
    final rnd = math.Random(7);
    final pixels = Uint8List(size * size * 4);
    for (var i = 0; i < size * size; i++) {
      final white = rnd.nextBool();
      final v = white ? 255 : 0;
      pixels[i * 4] = v;
      pixels[i * 4 + 1] = v;
      pixels[i * 4 + 2] = v;
      pixels[i * 4 + 3] = rnd.nextInt(22);
    }
    ui.decodeImageFromPixels(pixels, size, size, ui.PixelFormat.rgba8888, (image) {
      if (mounted) {
        setState(() => _grain = image);
      } else {
        image.dispose();
      }
    });
  }

  void _onTick(Duration elapsed) {
    _clock.t = elapsed.inMicroseconds / 1e6;
    _clock.pull = Offset.lerp(_clock.pull, _target, 0.04)!;
    _clock.tick();
  }

  void _onHover(PointerHoverEvent e) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.isEmpty) return;
    final size = box.size;
    _target = Offset(
      (e.localPosition.dx / size.width) * 2 - 1,
      (e.localPosition.dy / size.height) * 2 - 1,
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _clock.dispose();
    _grain?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 960;

    return MouseRegion(
      onHover: _onHover,
      onExit: (_) => _target = Offset.zero,
      child: Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _AuraPainter(
                      clock: _clock,
                      bg: p.bg,
                      blobs: widget.dark ? darkAura : lightAura,
                      screen: widget.dark,
                      strength: narrow ? .7 : 1.0,
                    ),
                  ),
                ),
              ),
              if (_grain != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: RepaintBoundary(
                      child: CustomPaint(painter: _GrainPainter(_grain!)),
                    ),
                  ),
                ),
              // Fundido inferior hacia el color de la página.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 160,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [p.bg.withValues(alpha: 0), p.bg],
                      ),
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
      ),
    );
  }
}

class _AuraPainter extends CustomPainter {
  _AuraPainter({
    required this.clock,
    required this.bg,
    required this.blobs,
    required this.screen,
    this.strength = 1,
  }) : super(repaint: clock);

  final _AuraClock clock;
  final Color bg;
  final List<AuraBlob> blobs;
  final bool screen; // oscuro: la luz se suma (screen). Claro: se tiñe (multiply).
  final double strength;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final s = math.max(size.width, size.height);
    final t = clock.t;
    final pull = clock.pull;

    canvas.save();
    canvas.clipRect(rect);
    canvas.drawRect(rect, Paint()..color = bg);

    for (var i = 0; i < blobs.length; i++) {
      final b = blobs[i];
      // Cada mancha flota a su ritmo; la primera sigue un poco más al ratón.
      final follow = i == 0 ? .10 : .04;
      final cx = b.x * size.width +
          math.sin(t * .3 + i * 1.7) * size.width * .04 +
          pull.dx * size.width * follow;
      final cy = b.y * size.height +
          math.cos(t * .25 + i * 2.1) * size.height * .05 +
          pull.dy * size.height * follow;
      final r = b.radius * s * (1 + .06 * math.sin(t * .4 + i));
      final a = (b.alpha * strength).clamp(0.0, 1.0);
      final center = Offset(cx, cy);

      canvas.drawCircle(
        center,
        r,
        Paint()
          ..blendMode = screen ? BlendMode.screen : BlendMode.multiply
          ..shader = ui.Gradient.radial(
            center,
            r,
            [
              b.color.withValues(alpha: a),
              b.color.withValues(alpha: a * .45),
              b.color.withValues(alpha: 0),
            ],
            const [0, .45, 1],
          ),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AuraPainter old) =>
      old.bg != bg || old.blobs != blobs || old.screen != screen || old.strength != strength;
}

class _GrainPainter extends CustomPainter {
  _GrainPainter(this.image);
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ImageShader(
          image,
          TileMode.repeated,
          TileMode.repeated,
          Float64List.fromList(const [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]),
        ),
    );
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.image != image;
}
