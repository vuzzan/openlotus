import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openlotus/models/Comment.dart';
//import 'package:openlotus/models/feed.dart';
import 'package:openlotus/services/diohttp.dart';
import 'package:openlotus/services/utils.dart';
import '../models/ProductionLog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
// import 'package:flutter_advanced_networkimage/provider.dart';
//import 'package:flutter_advanced_networkimage/transition.dart';
//import 'package:flutter_advanced_networkimage/zoomable.dart';

// List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
//   const StaggeredTile.count(2, 2),
//   const StaggeredTile.count(2, 1),
//   const StaggeredTile.count(1, 2),
//   const StaggeredTile.count(1, 1),
//   const StaggeredTile.count(2, 2),
//   const StaggeredTile.count(1, 2),
//   const StaggeredTile.count(1, 1),
//   const StaggeredTile.count(3, 1),
//   const StaggeredTile.count(1, 1),
//   const StaggeredTile.count(4, 1),
// ];

// List<Widget> _tiles = const <Widget>[
//   const _Example01Tile(Colors.green, Icons.widgets),
//   const _Example01Tile(Colors.lightBlue, Icons.wifi),
//   const _Example01Tile(Colors.amber, Icons.panorama_wide_angle),
//   const _Example01Tile(Colors.brown, Icons.map),
//   const _Example01Tile(Colors.deepOrange, Icons.send),
//   const _Example01Tile(Colors.indigo, Icons.airline_seat_flat),
//   const _Example01Tile(Colors.red, Icons.bluetooth),
//   const _Example01Tile(Colors.pink, Icons.battery_alert),
//   const _Example01Tile(Colors.purple, Icons.desktop_windows),
//   const _Example01Tile(Colors.blue, Icons.radio),
// ];

// ignore: must_be_immutable
class UserCard extends StatefulWidget {
  ProductionLog feed;
  UserCard({required Key key, required this.feed}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool showComment = false;
  bool isLike = false;
  List<Comment> listcomment = List<Comment>.empty(growable: true);
  var user;
  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    var u = Utils.getPayload();
    u.then((obj) {
      //print("Get user");
      //print(obj);
      setState(() {
        user = obj;
      });
    });

    setState(() {
      listcomment = List<Comment>.empty(growable: true);
    });
  }

  Widget captionText(String titleText, String subText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titleText,
              style: const TextStyle(color: Colors.black, fontSize: 24.0),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subText,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget myPhotoList(String imageUrl) {
    //print("myPhotoList imageUrl = $imageUrl");
    // return CachedNetworkImage(
    //   progressIndicatorBuilder: (context, url, progress) => Center(
    //     child: CircularProgressIndicator(
    //       value: progress.progress,
    //     ),
    //   ),
    //   imageUrl: imageUrl,
    // );
    return Container(
      decoration: const BoxDecoration(),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            //borderRadius: new BorderRadius(),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              // colorFilter:
              //     const ColorFilter.mode(Colors.red, BlendMode.colorBurn)
            ),
          ),
        ),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  // buildArrayTites(ProductionLog item) {
  //   List<StaggeredTile> ret = List<StaggeredTile>.empty(growable: true);

  //   if (item.images.length == 1) {
  //     ret.add(StaggeredTile.count(4, 4));
  //   } else if (item.images.length == 2) {
  //     ret.add(StaggeredTile.count(2, 4));
  //     ret.add(StaggeredTile.count(2, 4));
  //   } else if (item.images.length == 3) {
  //     ret.add(StaggeredTile.count(2, 2));
  //     ret.add(StaggeredTile.count(2, 3));
  //     ret.add(StaggeredTile.count(2, 1));
  //   } else if (item.images.length == 4) {
  //     ret.add(StaggeredTile.count(3, 3));
  //     ret.add(StaggeredTile.count(1, 1));
  //     ret.add(StaggeredTile.count(1, 1));
  //     ret.add(StaggeredTile.count(1, 1));
  //   } else if (item.images.length == 5) {
  //     ret.add(StaggeredTile.count(2, 2));
  //     ret.add(StaggeredTile.count(2, 2));
  //     ret.add(StaggeredTile.count(2, 2));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //   } else {
  //     ret.add(StaggeredTile.count(2, 2));
  //     ret.add(StaggeredTile.count(2, 2));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //     ret.add(StaggeredTile.count(2, 1));
  //   }

