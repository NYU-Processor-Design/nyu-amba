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

TEST_CASE("SubDummy Unslected") {
  VSubDummy_tl dut;
  dut.control = 0;
  dut.sel = 0;
  dut.nReset = 0;
  dut.trans = 0;
  nyu::tick(dut);
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);
}

TEST_CASE("SubDummy Sequential Transfer with busy cycles") {
  VSubDummy_tl dut;
  //Reset
  dut.control = 0;
  dut.sel = 1;
  dut.nReset = 0;
  dut.trans = 0;
  nyu::tick(dut);
  //Write address 0x0
  dut.nReset = 1;
  dut.addr = 0x0;
  dut.wData = 0x1234;
  dut.write = 1;
  dut.trans = 2;
  nyu::tick(dut);
  //Write address 0x1
  REQUIRE(dut.resp == 0);
  dut.addr = 0x1;
  dut.wData = 0x5678;
  dut.trans = 3;
  nyu::tick(dut);
  //Write address 0x2 with busy cycle
  REQUIRE(dut.resp == 0);
  dut.addr = 0x2;
  dut.wData = 0x9abc;
  dut.trans = 1;
  nyu::tick(dut);
  //Manager continues but subordinate stalls
  REQUIRE(dut.resp == 0);
  dut.trans = 3;
  dut.control = 1;
  nyu::tick(dut);
  //Manager holds values as subordinate reasserts readyOut
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 0);
  dut.control = 0;
  nyu::tick(dut);
  //Complete transferns read address 0x0
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);

  dut.write = 0;
  dut.addr = 0x0;
  dut.trans = 2;
  dut.control = 0;
  nyu::tick(dut);
  //Complete transferns read address 0x1
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.rData == 0x1234);
  dut.trans = 3;
  dut.addr = 0x1;
  nyu::tick(dut);
  //Complete transferns read address 0x2
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.rData == 0x5678);
  dut.addr = 0x2;
  nyu::tick(dut);
  //Complete transferns read address 0x3
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);
  REQUIRE(dut.rData == 0x9abc);
}

TEST_CASE("SubDummy Idle state") {
  VSubDummy_tl dut;
  //Reset
  dut.control = 0;
  dut.sel = 1;
  dut.nReset = 0;
  dut.trans = 0;
  nyu::tick(dut);
  dut.nReset = 1;
  nyu::tick(dut);
  nyu::tick(dut);
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);
}

TEST_CASE("SubDummy Error Resolution") {
  VSubDummy_tl dut;
  //Reset
  dut.control = 0;
  dut.sel = 1;
  dut.nReset = 0;
  dut.trans = 0;
  nyu::tick(dut);
  //Set SubDummy to trigger an error
  dut.nReset = 1;
  dut.trans = 2;
  dut.write = 1;
  dut.wData = 0x1234;
  dut.addr = 0x0;
  dut.control = 2;
  nyu::tick(dut);
  //SubDummy should respond with an error and not process anything. 
  //Set transfer to idle to resolve error
  REQUIRE(dut.resp == 1);
  REQUIRE(dut.readyOut == 0);
  dut.control = 0;
  dut.trans = 0;
  nyu::tick(dut);
  //SubDummy should be ready to process again
  REQUIRE(dut.resp == 0);
  REQUIRE(dut.readyOut == 1);
}