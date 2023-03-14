/**
  @brief Common signals for a memory controller 
  
  @note See https://github.com/NYU-Processor-Design/nyu-mem
  
  @param DataWidth    bit-width of data transfers
  @param AddrWidth    bit-width of addresses

  @input clk      clock
  @input nReset   active-low-reset

  @logic addr       byte address of the transfer
  @logic wData      write data from memory to subordinates
  @logic write      transfer direction, high/write low/read
  
  @logic resp       response bus
  @logic rData      read data from subordinates to memory
*/
interface MemCommon_if #(
  DataWidth = 32,
  AddrWidth = 32
) (
  input clk,
  input nReset
);

  logic [AddrWidth - 1:0] addr;
  logic [DataWidth - 1:0] wData;
  logic write;

  logic [1:0] resp;
  logic [DataWidth - 1:0] rData;

  modport memCtrl(
    input addr,
    input wData,
    input write,

    output resp,
    output rData
  );

endinterface
