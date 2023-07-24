import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:opencare/models/ProductionLog.dart';
//import 'package:opencare/services/network_status_service.dart';
import '../../models/ProductionLog.dart';
import '../../services/diohttp.dart';

//import '../../widgets/user_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../../services/network_status_service.dart';
import '../../widgets/user_card.dart';

class FeedsPage extends StatefulWidget {
  //FeedsPage({Key key, this.forgeReload}) : super(key: key);
  //bool forgeReload = false;

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var isLoading = true;
  int itemPerPage = 3;
  int pageLastLoad = 0;
  int pageNumber = 0;
  int totalSum = 0;
  NetworkStatus networkStatus = NetworkStatus.Online;
  final listUser = <Widget>[];
  List<ProductionLog> feeds2 = List.empty(growable: true);
  final textSearch = TextEditingController();
  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    totalSum = 0;
    pageNumber = 0;
    _fetchData();
  }

  void _onRefresh() async {
    setState(() {
      isLoading = true;
      pageNumber = 0;
    });
    _fetchData();
  }

  void _onLoading() async {
    print(
        "totalSum $totalSum pageNumber $pageNumber itemPerPage =$itemPerPage ${(1 + pageNumber) * itemPerPage}");
    if (totalSum > (pageNumber + 1) * itemPerPage) {
      pageNumber++;
      //_refreshController.requestLoading();
    }
    print("pageLastLoad $pageLastLoad pageNumber $pageNumber ");
    if (pageLastLoad == pageNumber) {
      print("DO NOT LOAD.......");
    } else {}
    _fetchData();
    //_refreshController.loadComplete();
  }

  Future<bool> checkIfInternetIsAvailable() async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var url =
          "${Authenticator.authority}/production_log_ajax.php?p=$pageNumber&length=$itemPerPage&s=${textSearch.text.trim()}";
      //print("Send: " + url);
      final response = await _dio
          .get(
            Uri.encodeFull(url),
            options: networkStatus == NetworkStatus.Offline
                ? buildCacheOptions(const Duration(days: 7))
                : null,
          )
          .whenComplete(() => _refreshController.loadComplete());
      //print("Data come ....");
      print(response.toString());
      if (null != response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE)) {
        // data come from cache
        print("Data come from cache--------");
      } else {
        print("data come from net");
      }

      Map<String, dynamic> map = json.decode(response.toString());
      if ((totalSum != 0 && totalSum != map["total_sum"]) ||
          (totalSum == map["total_sum"])) {
        feeds2.clear();
      }
      // print(map);
      List<dynamic> data = map["data"];
      for (var post in data) {
        //print("insert new to end$post");
        ProductionLog obj = ProductionLog.fromJson(post);
        //print("ProductionLog $obj");
        feeds2.add(obj);
      }

      // List<ProductionLog> newfeeds2 =
      //     data.map((i) => ProductionLog.fromJson(i)).toList();
      if (mounted) {
        setState(() {
          isLoading = false;
          totalSum = map["total_sum"];
          pageLastLoad = pageNumber;
        });
      }

      //feeds2.insert(newfeeds2);
      //setState(() {});

      //listUser.add(AddPost());
      // for (var i = 0; i < feeds2.length; i++) {
      //   listUser.add(UserCard(
      //     feed: feeds2[i],
      //     key: Key(feeds2[i].plogId.toString()),
      //   ));
      //   listUser.add(const SizedBox(
      //     height: 10.0,
      //   ));
      // }
    } catch (e) {
      //print(e);
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      // if (e.response != null) {
      //   print(e.response.data)
      //   print(e.response.headers)
      //   print(e.response.requestOptions)
      // } else {
      //   // Something happened in setting up or sending the request that triggered an Error
      //   print(e.requestOptions)
      //   print(e.message)
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageTitle = Padding(
      padding: EdgeInsets.only(top: 1.0, bottom: 30.0),
      child: Text(
        "Mới nhất",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 40.0,
        ),
      ),
    );
    //listUser.add(pageTitle);

    return Scaffold(
        appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  controller: textSearch,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                      prefixIcon: null,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          /* Clear the search field */
                          //print("Search press" + textSearch.text);
                          _onRefresh();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      hintText: 'Tìm kiếm...',
                      border: InputBorder.none),
                  autofocus: false,
                ),
              ),
            ),
            automaticallyImplyLeading: false),
        body: SmartRefresher(
            enablePullDown: false,
            enablePullUp: totalSum > ((pageNumber + 1) * itemPerPage),
            header: const WaterDropHeader(),
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("release to load more");
                } else {
                  body = const Text("No more Data");
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //const Text('Hey'),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: feeds2.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                            feed: feeds2[index],
                            key: Key(feeds2[index].plogId.toString()));
                      })
                ],
              ),
            )
            // ListView.builder(
            //   itemBuilder: (context, index) {
            //     return UserCard(
            //         feed: feeds2[index],
            //         key: Key(feeds2[index].plogId.toString()));
            //   },
            //   itemExtent: 100.0,
            //   itemCount: feeds2.length,
            // )
            // child: SingleChildScrollView(
            //   child: Container(
            //     color: Colors.grey.withOpacity(0.1),
            //     padding: const EdgeInsets.only(top: 40.0),
            //     width: MediaQuery.of(context).size.width,
            //     child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start, children: listUser),
            //   ),
            // ),
            ));
  }
}
