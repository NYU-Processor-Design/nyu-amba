#include <VSubDummy_tl.h>
#include <catch2/catch_test_macros.hpp>

TEST_CASE("INIT") {
  VSubDummy_tl dut;
  dut.eval();
  REQUIRE(1 == 1);
}
