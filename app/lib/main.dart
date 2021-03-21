import 'package:app/kbd.dart';
import 'package:app/widgets/key.dart';
import 'package:app/widgets/spacing.dart';
import 'package:flutter/material.dart';

late Kbd kbd;

Future<void> main() async {
  kbd = await Kbd.create();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      home: Home(),
    );
  }
}

class Shared<T> extends InheritedWidget {
  final T data;

  Shared({
    required this.data,
    required Widget child,
  }) : super(child: child);

  static T of<T>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Shared<T>>();

    if (result == null) {
      throw "No Shared<$T> instance found.";
    }

    return result.data;
  }

  @override
  bool updateShouldNotify(covariant Shared oldWidget) {
    return oldWidget.data != data;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<KeyboardEvent> filteredKbdEvents;

  @override
  void initState() {
    super.initState();

    filteredKbdEvents = kbd.events.where((event) => event.type.address != 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Shared<Stream<KeyboardEvent>>(
            data: filteredKbdEvents,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyboardButton(text: 'ESC'),
                    w12,
                    KeyboardButton(text: 'F1'),
                    KeyboardButton(text: 'F2'),
                    KeyboardButton(text: 'F3'),
                    KeyboardButton(text: 'F4'),
                    w8,
                    KeyboardButton(text: 'F5'),
                    KeyboardButton(text: 'F6'),
                    KeyboardButton(text: 'F7'),
                    KeyboardButton(text: 'F8'),
                    w8,
                    KeyboardButton(text: 'F9'),
                    KeyboardButton(text: 'F10'),
                    KeyboardButton(text: 'F11'),
                    KeyboardButton(text: 'F12'),
                  ],
                ),
                h4,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyboardButton(text: '`'),
                    KeyboardButton(text: '1'),
                    KeyboardButton(text: '2'),
                    KeyboardButton(text: '3'),
                    KeyboardButton(text: '4'),
                    KeyboardButton(text: '5'),
                    KeyboardButton(text: '6'),
                    KeyboardButton(text: '7'),
                    KeyboardButton(text: '8'),
                    KeyboardButton(text: '9'),
                    KeyboardButton(text: '0'),
                    KeyboardButton(text: '-'),
                    KeyboardButton(text: '='),
                    KeyboardButton(text: 'BACKSPACE', flex: 3),
                  ],
                ),
                h4,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyboardButton(text: 'TAB', flex: 2),
                    w8,
                    KeyboardButton(text: 'Q'),
                    KeyboardButton(text: 'W'),
                    KeyboardButton(text: 'E'),
                    KeyboardButton(text: 'R'),
                    KeyboardButton(text: 'T'),
                    KeyboardButton(text: 'Y'),
                    KeyboardButton(text: 'U'),
                    KeyboardButton(text: 'I'),
                    KeyboardButton(text: 'O'),
                    KeyboardButton(text: 'P'),
                    KeyboardButton(text: '['),
                    KeyboardButton(text: ']'),
                    KeyboardButton(text: '\\'),
                  ],
                ),
                h4,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyboardButton(text: 'CAPS', flex: 2),
                    w8,
                    KeyboardButton(text: 'A'),
                    KeyboardButton(text: 'S'),
                    KeyboardButton(text: 'D'),
                    KeyboardButton(text: 'F'),
                    KeyboardButton(text: 'G'),
                    KeyboardButton(text: 'H'),
                    KeyboardButton(text: 'J'),
                    KeyboardButton(text: 'K'),
                    KeyboardButton(text: 'L'),
                    KeyboardButton(text: ';'),
                    KeyboardButton(text: '"'),
                    KeyboardButton(text: 'ENTER', flex: 2),
                  ],
                ),
                h4,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyboardButton(text: 'SHIFT', flex: 2),
                    w8,
                    KeyboardButton(text: 'Z'),
                    KeyboardButton(text: 'X'),
                    KeyboardButton(text: 'C'),
                    KeyboardButton(text: 'V'),
                    KeyboardButton(text: 'B'),
                    KeyboardButton(text: 'N'),
                    KeyboardButton(text: 'M'),
                    KeyboardButton(text: ','),
                    KeyboardButton(text: '.'),
                    KeyboardButton(text: '/'),
                  ],
                ),
                h4,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyboardButton(text: 'L-CTRL'),
                    KeyboardButton(text: 'WIN'),
                    KeyboardButton(text: 'ALT'),
                    w12,
                    KeyboardButton(text: 'SPACE', flex: 6),
                    w12,
                    KeyboardButton(text: 'ALT'),
                    KeyboardButton(text: 'R-CTRL'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