  //   return ret;
  // }

  buildStaggerHeight(ProductionLog item) {
    List<double> height = [100.0, 360.0, 360.0, 300.0, 320.0];
    if (widget.feed.images.isEmpty == true) return 10.0;
    return item.images.length <= 4 ? height[item.images.length] : 360.0;
  }

  buildArrayWidget(ProductionLog item) {
    List<Widget> ret = List<Widget>.empty(growable: true);
    if (item.images.isEmpty == false) {
      for (var img in item.images) {
        ret.add(myPhotoList("${Authenticator.authority}/${img.attachmentUrl}"));
      }
    }

    return ret;
  }

  Widget buildStagger(ProductionLog item) {
    //List<Widget> listImage = buildArrayWidget(item);
    var cellInfo = [
      [],
      [
        [4, 4]
      ],
      [
        [2, 4],
        [2, 4]
      ],
      [
        [2, 3],
        [2, 2],
        [2, 1]
      ],
      [
        [3, 3],
        [1, 1],
        [1, 1],
        [1, 1],
      ],
      [
        [2, 2],
        [2, 2],
        [2, 2],
        [1, 1],
        [1, 1],
        [1, 1],
      ],
      [
        [2, 2],
        [2, 2],
        [2, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
      ]
    ];
    List<Widget> listImage = [];
    int index = 0;
    print("Count image ${item.images.length}");
    if (item.images.isEmpty == false) {
      for (var img in item.images) {
        List<int> column =
            cellInfo[item.images.length][index % item.images.length];
        print("image $index --> $column");
        index++;
        listImage.add(StaggeredGridTile.count(
            crossAxisCellCount: column[0],
            mainAxisCellCount: column[1],
            child: myPhotoList(
                "${Authenticator.authority}/${img.attachmentUrl}")));
      }
    }
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: listImage,
    );
  }

