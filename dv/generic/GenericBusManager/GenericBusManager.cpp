#include <catch2/catch_test_macros.hpp>
#include <NyuTestUtil.hpp>

#include <VGenericBusManager_tl.h>

TEST_CASE("GenericBusManager, bus pass-thru") {
  VGenericBusManager_tl& bm {nyu::getDUT<VGenericBusManager_tl>()};
  nyu::reset(bm);

  for(std::uint8_t i {0}; i < 2; ++i) {
    bm.bus_error = i;
    bm.bus_busy = i;
    nyu::eval(bm);
    REQUIRE(bm.mgr_error == i);
    REQUIRE(bm.mgr_busy == i);
  }

  for(std::uint32_t i {1}; i; i <<= 1) {
    bm.bus_rData = i;
    nyu::eval(bm);
    REQUIRE(bm.mgr_rData == i);
  }
}

TEST_CASE("GenericBusManager, vital") {
  VGenericBusManager_tl& bm {nyu::getDUT<VGenericBusManager_tl>()};
  nyu::reset(bm);
  bm.bus_busy = 0;

  for(std::uint8_t i {0}; i < 2; ++i) {
    bm.mgr_wEn = i;
    bm.mgr_rEn = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_wEn == i);
    REQUIRE(bm.bus_rEn == i);
  }

  for(std::uint32_t i {1}; i; i <<= 1) {
    bm.mgr_addr = i;
    bm.mgr_wData = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_addr == i);
    REQUIRE(bm.bus_wData == i);
  }

  for(std::uint8_t i {0}; i < 0x10; ++i) {
    bm.mgr_wStrb = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_wStrb == i);
  }

  bm.bus_busy = 1;

  bm.mgr_wEn = 0;
  bm.mgr_rEn = 0;
  bm.mgr_addr = 0;
  bm.mgr_wData = 0;
  bm.mgr_wStrb = 0;

  nyu::tick(bm);

  REQUIRE(bm.bus_wEn == 1);
  REQUIRE(bm.bus_rEn == 1);
  REQUIRE(bm.bus_addr == (1 << 31));
  REQUIRE(bm.bus_wData == (1 << 31));
  REQUIRE(bm.bus_wStrb == 0xF);
}

TEST_CASE("GenericBusManager, hint") {
  VGenericBusManager_tl& bm {nyu::getDUT<VGenericBusManager_tl>()};
  nyu::reset(bm);
  bm.bus_busy = 0;

  for(std::uint8_t i {0}; i < 2; ++i) {
    bm.mgr_isBurst = i;
    bm.mgr_nonSec = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_isBurst == i);
    REQUIRE(bm.bus_nonSec == i);
  }

  for(std::uint8_t i {0}; i < 4; ++i) {
    bm.mgr_burstType = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_burstType == i);
  }

  for(std::uint8_t i {0}; i < 0x10; ++i) {
    bm.mgr_prot = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_prot == i);
  }


  for(std::uint8_t i {1}; i; i <<= 1) {
    bm.mgr_burstLen = i;
    nyu::tick(bm);
    REQUIRE(bm.bus_burstLen == i);
  }

  bm.mgr_rEn = 1;
  nyu::tick(bm);

  bm.bus_busy = 1;

  bm.mgr_isBurst = 0;
  bm.mgr_nonSec = 0;
  bm.mgr_burstType = 0;
  bm.mgr_prot = 0;
  bm.mgr_burstLen = 0;

  nyu::tick(bm);

  REQUIRE(bm.bus_isBurst == 1);
  REQUIRE(bm.bus_nonSec == 1);
  REQUIRE(bm.bus_burstType == 3);
  REQUIRE(bm.bus_prot == 0xF);
  REQUIRE(bm.bus_burstLen == (1 << 7));
}
