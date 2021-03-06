import 'dart:async';

import 'package:app/kbd.dart';
import 'package:app/main.dart';
import 'package:app/on_context_ready.dart';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

class KeyboardButton extends StatefulWidget {
  final String text;
  final int flex;

  KeyboardButton({
    Key? key,
    required this.text,
    this.flex = 1,
  }) : super(key: key);

  @override
  _KeyboardButtonState createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<KeyboardButton> with OnContextReady {
  late StreamSubscription _subscription;

  bool isPressed = false;
  int pressCount = 0;

  @override
  void onContextReady() {
    _subscription = Shared.of<Stream<KeyboardEvent>>(context)
        .where((event) => keyCodeToString[event.keycode] == widget.text)
        .listen((event) async {
      switch (event.type.toDartString()) {
        case "key_press":
          setState(() {
            ++pressCount;
            isPressed = true;
          });
          break;
        case "key_release":
          setState(() {
            isPressed = false;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: isPressed ? Colors.blue : Colors.black54,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isPressed
                      ? const [
                          Colors.deepPurple,
                          Colors.blueGrey,
                        ]
                      : const [
                          Colors.black,
                          Colors.black54,
                          Colors.black,
                        ],
                )),
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Positioned(
            bottom: 4.0,
            right: 6.0,
            child: Text(
              '$pressCount',
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }
}
