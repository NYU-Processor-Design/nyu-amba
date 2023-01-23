/**
  @brief Common Signals for a single-controller AMBA 5 AHB Interface

  @note See https://www.arm.com/architecture/system-architectures/amba/amba-5

  @param DataWidth  bit-width of data transfers
  @param AddrWidth  bit-width of an address
  @param PrphNum    number of peripherals supported by the interface

  @input clk    clock
  @input nReset active-low reset

  @logic addr     byte address of the transfer
  @logic burst    number of transfers in the burst
  @logic mastLock if current transfer is part of a locked sequence
  @logic size     size of the transfer
  @logic nonSec   if transfer is non-secure
  @logic trans    transfer type
  @logic wData    write data from Ctrl -> Prph
  @logic wStrb    write strobe
  @logic write    transfer direction, high/write low/read

  @logic rData    read data from Mux -> Ctrl
  @logic ready    if previous transfer in complete
  @logic resp     status of transfer
*/
interface AHBCommon_if #(
    DataWidth = 32,
    AddrWidth = 32
) (
    input clk,
    input nReset
);
  logic [AddrWidth - 1:0] addr;
  logic [2:0] burst;
  logic mastLock;
  logic [2:0] size;
  logic nonSec;
  logic [1:0] trans;
  logic [DataWidth - 1:0] wData;
  logic [DataWidth/8 - 1:0] wStrb;
  logic write;

  logic [DataWidth - 1:0] rData;
  logic ready;
  logic resp;

  modport ctrl(
      input clk,
      input nReset,

      output addr,
      output burst,
      output mastLock,
      output size,
      output nonSec,
      output trans,
      output wData,
      output wStrb,
      output write,

      input rData,
      input ready,
      input resp
  );

  modport prph(
      input clk,
      input nReset,

      input addr,
      input burst,
      input mastLock,
      input size,
      input nonSec,
      input trans,
      input wData,
      input wStrb,
      input write,

      input ready
  );

  modport decoder(input clk, input nReset, input addr, input nonSec);

  modport mux(input clk, input nReset, output rData, output ready, output resp);
endinterface
