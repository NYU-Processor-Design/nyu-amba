module SubDummy_tl #(
  AddrWidth = 32,
  DataWidth = 32
) (
  input clk,
  input nReset
);

  AHBCommon_if #(DataWidth, AddrWidth) ahb (clk, nReset);

  SubDummy sub (.*);

endmodule
