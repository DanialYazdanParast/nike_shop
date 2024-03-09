part of 'comment_list_bloc.dart';

sealed class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object> get props => [];
}

final class CommentListLodingState extends CommentListState {}

final class CommentListSuccessState extends CommentListState {
  final List<CommentEntity> comments;

  const CommentListSuccessState(this.comments);

  @override
  List<Object> get props => [comments];
}

final class CommentListErrorState extends CommentListState {
  final AppException exception;

 const CommentListErrorState(this.exception);
 @override
  // TODO: implement props
  List<Object> get props => [exception];

}
