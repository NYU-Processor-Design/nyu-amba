/**
  @brief Dummy Subordinate for AMBA 5 AHB 
  
  @note See https://developer.arm.com/documentation/ihi0011/a/AMBA-AHB
        and Ch 1 and 2 of AMBA AHB Protocol Spec.

  
  @input ahb          AHB subordinate interface
  
  @logic error        Dummy error signal for testing
  @logic mem          Dummy memory for testing
  
  @logic state        State of the subordinate
 */

`include "AHBCommon_pkg.sv"

module SubDummy (
    AHBCommon_if.subordinate ahb
);
    //Dummy Memory and Signals for testing
    logic [ahb.DataWidth-1:0] mem [ahb.AddrWidth-1:0];

    logic [1:0] state;
    
    always_ff @(posedge ahb.clk or negedge ahb.nReset) begin 
        if (~ahb.nReset) begin
            ahb.readyOut <= 1'b1;
        end else begin
            //If subordinate is not selected, respond with okay and idle
            if (~ahb.sel) begin
                ahb.resp <= AHBCommon_pkg::RESP_OKAY;
                ahb.readyOut <= 1'b1;
                state <= AHBCommon_pkg::STATE_IDLE;
            end else begin
                case (ahb.trans)
                    //Manager is idle or busy
                    AHBCommon_pkg::TRANS_IDLE, AHBCommon_pkg::TRANS_BUSY: begin
                        case (state)
                            //Wait until transfer continues or ends
                            AHBCommon_pkg::STATE_IDLE, AHBCommon_pkg::STATE_READ, AHBCommon_pkg::STATE_WRITE: begin
                                ahb.readyOut <= 1'b1;
                            end
                            AHBCommon_pkg::STATE_ERROR: begin
                                //Only set readyOut to 1 if the manager returns to Idle
                                ahb.readyOut <= ahb.trans == AHBCommon_pkg::TRANS_IDLE;
                            end
                        endcase
                    end
                    //Manager is starting a new transfer
                    AHBCommon_pkg::TRANS_NONSEQ: begin
                        case (state)
                            //If not currently handling a transfer, start one
                            AHBCommon_pkg::STATE_IDLE: begin
                                //Perform read and writes to modules
                                if (ahb.write) begin
                                    mem[ahb.addr] <= ahb.wData;
                                    state <= AHBCommon_pkg::STATE_WRITE;
                                end else begin
                                    ahb.rData <= mem[ahb.addr];
                                    state <= AHBCommon_pkg::STATE_READ;
                                end
                            end
                            //If already reading or writing, reset the transfer
                            AHBCommon_pkg::STATE_READ, AHBCommon_pkg::STATE_WRITE, AHBCommon_pkg::STATE_ERROR: begin
                                state <= AHBCommon_pkg::STATE_IDLE;
                            end
                        endcase
                    end
                    AHBCommon_pkg::TRANS_SEQ: begin
                        //Doesn't do anything yet
                        state <= AHBCommon_pkg::STATE_IDLE;
                    end
                endcase
            end 
        end
    end
endmodule;
