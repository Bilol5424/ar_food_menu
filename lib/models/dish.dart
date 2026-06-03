/// A single menu item with its 3D/AR assets.
class Dish {
  final String id;
  final String name;
  final String description;
  final List<String> allergens;

  /// GLB model — used for the in-app 3D view AND Android Scene Viewer AR.
  /// TODO: replace these demo placeholders with real food scans (.glb).
  final String glbUrl;

  /// USDZ model — used by iOS Quick Look AR (optional for now).
  final String? usdzUrl;

  final String emoji;
  final int colorValue;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.allergens,
    required this.glbUrl,
    required this.emoji,
    required this.colorValue,
    this.usdzUrl,
  });
}
