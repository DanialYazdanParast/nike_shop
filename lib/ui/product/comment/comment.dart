
import 'package:flutter/material.dart';
import 'package:nike_shop/data/comment.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color:Theme.of(context).dividerColor,width: 1 ),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.titel),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  comment.email,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            Text(comment.date,style: Theme.of(context).textTheme.caption,),
          ]),
          const SizedBox(height: 16,),
         Text(comment.content,style: const TextStyle(height: 1.4),),
        ],
      ),
    );
  }
}
