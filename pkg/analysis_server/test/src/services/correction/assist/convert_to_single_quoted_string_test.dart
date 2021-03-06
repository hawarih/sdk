// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'assist_processor.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(ConvertToSingleQuotedStringTest);
  });
}

@reflectiveTest
class ConvertToSingleQuotedStringTest extends AssistProcessorTest {
  @override
  AssistKind get kind => DartAssistKind.CONVERT_TO_SINGLE_QUOTED_STRING;

  test_one_embeddedTarget() async {
    await resolveTestUnit('''
main() {
  print("a'b'c");
}
''');
    await assertNoAssistAt('"a');
  }

  test_one_enclosingTarget() async {
    await resolveTestUnit('''
main() {
  print('abc');
}
''');
    await assertNoAssistAt("'ab");
  }

  test_one_interpolation() async {
    await resolveTestUnit(r'''
main() {
  var b = 'b';
  var c = 'c';
  print("a $b-${c} d");
}
''');
    await assertHasAssistAt(r'"a $b', r'''
main() {
  var b = 'b';
  var c = 'c';
  print('a $b-${c} d');
}
''');
  }

  test_one_raw() async {
    await resolveTestUnit('''
main() {
  print(r"abc");
}
''');
    await assertHasAssistAt('"ab', '''
main() {
  print(r'abc');
}
''');
  }

  test_one_simple() async {
    await resolveTestUnit('''
main() {
  print("abc");
}
''');
    await assertHasAssistAt('"ab', '''
main() {
  print('abc');
}
''');
  }

  test_three_embeddedTarget() async {
    await resolveTestUnit('''
main() {
  print("""a''\'bc""");
}
''');
    await assertNoAssistAt('"a');
  }

  test_three_enclosingTarget() async {
    await resolveTestUnit("""
main() {
  print('''abc''');
}
""");
    await assertNoAssistAt("'ab");
  }

  test_three_interpolation() async {
    await resolveTestUnit(r'''
main() {
  var b = 'b';
  var c = 'c';
  print("""a $b-${c} d""");
}
''');
    await assertHasAssistAt(r'"a $b', r"""
main() {
  var b = 'b';
  var c = 'c';
  print('''a $b-${c} d''');
}
""");
  }

  test_three_raw() async {
    await resolveTestUnit('''
main() {
  print(r"""abc""");
}
''');
    await assertHasAssistAt('"ab', """
main() {
  print(r'''abc''');
}
""");
  }

  test_three_simple() async {
    await resolveTestUnit('''
main() {
  print("""abc""");
}
''');
    await assertHasAssistAt('"ab', """
main() {
  print('''abc''');
}
""");
  }
}
