class Util {
  static double avg(List<dynamic> list) {
    return double.parse((list.reduce((a, b) => a + b) / list.length).toStringAsFixed(1));
  }
}
