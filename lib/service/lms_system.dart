import '../model/course.dart';
import '../model/course_result.dart';
import '../model/student.dart';

class LmsSystem {
  final students = <Student>[];
  final courses = <Course>[];
  final results = <CourseResult>[];
  int _nextId = 1;

  void addStudent({required String studentId, required String studentName}) {
    if (students.any((s) => s.id == studentId))
      throw Exception('Student exists');
    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    _student(studentId);
    students.removeWhere((s) => s.id == studentId);
    for (final c in courses) {
      c.studentIds.remove(studentId);
    }
    results.removeWhere((r) => r.studentId == studentId);
  }

  // Task 1 — Add and remove courses
  void addCourse({required String courseId, required String courseName}) {
    if (courses.any((c) => c.id == courseId)) throw Exception('Course exists');
    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    final c = _course(courseId);
    if (c.studentIds.isNotEmpty || results.any((r) => r.courseId == courseId)) {
      throw Exception('Course still has student data');
    }
    courses.remove(c);
  }

  // Task 2 — Enroll a student in a course
  void enrollStudent({required String studentId, required String courseId}) {
    _student(studentId);
    final c = _course(courseId);
    if (c.studentIds.contains(studentId)) throw Exception('Already enrolled');
    c.studentIds.add(studentId);
  }

  // Task 3 — Remove a student from a course
  void discardStudentFromCourse(
      {required String studentId, required String courseId}) {
    _student(studentId);
    final c = _course(courseId);
    if (!c.studentIds.remove(studentId)) throw Exception('Not enrolled');
    results
        .removeWhere((r) => r.studentId == studentId && r.courseId == courseId);
  }

  // Task 4 — Add a result to a course
  CourseResult addResult(
      {required String studentId,
      required String courseId,
      required int score}) {
    _student(studentId);
    final c = _course(courseId);
    if (!c.studentIds.contains(studentId)) throw Exception('Not enrolled');
    if (score < 0 || score > 100) throw Exception('Invalid score');
    if (results
        .any((r) => r.studentId == studentId && r.courseId == courseId)) {
      throw Exception('Result already exists');
    }
    String resultId = 'R' + _nextId.toString();
    _nextId = _nextId + 1;
    final result = CourseResult(
      id: resultId,
        studentId: studentId,
        courseId: courseId,
        score: score);
    results.add(result);
    return result;
  }

  // Task 5 — Remove a student result
  void removeResult({required String resultId}) {
    if (!results.any((r) => r.id == resultId))
      throw Exception('Result not found');
    results.removeWhere((r) => r.id == resultId);
  }

  Student _student(String id) {
    for (Student s in students) {
      if (s.id == id) return s;
    }
    throw Exception('Student not found');
  }

  Course _course(String id) {
    for (Course c in courses) {
      if (c.id == id) return c;
    }
    throw Exception('Course not found');
  }
}
