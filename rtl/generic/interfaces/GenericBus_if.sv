/**
  @brief Generic bus protocol, suitable to be used with a variety of different
    bus interfaces

  @param DataWidth  bit-width of data transfers
  @param AddrWidth  bit-width of addresses
  @param ProtWidth  bit-width of protection signal controller

  @input clk        clock
  @input nReset     active low reset

  @logic addr       address of the transfer (base relative)
  @logic wEn        request is a write
  @logic rEn        request is a read

  @logic wStrb      write strobe
  @logic wData      write data
  @logic rData      read data
  @logic busy       stall request from peripheral
  @logic error      error condition indication to bus

  @logic isBurst    signals burst transfer
  @logic burstType  type of burst
  @logic burstLen   size of burst
  @logic prot       protection control signal (access type information)
  @logic nonSec     signals non-secure transfer
 */
interface GenericBus_if #(
    DataWidth = 32,
    AddrWidth = 32,
    ProtWidth = 4
) (
    input clk,
    input nReset
);

  logic [AddrWidth - 1:0] addr;
  logic wEn;
  logic rEn;

  logic [DataWidth/8 - 1:0] wStrb;
  logic [DataWidth - 1:0] wData;
  logic [DataWidth - 1:0] rData;
  logic busy;
  logic error;

  logic isBurst;
  logic [1:0] burstType;
  logic [7:0] burstLen;
  logic nonSec;
  logic [ProtWidth - 1:0] prot;

  modport subVital(
      input clk,
      input nReset,

      input wEn,
      input rEn,
      input addr,
      input wData,
      input wStrb,

      output rData,
      output error,
      output busy
  );

  modport subHint(  //
      input isBurst,
      input burstType,
      input burstLen,
      input nonSec,
      input prot
  );

  modport mgrVital(
      input clk,
      input nReset,

      output wEn,
      output rEn,
      output addr,
      output wData,
      output wStrb,

      input rData,
      input error,
      input busy
  );

  modport mgrHint(  //
      output isBurst,
      output burstType,
      output burstLen,
      output nonSec,
      output prot
  );
endinterface
