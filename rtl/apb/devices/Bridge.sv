/**
  @brief APB Bridge implementation

  @note See https://developer.arm.com/documentation/ihi0011/a/AMBA-APB/APB-bridge/Interface-diagram
*/
module Bridge (
    AHBCommon_if.subordinate sub,
    APBCommon_if.bridge bridge
);
    //three states
    typedef enum logic [1:0] {
        IDLE,
        SETUP,
        ENABLE
    } state_t;

    //signals
    state_t state = IDLE;
    logic [31:0] write_data_buffer;
    logic [31:0] read_data_buffer;
    logic [31:0] address_buffer;
    logic write_buffer;
    logic setup_done;

    //interface the two modports here
    always_ff @(posedge sub.clk or negedge sub.nReset) begin
        if (!sub.nReset) begin
            state <= IDLE;
            sub.readyOut <= 1'b0; //will be set when finished
            sub.rData <= 32'd0; //Clear the read data buffer on the AHB side
            sub.resp <= 2'b00; //set default response to ok
            bridge.addr <= 32'd0;//this buffer holds the address for the next APB transaction.
            bridge.write <= 1'b0; //this is used to indicate the next operation is not a write by default
            bridge.wData <= 32'd0; // store data that is to be written to the APB bus during a write transaction
            bridge.selectors <= 1'b0; //select which peripheral on the APB bus should be active for the next transaction
            bridge.enable <= 1'b0;
            write_data_buffer <= 32'd0;
            read_data_buffer <= 32'd0;
            address_buffer <= 32'd0;
            write_buffer <= 1'b0; //if set, write operation; if not, read operation
            setup_done <= 1'b0; //flag that indicates if the setup stage of the current APB transaction is complete
        end else begin
            case (state)
                IDLE: begin //wait for AHB signal
                    if (sub.sel && !setup_done) begin
                        address_buffer <= sub.addr;
                        write_buffer <= sub.write;
                        write_data_buffer <= sub.wData;
                        state <= SETUP;
                    end
                end
                SETUP: begin
                    //set up APB transfer
                    bridge.selectors <= 1'b1; //select the peripheral
                    bridge.addr <= address_buffer;
                    bridge.write <= write_buffer;
                    bridge.wData <= write_data_buffer;
                    bridge.enable <= 1'b0;
                    setup_done <= 1'b1;
                    state <= ENABLE;
                end
                ENABLE: begin
                    //enable APB transfer and wait for the ready signal
                    bridge.enable <= 1'b1;
                    if (bridge.ready) begin
                        //complete the AHB transfer
                        sub.readyOut <= 1'b1;
                        if (!write_buffer) begin
                            read_data_buffer <= bridge.rData;
                        end
                        sub.resp <= 2'b00; //okresponse
                        state <= IDLE;
                        setup_done <= 1'b0;
                    end
                end
            endcase
        end
    end

    //read data back to AHB
    always_comb begin
        if (!write_buffer && sub.sel) begin
            sub.rData = read_data_buffer;
        end else begin
            sub.rData = 32'bz;
        end
    end
endmodule
