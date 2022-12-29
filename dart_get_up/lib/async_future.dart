import 'package:http/http.dart';

// async/await
Future<void> getPosts1() async {
  final response = await Client().get(Uri.parse('https://wapi.com/posts'));
  print(response.body);
}

// promise
void getPosts2() {
  Client()
      .get(Uri.parse('http://exp.com/api/posts'))
      .then((response) => print(response.body))
      .catchError((err) => print('error!'));
}
