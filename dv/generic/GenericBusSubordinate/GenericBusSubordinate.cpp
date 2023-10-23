#include <catch2/catch_test_macros.hpp>
#include <NyuTestUtil.hpp>

#include <VGenericBusSubordinate_tl.h>

TEST_CASE("GenericBusSubordinate, bus pass-thru") {
  VGenericBusSubordinate_tl& bs {nyu::getDUT<VGenericBusSubordinate_tl>()};
  nyu::reset(bs);

  for(std::uint8_t i {0}; i < 2; ++i) {
    bs.bus_isBurst = i;
    bs.bus_nonSec = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_isBurst == i);
    REQUIRE(bs.sub_nonSec == i);
  }

  for(std::uint8_t i {0}; i < 4; ++i) {
    bs.bus_burstType = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_burstType == i);
  }

  for(std::uint8_t i {0}; i < 0x10; ++i) {
    bs.bus_wStrb = i;
    bs.bus_prot = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_wStrb == i);
    REQUIRE(bs.sub_prot == i);
  }

  for(std::uint8_t i {1}; i; i <<= 1) {
    bs.bus_burstLen = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_burstLen == i);
  }

  for(std::uint32_t i {1}; i; i <<= 1) {
    bs.bus_wData = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_wData == i);
  }
}

TEST_CASE("GenericBusSubordinate, addressable") {
  VGenericBusSubordinate_tl& bs {nyu::getDUT<VGenericBusSubordinate_tl>()};
  nyu::reset(bs);

  constexpr std::uint32_t base_addr {0x100};

  for(std::uint32_t i {0}; i < 0x100; ++i) {
    bs.bus_addr = base_addr + i;
    nyu::eval(bs);
    REQUIRE(bs.sub_addr == i);
  }

  bs.bus_addr = base_addr;
  for(std::uint8_t i {0}; i < 2; ++i) {
    bs.bus_wEn = i;
    bs.bus_rEn = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_wEn == i);
    REQUIRE(bs.sub_rEn == i);
  }

  bs.bus_addr = 0;
  for(std::uint8_t i {0}; i < 2; ++i) {
    bs.bus_wEn = i;
    bs.bus_rEn = i;
    nyu::eval(bs);
    REQUIRE(bs.sub_wEn == 0);
    REQUIRE(bs.sub_rEn == 0);
    REQUIRE(bs.sub_addr == 0);
  }
}
