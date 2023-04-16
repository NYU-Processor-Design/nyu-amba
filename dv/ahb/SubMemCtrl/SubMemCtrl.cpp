
#include <VSubMemCtrl_tl.h>
#include <catch2/catch_test_macros.hpp>

void clock(VSubMemCtrl_tl &dut) {
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

TEST_CASE("SubMemCtrl Init") {
  VSubMemCtrl_tl dut;
  dut.eval();
  REQUIRE(1 == 1);
}
