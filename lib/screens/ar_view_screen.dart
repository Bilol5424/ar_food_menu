import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/dish.dart';

/// 3D + AR viewer.
///
/// - The 3D model is shown in-app (rotate/zoom with fingers).
/// - The AR button (rendered by <model-viewer>) places the dish on a real
///   surface: Scene Viewer on Android, Quick Look on iOS.
/// - Switching dishes happens here in the 3D view (bottom selector). True
///   in-AR switching is an Apple limitation — see README.
class ArViewScreen extends StatefulWidget {
  final List<Dish> dishes;
  final int initialIndex;

  const ArViewScreen({
    super.key,
    required this.dishes,
    required this.initialIndex,
  });

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen> {
  late int _index = widget.initialIndex;

  Dish get _dish => widget.dishes[_index];

  void _select(int i) {
    if (i == _index) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_dish.name)),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              // Unique key forces a reload when the dish changes.
              key: ValueKey(_dish.id),
              src: _dish.glbUrl,
              iosSrc: _dish.usdzUrl,
              alt: _dish.name,
              ar: true,
              arModes: const ['scene-viewer', 'webxr', 'quick-look'],
              arScale: ArScale.fixed,
              autoRotate: true,
              cameraControls: true,
              disableZoom: false,
              backgroundColor: const Color(0xFFF3F1F8),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Text(
              'Нажмите иконку AR (внизу-справа), чтобы поставить блюдо на стол',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            height: 96,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              itemCount: widget.dishes.length,
              itemBuilder: (context, i) {
                final d = widget.dishes[i];
                final selected = i == _index;
                final accent = Color(d.colorValue);
                return GestureDetector(
                  onTap: () => _select(i),
                  child: Container(
                    width: 76,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? accent.withOpacity(0.18)
                          : Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? accent : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(d.emoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            d.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
