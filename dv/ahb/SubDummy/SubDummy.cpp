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

TEST_CASE("Single read write") {
  VSubDummy_tl dut;
  dut.control = 0;
  dut.sel = 1;
  dut.nReset = 0;
  dut.trans = 0;
  clock(dut);
  dut.nReset = 1;
  dut.addr = 0x0;
  dut.wData = 0x1234;
  dut.write = 1;
  dut.trans = 2;
  clock(dut);
  dut.wData = 0;
  dut.write = 0;
  dut.trans = 2;
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.resp == 0);
  clock(dut);
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.rData == 0x1234);
}
