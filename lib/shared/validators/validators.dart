import 'package:loadngo/shared/validators/validator-messages.dart';

class Validator {
  static dynamic emptyField(dynamic value) {
    if (value.toString().isEmpty) {
      return ValidatorMessages.requiredField;
    }
    return null;
  }

  static dynamic emailField(dynamic value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final regExp = RegExp(pattern);

    if (value.toString().isEmpty) {
      return ValidatorMessages.requiredField;
    } else if (!regExp.hasMatch(value)) {
      return ValidatorMessages.emailField;
    }
    return null;
    // if(value.toString().)
  }

  static dynamic numberField(dynamic value) {
    const pattern = '^[0-9]*\$';

    final regExp = RegExp(pattern);

    if (value.toString().isEmpty) {
      return ValidatorMessages.requiredField;
    } else if (!regExp.hasMatch(value)) {
      return ValidatorMessages.numberField;
    }
    return null;
    // if(value.toString().)
  }
}
