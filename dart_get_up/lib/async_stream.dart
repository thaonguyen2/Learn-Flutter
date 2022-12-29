Future<void> test() async {
  final myPeriodicStream = Stream.periodic(const Duration(seconds: 1));
  final subscription = myPeriodicStream.listen((event) {
    print('A second has passed');
  });
  await Future.delayed(const Duration(seconds: 3));
  subscription.cancel();

  createMessageStream()
      .map((msg) => msg.toUpperCase())
      .where((msg) => msg.length > 5)
      .listen((event) {
    print(event);
  });
}

// stream generator
Stream<String> createMessageStream() async* {
  yield 'Hello';
  await Future.delayed(Duration(seconds: 1));
  yield 'Have you heard of...';
  await Future.delayed(Duration(seconds: 1));
  yield 'Flutter hehe';
}
