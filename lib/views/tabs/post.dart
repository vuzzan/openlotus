import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:openlotus/_routing/routes.dart';
import '../../services/diohttp.dart';

import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:chips_choice/chips_choice.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController postInfo = TextEditingController();
  List<Asset> images = List<Asset>.empty();
  String _error = '';
  bool isUpload = false;
  final _dio = Dio();
  int tag = 3;
  Future upload() async {
    setState(() {
      isUpload = true;
    });

    // print("Begin upload");
    // print("Image set");
    //Map<String, MultipartFile> fileMap = {};
    List<dynamic> multipartImageList = [];
    if (images.isNotEmpty) {
      for (Asset asset in images) {
        print("Add photo begin: {$asset.name}");
        ByteData byteData = await asset.getByteData();
        //print("Add photo begin: 1");
        Uint8List imageData = byteData.buffer.asUint8List();
        //print("Add photo begin: 2: ${asset.name?.toLowerCase()}");
        var imageDataCompress = await FlutterImageCompress.compressWithList(
          imageData,
          autoCorrectionAngle: true,
          minHeight: 800,
          minWidth: 800,
          quality: 96,
          rotate: 0,
        );
        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageDataCompress,
          filename: asset.name?.toLowerCase(),
          contentType: MediaType("image", "jpg"),
        );
        //print("Add photo begin: 3");
        multipartImageList.add(multipartFile);
        //fileMap["image2"] = multipartFile;
        print("Add photo end");
      }
    }
    //print("Add photo count: ${multipartImageList.length}");
    String Bearer = authenticator.getTokenString();
    var formData = FormData.fromMap(
        {"action_text": postInfo.text, "image[]": multipartImageList});
    print("Bearer: $Bearer");
    // var response = await authenticator.getApiClient().post(
    //     "${Authenticator.authority}/production_log_ajax.php?a=add",
    //     data: formData);
    var response = await _dio.post(
        "${Authenticator.authority}/production_log_ajax.php?a=add",
        options: Options(
          headers: {"Authorization": Bearer},
        ),
        //onSendProgress: (count, total) => {print("Send : $count $total")},
        onReceiveProgress: (count, total) => {print("Recv : $count $total")},
        data: formData);
    print(response.toString());
    print(response.toString());
    print(response.toString());
    Map<String, dynamic> map = json.decode(response.toString());
    if (map["status"] == true) {
      // print("Upload OK");
      Navigator.pushNamed(context, homeViewRoute);
      setState(() {
        isUpload = false;
      });
      // Upload OK
    } else {
      //print("Upload FAIL");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Post"),
              content: Text("Post error"),
            );
          });
      setState(() {
        isUpload = false;
      });
      // UPLOAD FAIL
    }
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>.empty();
    String error = '';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Chọn hình đăng",
          allViewTitle: "Tất cả hình ảnh",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  late List<int> listDisabled = [];
  late List<int> listChoosen = [];
  @override
  Widget build(BuildContext context) {
    // list of string options
    dynamic options = [
      "Cần người làm ",
      "chăm sóc ",
      "người bệnh ",
      "Nhận ",
      "sản phụ "
    ];

    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('ĐĂNG BÀI'),
        // ),
        body: Container(
            color: Colors.grey.withOpacity(0.1),
            padding: const EdgeInsets.only(top: 40.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 1.0, bottom: 30.0),
                  child: Text(
                    "Đăng bài",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) => setState(() {
                    tag = val;
                    listChoosen.add(val);
                    postInfo.text = "";
                    for (var index in listChoosen) {
                      postInfo.text += options[index];
                    }
                    //listDisabled.add(val);
                  }),
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                    disabled: (i, v) => listChoosen.contains(i),
                    hidden: (i, v) => listChoosen.contains(i) == true,
                  ),
                  wrapped: true,
                ),
                // TextField(
                //   keyboardType: TextInputType.multiline,
                //   maxLines: 5,
                //   controller: postInfo,
                //   decoration: const InputDecoration(
                //     hintText: "NỘI DUNG",
                //   ),
                // ),
                TextField(
                    decoration: InputDecoration(
                      hintText: "Đăng bài",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9.0),
                        borderSide: const BorderSide(
                          color: Colors.amber,
                          style: BorderStyle.solid,
                        ),
                      ),
                      // suffixIcon: IconButton(
                      //   icon: const Icon(Icons.send),
                      //   onPressed: () {
                      //     //_doComment(widget.feed, _controllerComment.text);
                      //   },
                      // ),
                    ),
                    maxLines: 3,
                    autofocus: false,
                    cursorColor: Colors.amber,
                    style: const TextStyle(height: 2.0),
                    cursorWidth: 5.0,
                    enabled: true,
                    controller: postInfo,
                    onTap: () {
                      //print("On tap");
                    },
                    onSubmitted: (text) {
                      //_doComment(widget.feed, text);
                    }),
                ElevatedButton(
                  onPressed: loadAssets,
                  child: const Text("Chọn hình"),
                ),
                Expanded(
                  child: buildGridView(),
                ),
                ElevatedButton(
                  onPressed: isUpload
                      ? null
                      : () {
                          upload();
                        },
                  child: Text(isUpload ? "ĐANG LƯU..." : "ĐĂNG BÀI"),
                ),
              ],
            )),
      ),
    );
  }
}
