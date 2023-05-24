import 'package:flutter/material.dart';

class Badge1 extends StatelessWidget {
  const Badge1({
    required this.child,
    // required this.value,
    required this.color,
  });

  final Widget child;
  // final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: -5,
          child: Container(
              padding: EdgeInsets.all(2.0),
              // color: Theme.of(context).accentColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color:
                    color != null ? color : Theme.of(context).primaryColorLight,
              ),
              constraints: BoxConstraints(),
              child: Icon(Icons.cancel)),
        )
      ],
    );
  }
}
