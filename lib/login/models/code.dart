import 'package:formz/formz.dart';

enum CodeValidationError { empty }

class Code extends FormzInput<String, CodeValidationError> {
  const Code.pure() : super.pure('');
  const Code.dirty([super.value = '']) : super.dirty();

  @override
  CodeValidationError? validator(String value) {
    // For simplicity, we are just validating the code to ensure
    //that it is not empty but in practice you can enforce
    //special character usage, length, etc...
    if (value.isEmpty) return CodeValidationError.empty;
    return null;
  }
}
