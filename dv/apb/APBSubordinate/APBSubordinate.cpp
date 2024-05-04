#include <catch2/catch_test_macros.hpp>
#include <NyuTestUtil.hpp>

#include <VAPBSubordinate_tl.h>


void logical_test(VAPBSubordinate_tl& bs, uint8_t sel) {
    nyu::reset(bs);
    const std::uint32_t base_addr {0x100};
    bs.bus_selectors = sel;
    for (std::uint8_t i {0}; i < 2; ++i) {
        for (std::uint8_t j {0}; j < 2; ++j) {
            bs.bus_write = i;
            bs.bus_enable = j;
            nyu::eval(bs);
            REQUIRE(bs.sub_wEn == (sel ? (i && j) : 0));
            REQUIRE(bs.sub_rEn == (sel ? (!i && j) : 0));
        }
    }
    for (std::uint32_t i {1}; i; i <<= 1) {
        bs.bus_addr = base_addr + i;
        nyu::eval(bs);
        REQUIRE(bs.sub_addr == (sel ? i : 0));
    }
}

// bus-to-device pass-thru
TEST_CASE("APBSubordinate, bus-to-device pass-thru") {
    VAPBSubordinate_tl& bs {nyu::getDUT<VAPBSubordinate_tl>()};
    nyu::reset(bs);
    for (std::uint8_t i {0}; i < 16; ++i) {
        bs.bus_prot = i;
        bs.bus_strb = i;
        nyu::eval(bs);
        REQUIRE(bs.sub_prot == i);
        REQUIRE(bs.sub_wStrb == i);
    }
    for (std::uint32_t i {1}; i; i <<= 1) {
        bs.bus_wData = i;
        nyu::eval(bs);
        REQUIRE(bs.sub_wData == i);
    }
}

// device-to-bus pass-thru
TEST_CASE("APBSubordinate, device-to-bus pass-thru") {
    VAPBSubordinate_tl& bs {nyu::getDUT<VAPBSubordinate_tl>()};
    nyu::reset(bs);
    for (std::uint8_t i{0}; i < 2; ++i) {
        bs.sub_error = i;
        bs.sub_busy = i;
        nyu::eval(bs);
        REQUIRE(bs.bus_subError == i);
        REQUIRE(bs.bus_ready == !i);
    }
    for (std::uint32_t i{1}; i; i <<= 1) {
        bs.sub_rData = i;
        nyu::eval(bs);
        REQUIRE(bs.bus_rData == i);
    }
}

// logical
TEST_CASE("APBSubordinate, logical") {
    VAPBSubordinate_tl& bs {nyu::getDUT<VAPBSubordinate_tl>()};
    logical_test(bs, 0);
    logical_test(bs, 1);
}