module SubMemCtrl_tl #(
  AddrWidth = 32,
  DataWidth = 32
) (
  input clk,
  input nReset,
  input [AddrWidth-1:0] addr,
  input [DataWidth-1:0] wData,
  input [1:0] trans,
  input [2:0] burst,
  input write,
  input sel,

  input mem_readyOut,
  input [DataWidth-1:0] mem_rData,
  input [1:0] mem_resp,

  output [DataWidth-1:0] rData,
  output [1:0] resp,
  output readyOut
);

  AHBCommon_if #(DataWidth, AddrWidth) ahb (clk, nReset);
  MemCommon_if #(DataWidth, AddrWidth) mem (clk, nReset);

  SubMemCtrl_tl sub (.*);
  
  assign ahb.sel = sel;
  assign ahb.addr = addr;
  assign ahb.wData = wData;
  assign ahb.trans = trans;
  assign ahb.write = write;

  assign resp = ahb.resp;
  assign rData = ahb.rData;
  assign readyOut = ahb.readyOut;

  assign mem.resp = mem_resp;
  assign mem.rData = mem_rData;

endmodule
