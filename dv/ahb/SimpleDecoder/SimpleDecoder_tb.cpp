#include <catch2/catch_test_macros.hpp>
#include <VSimpleDecoder_tl.h>


TEST_CASE("SimpleDecoder, Basic Functionality") {
    VSimpleDecoder_tl* decoder = new VSimpleDecoder_tl;
    Verilated::traceEverOn(true);
    decoder->clk = 0;
    decoder->nReset = 1;
    decoder->eval();
    decoder->clk = 1;
    decoder->eval();
    decoder->clk = 0;
    decoder->eval();
    decoder->nReset = 0;
    decoder->eval();
    decoder->clk = 1;
    decoder->eval();

    //test for addresses 1 to 3
    for (int address = 1; address <= 3; ++address) {
        int expected_sel = 1 << (address - 1);

        decoder->addr = address;
        decoder->eval();
        decoder->clk = 0; //falling edge
        decoder->eval();
        decoder->clk = 1; //rising edge
        decoder->eval();

        CAPTURE(address, expected_sel); //capture the values
        REQUIRE(decoder->sel == expected_sel);
    }
    decoder->final();
    delete decoder;
}
