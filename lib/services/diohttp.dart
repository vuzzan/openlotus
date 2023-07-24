import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

final Authenticator authenticator = Authenticator();

class Authenticator {
  final DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());

  static const clientId = 'mobileapp_neo';
  static const clientSecret = 'secret_neo';
  static const authority = 'https://pkap.xyz/openlotus/main/api';

  static String _token = "";

  static final Dio _dio = Dio();

  String getTokenString() {
    return _token;
  }

  void setToken(String token) {
    _token = token;
  }

  Future<Map> login_easy_del(
      String user, String password, String fullname) async {
    Response response;
    var reason;
    try {
      print("Send Login Request: $user Password: $password Ten: $fullname");
      String token = user + "|" + fullname;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("jwt", token);
      //print("Login OK");
      _token = token;
      return {"result": true, "reason": "Login successful"};
    } catch (e) {
      _token = "";
      return {"result": false, "reason": "Error $e"};
    }
  }

  Future<Map> login_easy(String user, String password, String fullname) async {
    Response response;
    var reason;
    try {
      print("Send Login Request: $user Password: $password Ten: $fullname");

      response = await _dio.post("$authority/login.php",
          data: FormData.fromMap({
            "func": "jwt",
            "email": user,
            "fullname": fullname,
            "password": password,
          }), onSendProgress: (int sent, int total) {
        //print("Dio send: $sent $total");
      });
      print(response.toString());
      Map<String, dynamic> map = json.decode(response.toString());
      // print(map);
      if (map["result"] == true) {
        var token = map["jwt"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("SAVE DATA");
        prefs.setString("jwt", token);
        prefs.setString("fullname", fullname);
        prefs.setString("email", user);
        prefs.setString("password", password);
        _token = token;
        print("Login OK");
        return {"result": true, "reason": "Login successful"};
      } else {
        print("Login FAIL");
        return {"result": false, "reason": map["msg"]};
      }
    } catch (e) {
      print("Login FAIL2");
      _token = "";
      return {"result": false, "reason": "Error $e"};
    }
  }

  Future<Map> login(String user, String password) async {
    Response response;
    var reason;
    try {
      print("Send Login Request: $user Password: $password");

      response = await _dio.post(authority + "/login.php",
          data: FormData.fromMap({
            "func": "jwt",
            "email": user,
            "password": password,
          }), onSendProgress: (int sent, int total) {
        //print("Dio send: $sent $total");
      });
      var token = response.toString();
      //var header = Utils.parseJwtHeader(token);
      //var payload = Utils.parseJwtPayLoad(token);
      //print(payload);
      // Create storage
      // FlutterSecureStorage storage = FlutterSecureStorage();
      // // Write value
      // await storage.write(key: 'jwt', value: token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("jwt", token);
      print("Login OK");
      _token = token;
      return {"result": true, "reason": "Login successful"};
    } catch (e) {
      _token = "";
      return {"result": false, "reason": "Error $e"};

      //print(e);
      // if (response != null) {
      //   print(response.toString());
      //   var res = json.decode(response.toString());
      //   // print(res["reason"]);
      //   // print(response);
      //   // print(json.decode(response.toString()));
      //   return res;
      // }
    }
    _token = "";
    return {"result": false, "reason": "Error send request login"};
  }

  Future<Object> getToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var token = prefs.get("jwt");
    var token = _token;
    try {
      // var header = parseJwtHeader(token);
      var payload = Utils.parseJwtPayLoad(token);
      return payload;
    } catch (e) {
      //print(e);
    }
    return "";
  }

  Dio getApiClient() {
    print("getApiClient..");

    //token = await storage.read(key: USER_TOKEN);
    String token = _token;
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      //print('send request：path:${options.path}，baseURL:${options.baseUrl}');
      if (options.path.indexOf("?") == -1) {
        options.path = options.path + "?token=" + token;
      } else {
        options.path = options.path + "&token=" + token;
      }
      // Do something before request is sent
      options.headers["Authorization"] = "Bearer " + token;
      //options.headers["CF_Authorization"] = "Bearer " + token;
      print('Send request：path:${options.path}，baseURL:${options.baseUrl}');
      return;
    }, onError: (e, handler) {
      print(e.toString());
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      print(response.data.toString());
      // Do something with response data
      return; // continue
    }));
    _dio.interceptors.add(_dioCacheManager.interceptor);
    _dio.options.baseUrl = authority;
    return _dio;
  }
}
