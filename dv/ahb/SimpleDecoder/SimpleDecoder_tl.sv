module SimpleDecoder_tl #(
  AddrWidth = 32,
  SubordinateNum = 2
) (
  input clk,
  input nReset,
  input [AddrWidth - 1:0] addr,

  output [SubordinateNum - 1:0] sel
);

  AHBCommon_if #(32, AddrWidth) ahb (clk, nReset);

  assign ahb.addr = addr;

  SimpleDecoder #(SubordinateNum) decoder (.*);

endmodule
