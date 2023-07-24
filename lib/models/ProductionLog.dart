class ProductionLog {
  String? plogId;
  String? coId;
  String? ownerId;
  String? landId;
  String? projectId;
  String? startedTime;
  String? endTime;
  String? actionText;
  late String content;
  String? actionId;
  String? userId;
  late String userName;
  String? sts;
  late List<Images> images;
  String? comments_count;
  String? likes_count;

  ProductionLog(
      {this.plogId,
      this.coId,
      this.ownerId,
      this.landId,
      this.projectId,
      this.startedTime,
      this.endTime,
      this.actionText,
      required this.content,
      this.actionId,
      this.userId,
      required this.userName,
      this.sts,
      required this.images,
      this.comments_count,
      this.likes_count});

  ProductionLog.fromJson(Map<String, dynamic> json) {
    plogId = json['plog_id'];
    coId = json['co_id'];
    ownerId = json['owner_id'];
    landId = json['land_id'];
    projectId = json['project_id'];
    startedTime = json['started_time'];
    endTime = json['end_time'];
    actionText = json['action_text'];
    content = json['content'];
    actionId = json['action_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    sts = json['sts'];
    comments_count = json['comments_count'];
    likes_count = json['likes_count'];
    print(json['images']);
    if (json['images'] != null) {
      images = List<Images>.empty(growable: true);
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    } else {
      images = List.empty(growable: true);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plog_id'] = this.plogId;
    data['co_id'] = this.coId;
    data['owner_id'] = this.ownerId;
    data['land_id'] = this.landId;
    data['project_id'] = this.projectId;
    data['started_time'] = this.startedTime;
    data['end_time'] = this.endTime;
    data['action_text'] = this.actionText;
    data['content'] = this.content;
    data['action_id'] = this.actionId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['sts'] = this.sts;
    data['comments_count'] = this.comments_count;
    data['likes_count'] = this.likes_count;
    data['images'] = this.images?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Images {
  String? attachmentUrl;

  Images({attachmentUrl});

  Images.fromJson(Map<String, dynamic> json) {
    attachmentUrl = json['attachment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachment_url'] = attachmentUrl;
    return data;
  }
}
