//Register exceptions
class EmailAlreadyInUseAuthException implements Exception {}
class InvalidEmailAuthException implements Exception {}
class WeakPasswordAuthException implements Exception {}


//Login exceptions
class UserNotFoundAuthException implements Exception {}
class WrongPasswordAuthException implements Exception {}
class NeverLogInException implements Exception {}

//General authentication exceptions
class UserNotLoggedInAuthException implements Exception {}
class GenericAuthException implements Exception {}