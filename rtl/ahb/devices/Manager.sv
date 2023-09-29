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

  output [ahb.AddrWidth - 1:0] rData
);
  
  AHBCommon_pkg::ahb_man_state_t state; // Phase manager is in

  always_ff @(posedge ahb.clk or negedge ahb.nReset) begin
    if (~ahb.nReset) 
      // Reset address and controls
      {ahb.addr, ahb.write, ahb.size, ahb.burst, ahb.prot, ahb.mastLock} <= 0;
      ahb.trans <= AHBCommon_pkg::TRANS_IDLE;

      // Manager is doing nothing
      state <= AHBCommon_pkg::MANAGER_IDLE;
  end

  localparam burst_count = 0;
  localparam burst_size = 0;

  always_comb 
    case (state)
      // We assume being idle is a manager's defaulty state
      default: ;

      AHBCommon_pkg::MANAGER_ADDR: begin
        ahb.addr = addr;
        ahb.write = write;
        ahb.size = size;

        /* TODO
          Check for valid burst
          Decide what that signal is:
            - just send and hope for the best (bad)
            - watch trans and wait for it to be driven by sub
            - something else?
          Decide transfer type
          Decide burst type if burst
          Decide transfer protection
        */
        if (1 /* TODO some cond */) begin
          // Initialize burst transfer
          state <= AHBCommon_pkg::MANAGER_ADDR;
        end

        // Transition to data phase
        state = AHBCommon_pkg::MANAGER_DATA;
      end

      AHBCommon_pkg::MANAGER_DATA: begin
        // Depending on transfer type, drive data
        if (write) 
          ahb.wData = wData;
        else
          rData = ahb.rData;

        // If data phase is over
        if (ahb.ready) 
          // Check for end of burst
          if (burst_count == burst_size)
            // End of burst, transition to IDLE
            state <= AHBCommon_pkg::MANAGER_IDLE;
          else
            // Continue burst
            // ! might have to store addr in a localparam
            ahb.addr <= ahb.addr + (1 << burst_size);
            burst_count <= burst_count + 1;
            state <= AHBCommon_pkg::MANAGER_ADDR;

        if (ahb.ready)
          state = AHBCommon_pkg::MANAGER_IDLE;
      end
    endcase

endmodule
