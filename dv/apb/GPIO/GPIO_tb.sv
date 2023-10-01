module GPIO_tb #(
  AddrWidth = 32,
  DataWidth = 32
) (
  input clk, //PCLK
  input nReset, //PRESETn
  input [AddrWidth-1:0] addr, //PADDR
  input [DataWidth-1:0] wData, //PWDATA
  input write, //PWRITE
  input sel, //PSEL
  input enable, //PENABLE

  output [DataWidth-1:0] rData, //PRDATA
  output subErr, //PsubErr
  output readyOut //PREADY
);

  APBCommon_if #(DataWidth, AddrWidth) apb (clk, nReset);

  GPIO #(16) sub (.*);
  
  assign apb.sel = sel;
  assign apb.addr = addr;
  assign apb.wData = wData;
  assign apb.write = write;
  assign apb.enable = enable;

  assign subErr = apb.subErr;
  assign rData = apb.rData;
  assign readyOut = apb.readyOut;


endmodule
