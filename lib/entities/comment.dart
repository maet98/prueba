class Comment {
  final int id;
  final String comment;
  dynamic user;
  final int postId;

  Comment(this.id, this.comment, this.user, this.postId);

  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(json['id'], json['comment'], json['user'], json['postId']);
  }

  Map toMap() {
    var map = new Map();
    map['id'] = id;
    map['comment'] = comment;
    map['user'] = user.toMap();
    map['postId'] = postId;
    return map;
  }
}
