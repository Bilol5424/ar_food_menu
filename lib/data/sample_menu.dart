import '../models/dish.dart';

/// Demo menu shown after scanning a QR (or via the "Demo menu" button).
///
/// NOTE: glbUrl values below are STABLE PUBLIC PLACEHOLDER models so the
/// AR/3D flow works out of the box. Replace each glbUrl (and later usdzUrl)
/// with a real 3D scan of the dish for production.
const List<Dish> demoMenu = [
  Dish(
    id: 'pizza-quattro-stagioni',
    name: 'Pizza Quattro Stagioni',
    description: 'Artichokes, tomatoes, basil, mushrooms & ham',
    allergens: ['Gluten', 'Mushrooms', 'Milk', 'Egg'],
    emoji: '🍕',
    colorValue: 0xFFE0533D,
    glbUrl:
        'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Avocado/glTF-Binary/Avocado.glb',
  ),
  Dish(
    id: 'risotto',
    name: 'Risotto',
    description: 'Rice, onion, mushrooms, parmigiano & oregano',
    allergens: ['Gluten', 'Mushrooms', 'Milk'],
    emoji: '🍚',
    colorValue: 0xFFCBA135,
    glbUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
  Dish(
    id: 'mediterranean-tosta',
    name: 'Mediterranean Tosta',
    description: 'Tomatoes, home toasted bread, guacamole & cream cheese',
    allergens: ['Gluten', 'Milk', 'Corn', 'Mustard'],
    emoji: '🥪',
    colorValue: 0xFF4C9A52,
    glbUrl: 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
  ),
  Dish(
    id: 'tiramisu',
    name: 'Tiramisu',
    description: 'Mascarpone, espresso, cocoa & ladyfingers',
    allergens: ['Gluten', 'Milk', 'Egg'],
    emoji: '🍰',
    colorValue: 0xFF7A4B2B,
    glbUrl: 'https://modelviewer.dev/shared-assets/models/MaterialsVariantsShoe.glb',
  ),
];
