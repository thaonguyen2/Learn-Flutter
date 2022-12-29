import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@freezed
class Person with _$Person {
  const Person._();

  const factory Person({
    required String name,
    required int age,
  }) = _Person;
}

void test2() {
  final person = Person(name: 'name', age: 2);
  final person2 = person.copyWith(name: 'hi');
}

// union
@freezed
class Result with _$Result {
  const Result._();
  const factory Result.loading() = _Loading;
  const factory Result.success(int value) = _Success;
  const factory Result.error(String errorMessage) = _Failure;
}

void testUnion() {
  const resultSuccess = Result.success(100);
  print(
    resultSuccess.when(loading: () {
      return 'Wait, loading...';
    }, success: (value) {
      return 'Yes, data gotten successfully: $value';
    }, error: (message) {
      return 'Oh no, an error occured $message';
    }),
  );

  resultSuccess.maybeWhen(
      orElse: () => print('hehe'), success: (x) => print('succues'));
}
