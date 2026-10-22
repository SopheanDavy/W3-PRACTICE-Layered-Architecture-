import 'package:lms_layered_architecture_example/service/lms_system.dart';
import 'package:test/test.dart';

void addBasicData(LmsSystem lms) {
  lms.addStudent(studentId: 'S1', studentName: 'Ronan');
  lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
}

void main() {
  late LmsSystem lms;

  setUp(() => lms = LmsSystem());

  test('Task 1: add and remove courses', () {
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    expect(() => lms.addCourse(courseId: 'C1', courseName: 'Other'),
        throwsException);
    expect(() => lms.removeCourse(courseId: 'C2'), throwsException);
    lms.removeCourse(courseId: 'C1');
    expect(lms.courses, isEmpty);

    addBasicData(lms);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(() => lms.removeCourse(courseId: 'C1'), throwsException);
  });

  test('Task 2: enroll a student in a course', () {
    addBasicData(lms);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(lms.courses.single.studentIds, ['S1']);
    expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
        throwsException);
    expect(() => lms.enrollStudent(studentId: 'S2', courseId: 'C1'),
        throwsException);
    expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C2'),
        throwsException);
  });

  test('Task 3: remove a student from a course', () {
    addBasicData(lms);
    lms.addStudent(studentId: 'S2', studentName: 'Sam');
    lms.addCourse(courseId: 'C2', courseName: 'Databases');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S1', courseId: 'C2');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);
    lms.addResult(studentId: 'S1', courseId: 'C2', score: 90);
    final other = lms.addResult(studentId: 'S2', courseId: 'C1', score: 92);

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');
    expect(lms.students, hasLength(2));
    expect(lms.courses.first.studentIds, ['S2']);
    expect(lms.results.map((r) => r.id), ['R2', other.id]);
    expect(() => lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1'),
        throwsException);

    lms.removeStudent(studentId: 'S1');
    expect(lms.students.map((s) => s.id), ['S2']);
    expect(lms.courses.last.studentIds, isEmpty);
    expect(lms.results, [other]);
  });

  test('Task 4: add a result to a course', () {
    addBasicData(lms);
    expect(() => lms.addResult(studentId: 'S2', courseId: 'C1', score: 85),
        throwsException);
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C2', score: 85),
        throwsException);
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 85),
        throwsException);
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: -1),
        throwsException);
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 101),
        throwsException);
    expect(
        lms.addResult(studentId: 'S1', courseId: 'C1', score: 100).score, 100);
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 90),
        throwsException);
  });

  test('Task 5: remove a student result', () {
    addBasicData(lms);
    lms.addStudent(studentId: 'S2', studentName: 'Sam');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    final removed = lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);
    final kept = lms.addResult(studentId: 'S2', courseId: 'C1', score: 92);

    lms.removeResult(resultId: removed.id);
    expect(lms.results, [kept]);
    expect(lms.students, hasLength(2));
    expect(lms.courses.single.studentIds, ['S1', 'S2']);
    expect(() => lms.removeResult(resultId: removed.id), throwsException);
  });
}
