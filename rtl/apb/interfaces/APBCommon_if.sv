interface APBCommon_if #(
  AddrWidth = 32,
  DataWidth = 32
) (
  input clk,
  input nReset
);
  logic [AddrWidth - 1:0] addr;
  logic [3:0] prot;
  logic selector_0;
  // logic selector_1; // and so on
  logic enable;
  logic write;
  logic [DataWidth - 1:0] wData;
  logic [DataWidth/8 - 1:0] strb;
  logic ready;
  logic [DataWidth - 1:0] rData;
  logic slvError;

endinterface
