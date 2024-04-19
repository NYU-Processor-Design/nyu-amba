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
    PrphNum   = 1
) (
    input clk,
    input nReset
);
  logic [AddrWidth - 1:0] addr;
  logic [3:0] prot;
  logic [PrphNum - 1:0] selectors;
  logic enable;
  logic write;
  logic [DataWidth - 1:0] wData;
  logic [DataWidth/8 - 1:0] strb;
  logic ready;
  logic [DataWidth - 1:0] rData;
  logic subError;

  modport bridge(
      input clk,
      input nReset,
      input rData,

      output selectors,
      output enable,
      output addr,
      output write,
      output wData
  );
  
    modport manager(
    input addr,          
    input prot,                     
    output selectors,       
    output enable,                        
    inout wData,       
    inout strb,   
    input ready,                       
    inout rData,       
    input subError
  );

endinterface

/*verilator coverage_on*/
