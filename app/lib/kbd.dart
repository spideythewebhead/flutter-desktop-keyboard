import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

final keyCodeToString = <int, String>{
  1: 'ESC',
  2: '1',
  3: '2',
  4: '3',
  5: '4',
  6: '5',
  7: '6',
  8: '7',
  9: '8',
  10: '9',
  11: '0',
  12: '-',
  13: '=',
  14: 'BACKSPACE',
  15: 'TAB',
  16: 'Q',
  17: 'W',
  18: 'E',
  19: 'R',
  20: 'T',
  21: 'Y',
  22: 'U',
  23: 'I',
  24: 'O',
  25: 'P',
  26: '[',
  27: ']',
  28: 'ENTER',
  29: 'L-CTRL',
  30: 'A',
  31: 'S',
  32: 'D',
  33: 'F',
  34: 'G',
  35: 'H',
  36: 'J',
  37: 'K',
  38: 'L',
  39: ';',
  40: '',
  41: '',
  42: 'SHIFT',
  43: '\\',
  44: 'Z',
  45: 'X',
  46: 'C',
  47: 'V',
  48: 'B',
  49: 'N',
  50: 'M',
  51: ',',
  52: '.',
  53: '/',
  54: 'SHIFT',
  55: '',
  56: 'ALT',
  57: 'SPACE',
  59: 'F1',
  60: 'F2',
  61: 'F3',
  62: 'F4',
  63: 'F5',
  64: 'F6',
  65: 'F7',
  66: 'F8',
  67: 'F9',
  68: 'F10',
  87: 'F11',
  88: 'F12',
  125: 'WIN'
};

class KeyboardEvent extends Struct {
  @Int8()
  external int keycode;

  external Pointer<Utf8> type;

  @Int64()
  external int timestamp;
}

final DynamicLibrary _lib = DynamicLibrary.open(
  '${Directory.current.path}/build/linux/${kReleaseMode ? 'release' : 'debug'}/libkbd.so',
);

final Pointer<Utf8> Function() _getKeyboardPath = _lib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>('get_keyboard_path')
    .asFunction();

final int Function(Pointer<Utf8>) _getFdFromPath = _lib
    .lookup<NativeFunction<Int32 Function(Pointer<Utf8>)>>('get_fd_from_path')
    .asFunction();

final int Function(int) _releaseFd = _lib
    .lookup<NativeFunction<Int32 Function(Int32)>>('release_fd')
    .asFunction();

final KeyboardEvent Function(int) _nextKeyboardEvent = _lib
    .lookup<NativeFunction<KeyboardEvent Function(Int32)>>(
        'event_from_keyboard')
    .asFunction();

class Kbd {
  static Kbd? _instance;

  final ReceivePort _receivePort = ReceivePort();
  final _eventsController = StreamController<KeyboardEvent>.broadcast();
  Stream<KeyboardEvent> get events => _eventsController.stream;

  late Isolate _isolate;
  late int _kbdFd;

  Kbd._() {
    _setListener();
  }

  static Future<Kbd> create() async {
    if (_instance == null) {
      final kbd = Kbd._();

      kbd._isolate = await Isolate.spawn(_looper, kbd._receivePort.sendPort);

      _instance = kbd;
    }

    return _instance!;
  }

  void dipose() {
    _releaseFd(_kbdFd);
    _isolate.kill();
    _eventsController.close();
  }

  static Future<void> _looper(SendPort sendPort) async {
    final path = _getKeyboardPath();
    final kbdFd = _getFdFromPath(path);

    sendPort.send(kbdFd);

    if (kbdFd == -1) {
      return;
    }

    while (true) {
      sendPort.send(_nextKeyboardEvent(kbdFd));
    }
  }

  void _setListener() async {
    await for (final event in _receivePort) {
      if (event is int) {
        _kbdFd = event;

        if (_kbdFd == -1) {
          print("Run program as root to capture input events. fd -1");
        }
      } else {
        _eventsController.add(event);
      }
    }
  }
}
