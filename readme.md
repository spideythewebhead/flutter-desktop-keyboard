# Flutter Desktop Keyboard

*this is just for fun. Don't panic if you see the c++ code 😱*

An app thats monitors global keyboard events.
Semi works for linux, as i don't know how to find the proper link in `/dev/input/by-id/*`

Also for input to work you need to run the app as root.

### Steps

1. `cd app`
1. `flutter build linux`
1. `sudo ./build/linux/release/bundle/app`