#include <catch2/catch_test_macros.hpp>
#include <NyuTestUtil.hpp>

#include <VSubDummy_tl.h>

TEST_CASE("SubDummy, Single read write") {
  auto& dut {nyu::getDUT<VSubDummy_tl>()};
  dut.control = 0;
  dut.sel = 1;
  dut.nReset = 0;
  dut.trans = 0;
  nyu::tick(dut);
  dut.nReset = 1;
  dut.addr = 0x0;
  dut.wData = 0x1234;
  dut.write = 1;
  dut.trans = 2;
  nyu::tick(dut);
  dut.wData = 0;
  dut.write = 0;
  dut.trans = 2;
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.resp == 0);
  nyu::tick(dut);
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.rData == 0x1234);
}
