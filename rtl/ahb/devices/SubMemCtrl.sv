

/**
  @brief Dummy Subordinate for AMBA 5 AHB 
  
  @note See https://developer.arm.com/documentation/ihi0011/a/AMBA-AHB
        and Ch 1 and 2 of AMBA AHB Protocol Spec.

  
  @input ahb          AHB subordinate interface
  
  @logic error        Dummy error signal for testing
  @logic mem          Dummy memory for testing
  
  @logic state        State of the subordinate
 */
// TODO Comment before compilation; remove before PR
// `include "AHBCommon_pkg.sv"

module SubMemCtrl (
    AHBCommon_if.subordinate ahb,
    MemCommom_if.subordinate mem
);
    // import AHBCommon_pkg::*;
    //Dummy Memory and Signals for testing

    logic [1:0] state;
    logic [31:0] addr;

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
                case (mem.resp)
                  AHBCommon_pkg::RESP_ERROR: state <= AHBCommon_pkg::STATE_ERROR;
                endcase
                case (ahb.trans)
                    //Manager is idle or busy
                    AHBCommon_pkg::TRANS_IDLE: begin
                        case (state)
                            //Wait until transfer continues or ends
                            AHBCommon_pkg::STATE_IDLE, AHBCommon_pkg::STATE_READ, AHBCommon_pkg::STATE_WRITE: begin
                                ahb.readyOut <= 1'b1;
                            end
                            AHBCommon_pkg::STATE_ERROR: begin
                                //Only set readyOut to 1 if the manager returns to Idle
                                ahb.readyOut <= 1'b0;
                                state <= AHBCommon_pkg::STATE_IDLE;
                            end
                        endcase
                    end
                    AHBCommon_pkg::TRANS_BUSY: begin
                        //Doesn't do anything yet
                        ahb.readyOut <= mem.readyOut;
                    end
                    //Manager is starting a new transfer
                    AHBCommon_pkg::TRANS_NONSEQ: begin
                        case (state)
                            AHBCommon_pkg::STATE_IDLE, AHBCommon_pkg::STATE_READ, AHBCommon_pkg::STATE_WRITE: begin
                                mem.write <= ahb.write;      
                                if (ahb.write) begin
                                    state <= AHBCommon_pkg::STATE_WRITE;
                                end else begin
                                    state <= AHBCommon_pkg::STATE_READ;
                                end
                            end
                            AHBCommon_pkg::STATE_ERROR: begin end
                        endcase
                    end
                    AHBCommon_pkg::TRANS_SEQ: begin
                        case (ahb.burst)
                          AHBCommon_pkg::BURST_UNDEFINED_INCREMENT: begin
                            addr <= addr + (1 << ahb.size);
                          end
                          default:
                            state <= AHBCommon_pkg::STATE_ERROR;
                        endcase
                    end
                endcase
                case (state)
                  AHBCommon_pkg::STATE_ERROR: begin
                    state <= AHBCommon_pkg::STATE_ERROR;
                    ahb.resp <= RESP_ERROR;
                    ahb.readyOut <= 1'b1;
                  end
                  AHBCommon_pkg::STATE_READ: begin
                    ahb.rData <= mem.rData;
                  end
                  AHBCommon_pkg::STATE_WRITE: begin
                    mem.wData <= ahb.wData;
                  end
                endcase
            end 
        end
    end
endmodule;
