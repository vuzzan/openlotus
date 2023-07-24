import 'package:flutter/material.dart';
import '../_routing/routes.dart';
// import '../views/chat_details.dart';
import '../views/home.dart';
// import '../views/landing.dart';
import '../views/login.dart';
import '../views/upgrader.dart';
// import '../views/register.dart';
// import '../views/reset_password.dart';
// import '../views/user_details.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case landingViewRoute:
    //   return MaterialPageRoute(builder: (context) => LoginPage());
    case homeViewRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case upgraderRoute:
      return MaterialPageRoute(builder: (context) => CheckUpgraderWidget());
    // case loginViewRoute:
    //   return MaterialPageRoute(builder: (context) => LoginPage());
    // case registerViewRoute:
    //   return MaterialPageRoute(builder: (context) => RegisterPage());
    // case resetPasswordViewRoute:
    //   return MaterialPageRoute(builder: (context) => ResetPasswordPage());
    // case chatDetailsViewRoute:
    //   return MaterialPageRoute(
    //       builder: (context) => ChatDetailsPage(userId: settings.arguments));
    // case userDetailsViewRoute:
    //   return MaterialPageRoute(
    //       builder: (context) => UserDetailsPage(userId: settings.arguments));
    //   break;
    // case createNewPost:
    //   return MaterialPageRoute(
    //       builder: (context) => UserDetailsPage(userId: settings.arguments));
    //   break;
    default:
      return MaterialPageRoute(builder: (context) => LoginPage());
  }
}
