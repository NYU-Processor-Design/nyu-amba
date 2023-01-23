module SimpleDecoder_tl #(
  AddrWidth = 32
  PrphNum = 2
) (
  input clk,
  input nReset,
  input [AddrWidth - 1:0] addr,

  output [PrphNum - 1:0] sel
);

  AHBCommon_if #(32, AddrWidth) ahb (clk, nReset);

  assign ahb.addr = addr;

  SimpleDecoder #(PrphNum) decoder (.*);

endmodule
