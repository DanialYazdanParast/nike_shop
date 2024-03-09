import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/comment.dart';
import 'package:nike_shop/data/repo/comment_repository.dart';

part 'comment_list_event.dart';
part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final int productId;
  CommentListBloc({required this.repository, required this.productId})
      : super(CommentListLodingState()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStartedEvent) {
        emit(CommentListLodingState());
        try {
          final comments = await repository.getAll(productId: productId);
          emit(CommentListSuccessState(comments));
        } catch (e) {
          emit(CommentListErrorState(AppException()));
        }
      }
    });
  }
}
