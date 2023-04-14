/**
  @brief  AMBA 5 AHB Manager implementation

  @note See https://developer.arm.com/documentation/ihi0011/a/AMBA-AHB
      and Ch 1 and 2 of AMBA AHB Protocol Spec.

  @input ahb        AHB interface
  @input addr       address
  @input write      transfer direction, high/write low/read   
  @input size       transfer size
  @input wData      write data from manager to subordinates

  @output rData     read data from subordinate to manager
*/

// TODO REMOVE BEFORE COMPILATION
`include "AHBCommon_pkg.sv"

module Manager (
  AHBCommon_if.manager ahb,

  input [ahb.AddrWidth - 1:0] addr,
  input write,
  input [2:0] size,
  input [ahb.DataWidth - 1:0] wData,

  output [ahb.AddrWidth - 1:0] rData,
);
  
  logic [1:0] state; // Phase manager is in

  always_ff @(posedge ahb.clk or negedge ahb.nReset) begin
    if (~ahb.nReset) begin
      // Reset address and controls
      {ahb.addr, ahb.write, ahb.size, ahb.burst, ahb.prot, ahb.mastLock} <= 0;
      ahb.trans <= AHBCommon_pkg::TRANS_IDLE;

      // Manager is doing nothing
      state <= AHBCommon_pkg::MANAGER_IDLE;
    end
  end

  always_comb 
    case (state)
      // We assume being idle is a manager's defaulty state
      default: ;
        
      AHBCommon_pkg::MANAGER_ADDR: ;

      AHBCommon_pkg::MANAGER_DATA: ;
    endcase

endmodule
