import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:openlotus/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../_routing/routes.dart';
import '../utils/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/services.dart';

import 'dart:async';
//import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/utils.dart';
import '../services/diohttp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController fullname = TextEditingController();

  var status_msg = "";

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String semail = prefs.get("email").toString();
    var sfullname = prefs.get("fullname").toString();
    var spassword = prefs.get("password").toString();
    var token = prefs.get("jwt");
    try {
      if (token != null && token.toString().isNotEmpty) {
        var payload = Utils.parseJwtPayLoad(token.toString());
        setState(() {
          status_msg = "Welcome " + payload["data"]["userName"];
        });
        authenticator.setToken(token.toString());
        print("AUto login ");
        print(payload["data"]);
        //Navigator.pushNamed(context, homeViewRoute);
        user.text = semail;
        pass.text = spassword;
        fullname.text = sfullname;
      } else {}
    } catch (e) {
      print(e);
    }
    // print(token);
    return token;
  }

  void callbackLoginEasy(loginObj) {
    print("Login done...");
    if (loginObj["result"] == true) {
      setState(() {
        status_msg = loginObj["reason"];
      });
      Navigator.pushNamed(context, homeViewRoute);
    } else {
      setState(() {
        status_msg = "ĐĂNG NHẬP";
      });
    }
  }

  void callbackLogin(loginObj) {
    print("Login done...");
    setState(() {
      status_msg = loginObj["reason"];
    });
    print(loginObj);

    if (loginObj["result"] == true) {
      Navigator.pushNamed(context, homeViewRoute);
    }
  }

  Future<void> _login() async {
    setState(() {
      status_msg = "Đang đăng nhập...";
    });
    var loginObj = authenticator.login(user.text, pass.text);
    loginObj.then(callbackLogin);
  }

  Future<void> _loginEasy() async {
    var msgerror = "";
    if (user.text.length < 8) {
      msgerror += " [Số điện thoại phải 8 số] ";
    }
    if (fullname.text.length < 4) {
      fullname.text = user.text;
      //msgerror += " [Tên bạn phải có để đăng tin] ";
    }
    if (pass.text.length < 4) {
      msgerror += " [Password phải ít nhất 4 ký tự]";
    }
    if (msgerror.isNotEmpty) {
      setState(() {
        status_msg = "Có lỗi: $msgerror";
      });
      return;
    }

    setState(() {
      status_msg = "Đang đăng nhập...";
    });
    var loginObj =
        authenticator.login_easy(user.text, pass.text, fullname.text);
    loginObj.then(callbackLoginEasy);
  }

  // Future<List> _login_old() async {
  //   Response response;
  //   var reason;
  //   try {
  //     setState(() {
  //       status_msg = "Đang đăng nhập...";
  //     });
  //     Dio dio = new Dio();

  //     response =
  //         await dio.post("https://ss789.xyz/openorganic/main/api/login.php",
  //             data: FormData.fromMap({
  //               "func": "jwt",
  //               "email": user.text,
  //               "password": pass.text,
  //             }), onSendProgress: (int sent, int total) {
  //       //print("Dio send: $sent $total");
  //     });
  //     //print(response);
  //     var token = response.toString();
  //     //print(response);
  //     //reason = json.decode(response.toString())

  //     var header = Utils.parseJwtHeader(token);
  //     var payload = Utils.parseJwtPayLoad(token);
  //     // print(header);
  //     print(payload["data"]);
  //     // print(payload["data"]["userId"]);
  //     setState(() {
  //       status_msg =
  //           "Login successful...Welcome " + payload["data"]["userName"];
  //     });

  //     // Create storage
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString("jwt", token);
  //     Navigator.pushNamed(context, homeViewRoute);
  //   } catch (e) {
  //     print(e);
  //     // if (response != null) {
  //     //   var res = json.decode(response.toString());
  //     //print(res["reason"]);
  //     setState(() {
  //       //status_msg = res["reason"];
  //       status_msg = "Error $e";
  //     });
  //     // print(response);
  //     // print(json.decode(response.toString()));
  //     // }
  //   }
  //   // var datauser = json.decode(response.body);
  //   // print(datauser);
  //   // if (datauser.length == 0) {
  //   //   setState(() {
  //   //     //msg = "Login Fail";
  //   //   });
  //   // } else {
  //   //   // if (datauser[0]['level'] == 'admin') {
  //   //   //   Navigator.pushReplacementNamed(context, '/AdminPage');
  //   //   // } else if (datauser[0]['level'] == 'member') {
  //   //   //   Navigator.pushReplacementNamed(context, '/MemberPage');
  //   //   // }

  //   //   setState(() {
  //   //     //username = datauser[0]['username'];
  //   //   });
  //   // }

  //   return 0;
  // }

  @override
  Widget build(BuildContext context) {
    // Change Status Bar Color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryColor),
    );
    final logo = Container(
      height: 100.0,
      width: 100.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AvailableImages.appLogo,
          fit: BoxFit.cover,
        ),
      ),
    );

    const pageTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Open Care",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 45.0,
          ),
        ),
        Text(
          "Nhập số điện thoại và tên để dùng !",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );

    final emailField = TextFormField(
      controller: user,
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          LineIcons.phone,
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      onChanged: (text) {
        print(user.text);
      },
    );

    final passwordField = TextFormField(
      controller: pass,
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          LineIcons.lock,
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.text,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      obscureText: true,
    );

    final fullnameField = TextFormField(
      controller: fullname,
      decoration: const InputDecoration(
        labelText: 'Tên người dùng',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          LineIcons.user,
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      autofocus: false,
      keyboardType: TextInputType.text,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      obscureText: false,
    );

    final loginForm = Padding(
      padding: const EdgeInsets.only(top: 30.0),
      //padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            fullnameField,
            emailField,
            passwordField,
            Text(
              status_msg,
              style: const TextStyle(
                  height: 2,
                  //fontWeight: FontWeight.w800,
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        ),
      ),
    );

    final loginBtn = Container(
      margin: const EdgeInsets.only(top: 0.0),
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: status_msg == 'Đang đăng nhập...'
            ? null
            : () {
                _loginEasy();
              },
        // color: Colors.white,
        // shape: new RoundedRectangleBorder(
        //   borderRadius: new BorderRadius.circular(7.0),
        // ),
        child: Text(
          status_msg == 'Đang đăng nhập...' ? 'CHỜ...' : 'ĐĂNG NHẬP',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
          ),
        ),
      ),
    );

    final checkUpgraderBtn = Container(
      margin: const EdgeInsets.only(top: 0.0),
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: () async {
          bool isStoragePermission = true;
          bool isVideosPermission = true;
          bool isPhotosPermission = true;

// Only check for storage < Android 13

          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            isVideosPermission = await Permission.videos.status.isGranted;
            isPhotosPermission = await Permission.photos.status.isGranted;
          } else {
            isStoragePermission = await Permission.storage.status.isGranted;
          }

          if (androidInfo.version.sdkInt >= 33) {
            await Permission.photos.request();
            await Permission.videos.request();
          } else {
            await Permission.storage.request();
          }
          print(
              "Permision isVideosPermission=$isVideosPermission isPhotosPermission=$isPhotosPermission isStoragePermission=$isStoragePermission ");
          // EasyLoading.showToast(
          //     "$isVideosPermission $isPhotosPermission $isStoragePermission");
          if (isStoragePermission && isVideosPermission && isPhotosPermission) {
            // no worries about crash
          } else {
            // write your code here
            //print("Permision ok");
          }
        },
        child: const Text(
          'Check',
          style: TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 10.0,
          ),
        ),
      ),
    );
    final forgotPassword = Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, resetPasswordViewRoute),
        child: const Center(
          child: Text(
            'QUÊN PASSWORD?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    final newUser = Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, registerViewRoute),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   'New User?',
            //   style: TextStyle(
            //     color: Colors.white70,
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            Text(
              'Tạo mới !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(gradient: primaryGradient),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              logo,
              pageTitle,
              loginForm,
              loginBtn,
              checkUpgraderBtn,
              //forgotPassword,
              //newUser
            ],
          ),
        ),
      ),
    );
  }
}
