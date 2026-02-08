#include <Zut/ZxJson.h>
#include <fmt/printf.h>
#include <iostream>
#include <print>

auto main() -> int {
  try {
    const auto json = ZxJson::JObject_t{{"name", "xiao"}, {"age", 6}};
    const auto json_string = ZxJson::StoreViaMemory(json, false);
    fmt::println("fmt:{}", json_string);
  } catch (const std::exception &err) {
    std::println(std::cerr, "std::exception: {}", err.what());
  } catch (...) {
    std::println(std::cerr, "unknown exception!");
  }
}
