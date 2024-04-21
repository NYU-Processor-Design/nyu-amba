#include <catch2/catch_test_macros.hpp>
#include <NyuTestUtil.hpp>

#include <VAPBManager_tl.h>

// Verify all pass-thrus into bus
TEST_CASE("APBManager, bus-to-device pass-thru") {
    VAPBManager_tl& bm {nyu::getDUT<VAPBManager_tl>()};
    nyu::reset(bm);
    for (std::uint8_t i {0}; i < 2; ++i) {
        bm.localSel = i;
        nyu::eval(bm);
        REQUIRE(bm.bus_selectors == i);
    }
    for (std::uint8_t i {0}; i < 16; ++i) {
        bm.mgr_prot = i;
        bm.mgr_wStrb = i;
        nyu::eval(bm);
        REQUIRE(bm.bus_prot == i);
        REQUIRE(bm.bus_strb == i);
    }
    for (std::uint32_t i {1}; i; i <<= 1) {
        bm.mgr_wData = i;
        bm.mgr_addr = i;
        nyu::eval(bm);
        REQUIRE(bm.bus_wData == i);
        REQUIRE(bm.bus_addr == i);
        REQUIRE(bm.localAddr == i);
    }
    // Double-check how to handle localSel & localAddr here
}

// Verify all pass-thrus from bus
TEST_CASE("APBManager, device-to-bus pass-thru") {
    VAPBManager_tl& bm {nyu::getDUT<VAPBManager_tl>()};
    nyu::reset(bm);
    for (std::uint8_t i {0}; i < 2; ++i) {
        bm.bus_ready = i;
        bm.bus_subError = i;
        nyu::eval(bm);
        REQUIRE(bm.mgr_busy == !i);
        REQUIRE(bm.mgr_error == i);
    }
    for (std::uint32_t i {1}; i; i <<= 1) {
        bm.bus_rData = i;
        nyu::eval(bm);
        REQUIRE(bm.mgr_rData == i);
    }
}

// Verify all logic implemented
TEST_CASE("APBManager, logical assigns"){
    VAPBManager_tl& bm {nyu::getDUT<VAPBManager_tl>()};
    nyu::reset(bm);
    for (std::uint8_t i {0}; i < 2; ++i) {
        for (std::uint8_t j {0}; i < 2; ++j) {
            bm.mgr_wEn = i;
            bm.mgr_rEn = j;
            nyu::eval(bm);
            REQUIRE(bm.bus_write == (i && !j));
            REQUIRE(bm.bus_enable == (i ^ j));
        }
    }
}
