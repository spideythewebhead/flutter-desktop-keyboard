#include "kbd.hh"
#include <iostream>

using std::cout;
using std::endl;

int main(int argc, char const *argv[])
{
  
  auto path = get_keyboard_path();

  cout << path << endl;

  auto kbd_fd = get_fd_from_path(path);  

  cout << "fd: " << kbd_fd << endl;

  while (1) {

    auto event = event_from_keyboard(kbd_fd);

    if (event.type != nullptr)
      cout << (event.keycode) << "-" << event.type << "-" << event.timestamp << endl;

  }

  return 0;
}