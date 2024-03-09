import 'package:dio/dio.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/common/response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRemoteDataSource
    with HttpResponseValidat
    implements ICommentDataSource {
  final Dio httpClient;
  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validatResponse(response);
    final List<CommentEntity> comments = [];
    (response.data as List).forEach((jsonObject) {
      comments.add(CommentEntity.fromJson(jsonObject));
    });
    return comments;
  }
}
