import 'package:dart_get_up/async_stream.dart';
import 'package:dart_get_up/dart_get_up.dart' as dart_get_up;
import 'package:dart_get_up/class_object.dart';

void main(List<String> arguments) {
  print('Hello world: ${dart_get_up.calculate()}!');

  String mystring = 'Hello world';
  print(mystring);
  mystring.contains('Hello');

  int myInteger = 5;
  print(myInteger.toString());
  print(myInteger.isEven);

  double myDouble = 5.5;

  num myNumber = 5;
  num myNumber2 = 5.2;

  bool myBool = true;

  dynamic mySomething = 5;
  mySomething = 'Hello';
  mySomething = true;

  var infer = "String";
  final donotReassign = 343;

  String? impossible;
  String? haveValue = 'hehe';
  print(haveValue.length);

  impossible = 'hii';
  print(impossible.length);

  int t = 5 ~/ 5;
  int u = 26;
  u ~/= 5;
  print(u);

// higher order funtion
  int plusFive(int x) {
    return x + 5;
  }

  final twicePlusFive = twice(plusFive);
  final result = twicePlusFive(3);
  print(result);

  final twicePlusFive2 = twice((x) => x + 5);
  print(twicePlusFive2(3));

  // collections
  List myList = [1, 2, 3, 4, 'hehe']; // list dynamic
  myList.length;
  final firstElement = myList[0];
  final myList2 = [1, 2, 3]; // list int
  final myList3 = [1, 2, 3, 'hje']; // list object
  List<int> myListInt = [1, 2, 3, 4];
  var myList4 = <int>[1, 2, 3, 4]; // list int

  Map<String, dynamic> myMap = {
    'name': 'Thao',
    'age': 35,
    'registered': true,
  };
  final name = myMap['name'];
  var myMap2 = <String, int>{'key1': 0, 'key2': 1};
  Map myMap3 = {'key1': 3, 'key2': 'hehe', 4: 'hic'};

  Set<int> mySet = {1, 2, 3};
  mySet.length;
  mySet.elementAt(0);
  var mySet2 = <double>{1.2, 3.4};
  Set mySet3 = {1, 'hi'};

  // collection transform
  final names = ['John', 'Jane', 'Matthew'];
  final nameLengths = names.map((e) => e.length).toList();
  final fourChars = names.where((element) => element.length == 4).toList();
  print(fourChars);

  for (var element in names) {
    print(element);
  }
  names.forEach(print);

  // if in list
  bool isSignedIn = true;
  <String>[
    'This is a fake content.',
    if (isSignedIn) 'Sign out' else 'Sign in',
  ];
  // for in list
  <String>[
    for (int i = 0; i < 5; i++) i.toString(),
    for (final number in [1, 2, 3]) number.toString(),
  ];
  // spread
  final list1 = ['Hello', 'there'];
  final list2 = ['what', 'up'];
  final combined = <String>[
    ...list1,
    ...list2,
  ];

  // Enum
  final userAccountType = AccountType.premium;
  print(userAccountType.index);
  AccountType.values[1];
  switch (userAccountType) {
    case AccountType.free:
      print('free');
      break;
    default:
      break;
  }

  // Class & objects
  User myUser = User(name: 'John Doe', photoUrl: '');
  final myUser2 = User(name: 'Jane', photoUrl: '');
  //myUser2.name = 'Jane Doe'; cannot change because it is a final field
  var user = User.withFirstLast(
      firstName: 'firstName', lastName: 'lastName', photoUrl: 'photoUrl');

  final room1 = const Room(id: 1, name: 'Room 1');
  final room2 = const Room(id: 1, name: 'Room 1');
  final room3 = Room(id: 2, name: 'Room 2');
  final room4 = Room(id: 2, name: 'Room 2');
  print(room1 == room2);
  print(room3 == room4);

  final user4 = User4('_firstName', '_lastName');
  final admin = Admin(
      specialAdminField1: 0, firstName: 'firstName', lastName: 'lastName');

  if (user4 is Admin) {
    print('user4 is an admin');
  }
  if (user4 is! Admin) {
    print('user4 is not an admin');
  }

  ChatBot bot = ChatBot(id: 1);
  bot.sendMessage('Hello');

  final hh = 'h'.duplicate();
  print(hh);

  test();
}

enum AccountType { free, premium, vip }

void namedRequiredParams(
  int positionalParam, {
  required int x,
  required double y,
  required String greeting,
}) {}

// higher order funtion
int Function(int) twice(int Function(int) f) {
  return (int x) {
    return f(f(x));
  };
}

typedef IntTransformer = int Function(int);
IntTransformer twice2(IntTransformer f) {
  return (int x) {
    return f(f(x));
  };
}
