#include "Wx32/Private/WxUser32.h"
#include <Wx32/APIs.h>
// #include <c.h>
#include <iostream>
#include <winuser.h>

int main() {
  Wx32::API::MessageBoxU8(nullptr, "123", "123", MB_OK);
  // c();
  // std::cout << "21313\n";
}