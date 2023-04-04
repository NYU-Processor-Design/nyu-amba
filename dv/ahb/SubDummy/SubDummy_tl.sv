module SubDummy_tl #(
  AddrWidth = 32,
  DataWidth = 32
) (
  input clk,
  input nReset,
  input [AddrWidth-1:0] addr,
  input [DataWidth-1:0] wData,
  input [3:0] control,
  input [1:0] trans,
  input write,

  output [DataWidth-1:0] rData,
  output [1:0] resp,
  output readyOut
);

  AHBCommon_if #(DataWidth, AddrWidth) ahb (clk, nReset);

  SubDummy sub (.*);

  assign ahb.addr = addr;
  assign ahb.wData = wData;
  assign ahb.trans = trans;
  assign ahb.write = write;

  assign resp = ahb.resp;
  assign rData = ahb.rData;
  assign readyOut = ahb.readyOut;


endmodule
