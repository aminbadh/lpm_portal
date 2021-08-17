class GlobalData {
  final Map<dynamic, dynamic> _data = {};

  static GlobalData instance = GlobalData._();

  GlobalData._();

  set(dynamic key, dynamic value) => _data[key] = value;

  get(dynamic key) => _data[key];
}