  TextEditingController txtComment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var usernameAvatar = widget.feed.userName[0];
    return Center(
        child: Column(children: [
      const SizedBox(
        height: 20,
      ),
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        color: Colors.white,
        elevation: 6.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onLongPress: () {
            //_copy();
          },
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    widget.feed.images.isEmpty
                        ? CircleAvatar(
                            radius: 23,
                            child: Text(usernameAvatar),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "${Authenticator.authority}/${widget.feed.images[0].attachmentUrl}"),
                                    fit: BoxFit.cover)),
                          ),
                    const Spacer(),
                    Text(
                      widget.feed.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.report,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            //report_port(context, widget.feed);
                            //_bookmark();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 10.0),
                  child: Text(
                    widget.feed.content,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      //backgroundColor: Colors.blueAccent
                    ),
                  ),
                ),
                widget.feed.images.isEmpty
                    ? const SizedBox(
                        height: 5.0,
                      )
                    : buildStagger(widget.feed),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        isLike == true ? Icons.favorite : Icons.favorite_border,
                        color: Colors.pink,
                      ),
                      onPressed: isLike == true
                          ? null
                          : () {
                              _doLike(widget.feed);
                            },
                    ),
                    Text(
                      "${widget.feed.likes_count} like(s)",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    const Spacer(),
                    ButtonBar(
                      children: <Widget>[
                        InkWell(
                          child: Text(
                            "${widget.feed.comments_count!} Comments",
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            _loadComment(widget.feed);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            showComment == false
                                ? Icons.mode_comment
                                : Icons.add_comment,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            _loadComment(widget.feed);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: "Đăng comment",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: Colors.amber,
                                style: BorderStyle.solid,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                _doComment(
                                    widget.feed, _controllerComment.text);
                              },
                            ),
                          ),
                          autofocus: false,
                          cursorColor: Colors.amber,
                          style: const TextStyle(
                              height: 2.0), //increases the height of cursor
                          cursorWidth: 5.0,
                          enabled:
                              true, //dafult, makes the textfield interactive
                          controller: _controllerComment,
                          onTap: () {},
                          onSubmitted: (text) {
                            _doComment(widget.feed, text);
                          }),
                    ),
                  ],
                ),
                _showComment(widget.feed)
              ],
            ),
          ),
        ),
      )
    ]));
  }

  void report_port(BuildContext context, ProductionLog feed) {
    print(feed.actionText);
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Bỏ qua"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Báo cáo"),
      content:
          Text("Bản tin này không ổn, bạn muốn báo cáo với quản trị viên?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _doLike(ProductionLog feed) {
    //print("like me isLike=" + isLike.toString() + " " + feed.plogId.toString());
    setState(() {
      isLike = true;
      feed.likes_count =
          (int.parse(feed.likes_count.toString()) + 1).toString();
    });
  }

  final TextEditingController _controllerComment = TextEditingController();
  _loadComment(ProductionLog feed) async {
    setState(() {
      showComment = !showComment;
    });
    print("_loadComment ${feed.plogId}");
    // var response = await authenticator
    //     .getApiClient()
    //     .post(
    //       "${Authenticator.authority}/comments_ajax.php?a=load",
    //       data: FormData.fromMap({
    //         "table_name": "production_log",
    //         "table_id": feed.plogId,
    //       }),
    //       options: buildCacheOptions(const Duration(days: 7)),
    //     )
    //     .whenComplete(() {
    //   print("Load comment done");
    // });
    var response = await _dio.post(
        "${Authenticator.authority}/comments_ajax.php?a=load",
        data: FormData.fromMap({
          "table_name": "production_log",
          "table_id": feed.plogId,
        }),
        //onSendProgress: (count, total) => {print("Send : $count $total")},
        onReceiveProgress: (count, total) => {print("Recv : $count $total")});

    // print("Load comment done 2");
    print(response.toString());
    var jsonData = json.decode(response.toString());
    // print(jsonData["listcomment"]);
    listcomment.clear();
    if (jsonData["listcomment"] != null) {
      jsonData["listcomment"].forEach((data) {
        Comment obj = Comment.fromJson(data);
        listcomment.add(obj);
      });
    }

    setState(() {
      feed.comments_count = "${listcomment.length}";
    });
  }

  _showComment(ProductionLog feed) {
    // print("Comment = " + showComment.toString());
    if (showComment == false || listcomment.isEmpty) {
      //return SizedBox.shrink();
      return Container();
    }

    // print("listcomment = $listcomment");
    // print("listcomment Count = ${listcomment.length}");
    final listComment = <Widget>[];
    for (var i = 0; i < listcomment.length; i++) {
      listComment.add(Column(
        children: [
          Row(
            children: <Widget>[
              Text(
                widget.feed.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(
                flex: 5,
              ),
              Text(
                Utils.timeAgoSinceDate(listcomment[i].commentTime),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                listcomment[i].commentText,
                style: const TextStyle(fontWeight: FontWeight.normal),
              )),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: listComment,
      ),
    );
  }

  _doComment(ProductionLog feed, String comment) async {
    print("Do comment =$comment");
    if (comment.isEmpty) {
      return;
    }
    print("Do comment");
    // var response = await authenticator
    //     .getApiClient()
    //     .post(
    //       "${Authenticator.authority}/comments_ajax.php?a=add",
    //       data: FormData.fromMap({
    //         "table_name": "production_log",
    //         "table_id": feed.plogId,
    //         "comment_text": comment,
    //         "userId": user["userId"],
    //         "comment_by": user["userName"],
    //       }),
    //     )
    //     .whenComplete(() {
    //   print("Post add comment done");
    //   _controllerComment.text = "";
    // });
    var response = await _dio.post(
      "${Authenticator.authority}/comments_ajax.php?a=add",
      data: FormData.fromMap({
        "table_name": "production_log",
        "table_id": feed.plogId,
        "comment_text": comment,
        "userId": 1, //user["userId"],
        "comment_by": "neo" //user["userName"],
      }),
    );

    print(response.toString());

    var jsonData = json.decode(response.toString());
    print(jsonData["listcomment"]);
    listcomment.clear();
    jsonData["listcomment"].forEach((data) {
      Comment obj = Comment.fromJson(data);
      listcomment.add(obj);
    });
    setState(() {
      _controllerComment.text = "";
      showComment = true;
      feed.comments_count = "${listcomment.length}";
    });
  }

  submitLike(ProductionLog feed) async {
    await authenticator
        .getApiClient()
        .post("${Authenticator.authority}/comments_ajax.php?a=add", data: {
      "feed": feed,
      "userId": user["userId"],
      "userName": user["userName"],
    }).whenComplete(() {
      print("Post add line done");
    });
  }
  //

  void _onCommenButtonPressed() {
    print("Post comment: " + _controllerComment.text);
  }
}
