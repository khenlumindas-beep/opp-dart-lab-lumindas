import 'dart:io';

// ============================================================
// Person Class - Base class with encapsulation
// ============================================================
class Person {
  // Private fields (encapsulation)
  String _name;
  int _age;

  // Constructor
  Person(this._name, this._age);

  // Getters
  String get name => _name;
  int get age => _age;

  // Setter for age with validation (rejects negative values)
  set age(int value) {
    if (value < 0) {
      throw ArgumentError('Age cannot be negative.');
    }
    _age = value;
  }

  // introduce() method - to be overridden by subclasses
  String introduce() {
    return "Hi, I'm $_name, $_age years old.";
  }
}

// ============================================================
// Student Class - Inherits from Person
// ============================================================
class Student extends Person {
  // Private field specific to Student
  String _course;

  // Constructor
  Student(String name, int age, this._course) : super(name, age);

  // Getter for course
  String get course => _course;

  // Override introduce() to include course
  @override
  String introduce() {
    return "Hi, I'm $name, $age years old, studying $_course.";
  }
}

// ============================================================
// Teacher Class - Inherits from Person
// ============================================================
class Teacher extends Person {
  // Private field specific to Teacher
  String _subject;

  // Constructor
  Teacher(String name, int age, this._subject) : super(name, age);

  // Getter for subject
  String get subject => _subject;

  // Override introduce() to include subject
  @override
  String introduce() {
    return "Hi, I'm $name, $age years old, teaching $_subject.";
  }
}

// ============================================================
// School Class - Holds a list of Person objects (polymorphism)
// ============================================================
class School {
  // Private list of Person
  final List<Person> _people = [];

  // Add a person to the roster
  void addPerson(Person p) {
    _people.add(p);
  }

  // Loop through all people and call introduce() on each
  // The correct overridden version runs for each object
  void introduceAll() {
    for (final person in _people) {
      print(person.introduce());
    }
  }
}

// ============================================================
// Input Helper Functions with Validation
// ============================================================

/// Prompts the user for a non-empty text value.
String readNonEmptyString(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('Input cannot be empty. Please try again.');
  }
}

/// Prompts the user for a valid whole number (int).
int readValidInt(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input == null) {
      print('Invalid input. Please enter a whole number.');
      continue;
    }
    final parsed = int.tryParse(input.trim());
    if (parsed == null) {
      print('Invalid input. Please enter a whole number.');
      continue;
    }
    return parsed;
  }
}

/// Prompts the user for a non-negative age.
int readValidAge(String prompt) {
  while (true) {
    final age = readValidInt(prompt);
    if (age < 0) {
      print('Age cannot be negative. Please try again.');
      continue;
    }
    return age;
  }
}

// ============================================================
// Main Program
// ============================================================
void main() {
  print('=== School Personnel Management ===');

  final school = School();

  // --- Collect Students ---
  final studentCount = readValidInt('How many students will you add? ');
  for (var i = 1; i <= studentCount; i++) {
    print('\n-- Student #$i --');
    final name = readNonEmptyString('Name: ');
    final age = readValidAge('Age: ');
    final course = readNonEmptyString('Course: ');
    school.addPerson(Student(name, age, course));
  }

  // --- Collect Teachers ---
  final teacherCount = readValidInt('How many teachers will you add? ');
  for (var i = 1; i <= teacherCount; i++) {
    print('\n-- Teacher #$i --');
    final name = readNonEmptyString('Name: ');
    final age = readValidAge('Age: ');
    final subject = readNonEmptyString('Subject: ');
    school.addPerson(Teacher(name, age, subject));
  }

  // --- Display Roster (Polymorphism in action) ---
  print('\n=== School Roster ===');
  school.introduceAll();
}
