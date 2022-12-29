void handle() {
  try {
    final myNumber = int.parse('hehe');
    print(myNumber);
    throw MyExeption('test');
  } on FormatException {
    print('format');
  } on MyExeption catch (e) {
    print(e);
  } catch (e) {
    print(e.toString());
  } finally {
    print('finally');
  }
}

class MyExeption implements Exception {
  final String message;

  MyExeption(this.message);
}
