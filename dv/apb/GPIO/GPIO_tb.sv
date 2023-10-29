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
  input [15:0] PINA,
  inout [15:0] PORTA_PINS,

  output [DataWidth-1:0] rData, //PRDATA
  output subErr, //PsubErr
  output readyOut, //PREADY
  output [15:0] PORTA_out, 
  output [15:0] DDRA_out
);

  APBCommon_if #(DataWidth, AddrWidth) apb (clk, nReset);

  GPIO #(16) sub (.*);

  assign PORTA_out = sub.PORTA;
  assign DDRA_out = sub.DDRA;
  
  assign apb.sel = sel;
  assign apb.addr = addr;
  assign apb.wData = wData;
  assign apb.write = write;
  assign apb.enable = enable;

  assign subErr = apb.subErr;
  assign rData = apb.rData;
  assign readyOut = apb.readyOut;

endmodule
