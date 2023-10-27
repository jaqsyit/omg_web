import 'package:flutter/material.dart';

class ErrorColumn extends StatelessWidget {
  final String? errMsg;
  final void Function()? onRetry;

  const ErrorColumn({Key? key, this.errMsg, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 35,),
            Text(errMsg ?? 'Неизвестная ошибка', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
            ), textAlign: TextAlign.center,),

            SizedBox(
              height: 20,
            ),

            Visibility(
              visible: onRetry != null,
              child: ElevatedButton(onPressed: onRetry, child: const Text('Попробовать снова')),
            )
          ],
        ),
      ),
    );
  }
}
