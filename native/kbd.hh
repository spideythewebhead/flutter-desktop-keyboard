#pragma once

#include <string>

#define KEY_RELEASE 0
#define KEY_PRESS 1
#define KEY_REPEAT 2

struct keyboard_event
{
  uint8_t keycode;
  const char* type;
  uint64_t timestamp;
};

extern "C" __attribute__((visibility("default"))) __attribute__((used))
const char* get_keyboard_path();

extern "C" __attribute__((visibility("default"))) __attribute__((used))
keyboard_event event_from_keyboard(int fd);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int get_fd_from_path(const char* path);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
bool release_fd(int fd);