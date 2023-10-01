/*verilator coverage_off*/

/**
  @brief Common signals for a single-manager AMBA 5 APB Interface

  @note See https://developer.arm.com/documentation/ihi0011/a/AMBA-APB
        and Ch 1 and 2 of AMBA APB Protocol Spec.

  @param DataWidth    bit-width of data transfers
  @param AddrWidth    bit-width of addresses
  @param PrphNum      number of peripherals

  @input clk          clock
  @input nReset       active-low-reset

  @logic addr         byte address of the transfer
  @logic prot         protection control signal (access type information)
  @logic selectors    selector bus for the peripherals, each lane is one prph
  @logic enable       enable for second and subsequent transfer cycles
  @logic write        transfer direction, high/write low/read
  @logic wData        write data from manager to peripherals
  @logic strb         write strobe
  @logic ready        indicates completion of previous transfer
  @logic rData        read data from peripherals to mux
  @logic subError     transfer error, high/error low/okay
 */
interface APBCommon_if #(
  AddrWidth = 32,
  DataWidth = 32,
  ProtWidth = 4,
  PrphNum = 1
) (
    input clk,
    input nReset
);
  // bridge signals
  logic [PrphNum - 1:0] selectors;
  logic [AddrWidth - 1:0] addr;
  logic [ProtWidth - 1:0] prot;
  logic [DataWidth - 1:0] wData;
  logic write;
  logic ready;
  logic sel;
  logic enable;

  // peripheral signals
  logic [DataWidth - 1:0] rData;
  logic readyOut;
  logic subErr;

  modport bridge(
    input clk,
    input nReset,

    input ready,
    
    input rData,

    output selectors,
    output addr,
    output write,
    output prot,

    output wData,
    output sel,
    output enable
  );

  modport peripheral(
    input clk,
    input nReset,

    input addr,
    input write,
    input prot,
    input ready,
    input sel,
    input wData,
    input enable,

    output readyOut,
    output subErr,

    output rData
  );

endinterface

/*verilator coverage_on*/
