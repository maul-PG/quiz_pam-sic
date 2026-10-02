import 'dart:math' as math;

void _requirePositive(double value, String name) {
  if (value.isNaN || value.isInfinite || value <= 0) {
    throw ArgumentError.value(
      value,
      name,
      'Nilai harus bilangan hingga dan lebih besar dari 0',
    );
  }
}

double calculatePyramidVolume(double s, double t) {
  _requirePositive(s, 's');
  _requirePositive(t, 't');
  return (1 / 3) * s * s * t;
}

double calculatePyramidSlantHeight(double s, double t) {
  _requirePositive(s, 's');
  _requirePositive(t, 't');
  final half = s / 2;
  return math.sqrt(t * t + half * half);
}

double calculatePyramidSurfaceArea(double s, double t) {
  _requirePositive(s, 's');
  _requirePositive(t, 't');
  final l = calculatePyramidSlantHeight(s, t);
  return s * s + 2 * s * l;
}

double calculatePyramidBasePerimeter(double s) {
  _requirePositive(s, 's');
  return 4 * s;
}

double calculateEquilateralArea(double a) {
  _requirePositive(a, 'a');
  return (math.sqrt(3) / 4) * a * a;
}

double calculateEquilateralPerimeter(double a) {
  _requirePositive(a, 'a');
  return 3 * a;
}

void _requireIsoscelesValid(double a, double b) {
  _requirePositive(a, 'a');
  _requirePositive(b, 'b');
  if (b >= 2 * a) {
    throw ArgumentError(
      'Segitiga sama kaki tidak valid: alas b ($b) harus kurang dari 2 * a (${2 * a})',
    );
  }
}

double calculateIsoscelesArea(double a, double b) {
  _requireIsoscelesValid(a, b);
  return (b / 4) * math.sqrt(4 * a * a - b * b);
}

double calculateIsoscelesPerimeter(double a, double b) {
  _requireIsoscelesValid(a, b);
  return 2 * a + b;
}

double calculateRightHypotenuse(double a, double b) {
  _requirePositive(a, 'a');
  _requirePositive(b, 'b');
  return math.sqrt(a * a + b * b);
}

double calculateRightArea(double a, double b) {
  _requirePositive(a, 'a');
  _requirePositive(b, 'b');
  return 0.5 * a * b;
}

double calculateRightPerimeter(double a, double b) {
  _requirePositive(a, 'a');
  _requirePositive(b, 'b');
  return a + b + calculateRightHypotenuse(a, b);
}
