//input validators

//for login and register
bool passwordChecker(String password) {
  // atleast 8 ch, upper and lower, atleast 1 symbol

  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}$',
  );

  return passwordRegex.hasMatch(password);
}

//for register only
bool passwordMatch(String password, String passwordconfirm) {
  return password == passwordconfirm;
}

//for login and register
bool emailChecker(String email) {
  final emailRegex = RegExp(
    r'^[\w.+-]+@[\w-]+\.[\w.-]+$',
  );
  return emailRegex.hasMatch(email);
}