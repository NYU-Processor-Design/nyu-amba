#include <VGPIO_tb.h>
#include <catch2/catch_test_macros.hpp>

TEST_CASE("GPIO Write") {
  VGPIO_tb dut;
  dut.eval();
  dut.nReset = 1;
  dut.addr = 0x0;
  dut.wData = 0xAA;
  dut.enable = 1;
  dut.sel = 1;
  
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();

  std::cout << dut.PORTA_out << std::endl;
  REQUIRE(1 == 1);
}

TEST_CASE("GPIO Read") {
  VGPIO_tb dut;
  dut.eval();
  dut.PINA = 0xFFFF; //Set the input from GPIO pins to 0xFFFF
  dut.nReset = 1; //Reset is active low
  dut.enable = 1; 
  dut.sel = 1;
  dut.write = 1; 
  dut.wData = 0xABCD; //Write to PORTA pins
  dut.addr = 0x0;
  
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();

  dut.wData = 0xAAAA; //Write to DDR pins to set every other pin as output
  dut.addr = 0x1;
  
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();

  REQUIRE(dut.PORTA_PINS & 0x5555 == 0x5555); //Since every other pin is set as output, the input pins should be 0x5555

  dut.write = 0;
  dut.addr = 0x2;

  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();

  REQUIRE(dut.rData & 0x5555 == 0x5555); //Verify that read operation has the same result.
                                         //Since write pins also show up in reads, they are excluded

  dut.addr = 0x1;

  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();

  REQUIRE(dut.rData == 0xAAAA);

  dut.addr = 0x0;

  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();

  REQUIRE(dut.rData == 0xABCD);
}