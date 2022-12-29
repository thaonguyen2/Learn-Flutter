// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta.dart';

/*
- Constructor
- Named constructor
- Factory
*/

class User {
  final String name; //= 'John Doe';
  String photoUrl; //= 'http://exp.com/abcd';

  //User(this.name, this.photoUrl);
  User({
    required this.name,
    required this.photoUrl,
  });

  /*
  User(
      {required String firstName,
      required String lastName,
      required this.photoUrl})
      : name = '$firstName $lastName';
  */
  User.withFirstLast(
      {required String firstName,
      required String lastName,
      required this.photoUrl})
      : name = '$firstName $lastName';

  bool hasLongName() {
    return name.length > 10;
  }

  // static memebers
  static void myMethod() {}
  static const int minNameLength = 3;
}

// const constructor
class Room {
  final int id;
  final String name;

  const Room({required this.id, required this.name});
}

// private property and method
class Hehe {
  int public;
  final int _private;

  Hehe(this.public, this._private);
  Hehe.namedConstructor({
    required this.public,
    required int privateParameter,
  }) : _private = privateParameter;

  void _privateMethod() {
    print(_private);
  }
}

class NonInstantiatable {
  NonInstantiatable._();
}

// class properties
class User2 {
  final String firstName;
  final String lastName;
  String? _email;

  User2({
    required this.firstName,
    required this.lastName,
    required String email,
  }) {
    this.email = email;
  }

  // fullname property
  String get fullName => '$firstName $lastName';

  // dynamic type
  get fullName2 => '$firstName $lastName';

  // get property
  String get email => _email ?? 'Email not present';
  // set property
  set email(String value) {
    if (value.contains('@')) {
      _email = value;
    } else {
      _email = null;
    }
  }
}

// equality
class User3 {
  final String firstName;
  final String lastName;

  User3({
    required this.firstName,
    required this.lastName,
  });

  @override
  bool operator ==(covariant User3 other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName && other.lastName == lastName;
  }

  @override
  int get hashCode => firstName.hashCode ^ lastName.hashCode;
}

// inheritance
class User4 {
  final String _firstName;
  final String _lastName;

  User4(this._firstName, this._lastName);

  String get fullName => '$_firstName $_lastName';

  @mustCallSuper
  void signOut() {
    print('Signing out');
  }

  // factory method
  factory User4.admin(bool admin) {
    if (admin) {
      return Admin(
        specialAdminField1: 0,
        firstName: 'firstName',
        lastName: 'lastName',
      );
    } else {
      return User4('_firstName', '_lastName');
    }
  }
}

class Admin extends User4 {
  final double specialAdminField1;
  final double specialAdminField2;

  Admin({
    required this.specialAdminField1,
    required String firstName,
    required String lastName,
  })  : specialAdminField2 = 0,
        super(firstName, lastName);

  @override
  String get fullName => 'Admin: ${super.fullName}';

  @override
  void signOut() {
    print('Performing admin-specific sign out steps');
    super.signOut();
  }
}

// abstract class
abstract class BaseUser {
  final int myInt;

  BaseUser(this.myInt);

  void myMethod();

  int get myProperty;
}

class SubUser extends BaseUser {
  SubUser(super.myInt);
  //SubUser() : super(0);

  @override
  void myMethod() {
    print('my method');
  }

  @override
  int get myProperty => throw UnimplementedError();
}

// interface
abstract class DataReader {
  dynamic readData();
}

class IntegerDataReader implements DataReader {
  @override
  readData() {
    return 12345;
  }
}

// generics
abstract class Reader<T> {
  T readData();
}

class IntDataReader implements Reader<int> {
  @override
  int readData() {
    return 0;
  }
}

class StringDataReader implements Reader<String> {
  @override
  String readData() {
    return 'hehe';
  }
}

void myMethod<T>(T arg) {}

// mixin: add method into the classes
mixin ElevatedClient {
  void sendMessage(String text) {
    print('Sending message $text');
  }
}

class Admin2 extends User4 with ElevatedClient {
  Admin2(super.firstName, super.lastName);
}

class ChatBot with ElevatedClient {
  int id;

  ChatBot({
    required this.id,
  });
}

// extensions
extension StringDuplication on String {
  String duplicate() {
    return this + this;
  }
}
