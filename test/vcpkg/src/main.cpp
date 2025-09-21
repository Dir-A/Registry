#include <print>
#include <iostream>
#include <fmt/printf.h>
#include <Zut/ZxJson.h>

auto main() -> int
{
  try
  {
    const ZxJson::JObject_t json{ { "name", "xiao" }, { "age", 6 } };
    const auto json_string = ZxJson::StoreViaMemory(json, true);
    fmt::println("fmt:{}", json_string);
  }
  catch (const std::exception& err)
  {
    std::println(std::cerr, "std::exception: {}", err.what());
  }
  catch (...)
  {
    std::println(std::cerr, "unknown exception!");
  }
}
