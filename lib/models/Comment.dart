class Comment {
  late String commentText;
  late String commentBy;
  late String userId;
  late String commentTime;

  Comment(
      {required this.commentText,
      required this.commentBy,
      required this.userId,
      required this.commentTime});

  Comment.fromJson(Map<String, dynamic> json) {
    commentText = json['comment_text'];
    commentBy = json['comment_by'];
    userId = json['user_id'];
    commentTime = json['comment_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment_text'] = commentText;
    data['comment_by'] = commentBy;
    data['user_id'] = userId;
    data['comment_time'] = commentTime;
    return data;
  }
}
