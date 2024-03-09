class CommentEntity {
  final int id;
  final String titel;
  final String content;
  final String date;
  final String email;

  CommentEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        titel = json['title'],
        content = json['content'],
        date = json['date'],
        email = json['author']['email'];
}
