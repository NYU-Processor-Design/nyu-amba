/**
  @brief Common signals for a single-manager AMBA 5 AHB Interface
  
  @note See https://developer.arm.com/documentation/ihi0011/a/AMBA-AHB
        and Ch 1 and 2 of AMBA AHB Protocol Spec.
  
  @param DataWidth    bit-width of data transfers
  @param AddrWidth    bit-width of addresses
  @param ProtWidth    bit-width of protection signal controller
  
  @input clk      clock
  @input nReset   active-low-reset
  
  @logic addr       byte address of the transfer
  @logic burst      number of transfers in the burst
  @logic mastLock   if current transfer is part of a locked sequence
  @logic prot       protection control signal (access type information)
  @logic size       size of the transfer
  @logic nonSec     if the transfer is non-secure
  @logic excl       if the transfer is part of an exvlusive access sequence
  @logic trans      transfer type
  @logic wData      write data from manager to subordinates
  @logic wStrb      write strobe
  @logic write      transfer direction, high/write low/read
  @logic ready      indicates completion of previous transfer
  
  @logic rData      read data from subordinates to mux
  @logic readyOut   indicates completion of transfer
  @logic resp       transfer status
  @logic exOkay     status of exclusive transfer
 */
interface AHBCommon_if #(
  DataWidth = 32,
  AddrWidth = 32,
  ProtWidth = 4
) (
  input clk,
  input nReset
);
  // Manager signals
  logic [AddrWidth - 1:0] addr;
  logic [2:0] burst;
  logic mastLock;
  logic [ProtWidth - 1:0] prot;
  logic [3:0] size;
  logic nonSec;
  logic excl;
  logic [2:0] trans;
  logic [DataWidth - 1:0] wData;
  logic [DataWidth/8 - 1:0] wStrb;
  logic write;
  logic ready;

  // Subordinate signals
  logic [DataWidth - 1:0] rData;
  logic readyOut;
  logic [1:0] resp;
  logic exOkay;

  modport manager(
    input clk,
    input nReset,

    input ready,
    input resp,
    
    input rData,

    output addr,
    output write,
    output size,
    output burst,
    output prot,
    output trans,
    output mastLock,

    output wData
  );

  modport subordinate(
    input clk,
    input nReset,

    input addr,
    input write,
    input size,
    input burst,
    input prot,
    input trans,
    input mastLock,
    input ready,

    input wData,

    output readyOut,
    output resp,

    output rData
  );

  modport mux(
    input clk,
    input nReset,

    output resp,
    output exOkay,
    output ready,
    output rData
  );

  modport decoder(
    input clk,
    input nReset,

    input addr,
    input nonSec
  );

endinterface
