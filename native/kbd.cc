#include "kbd.hh"
#include <linux/input.h>
#include <fcntl.h>
#include <unistd.h>
#include <iostream>
#include <filesystem>
#include <cstring>

using std::filesystem::directory_iterator;
using std::string;

const char* get_keyboard_path() {
  for (const auto& entry: directory_iterator("/dev/input/by-path")) {
    if (entry.path().filename().string().find("0-event-kbd") != string::npos) {
      auto matchPath = entry.path().string();
      char *path = new char[matchPath.length() + 1];
      memcpy(path, matchPath.c_str(), matchPath.length() + 1);
      return path;
    }
  }

  throw "No path found";
}

int get_fd_from_path(const char* path) {
  return open(path, O_RDONLY);
}

bool release_fd(int fd) {
  return close(fd) == 0;
}

keyboard_event event_from_keyboard(int fd) {
  struct input_event input_event;
  struct keyboard_event kbd_event;

  read(fd, &input_event, sizeof(input_event));

  kbd_event.timestamp = input_event.time.tv_sec;

  if (input_event.type == EV_KEY || input_event.type == EV_REL) {
    kbd_event.keycode = input_event.code;

    switch (input_event.value) {
      case KEY_RELEASE:
        kbd_event.type = "key_release";
        break;
      case KEY_PRESS:
        kbd_event.type = "key_press";
        break;
      case KEY_REPEAT:
        kbd_event.type = "key_repeat";
        break;
    }
  } else {
    kbd_event.type = nullptr;
  }

  return kbd_event;
}