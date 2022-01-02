class Util {
  static double avg(List<dynamic> list) {
    if (list.isEmpty) return 0;
    return double.parse(
        (list.reduce((a, b) => a + b) / list.length).toStringAsFixed(1));
  }
}
