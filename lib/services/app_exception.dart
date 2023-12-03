class AppException implements Exception {
  AppException([this._message, this._prefix]);

  final _message;
  final _prefix;

  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid Request');
}

class UnAuthorizedExpection extends AppException {
  UnAuthorizedExpection([String? message]) : super(message, 'Invalid request');
}

class InValidInputException extends AppException {
  InValidInputException([String? message]) : super(message, 'Invalid Input');
}
