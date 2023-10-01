#include <VSubDummy_tl.h>
#include <catch2/catch_test_macros.hpp>

void clock(VSubDummy_tl &dut) {
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

TEST_CASE("Init") {
  VSubDummy_tl dut;
  dut.eval();
  REQUIRE(1 == 1);
}