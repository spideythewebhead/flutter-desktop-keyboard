# Flutter Desktop Keyboard

*this is just for fun. Don't panic if you see the c++ code 😱*

An app thats monitors global keyboard events.
It works by find the proper link inn`/dev/input/by-path`
Also for input to work you need to run the app as root or you can add permissions to your user.

### Steps

1. `cd app`
1. `flutter build linux`
1. `sudo ./build/linux/release/bundle/app`
