module GPIO #(
  PortWidth = 16
) (
    input sel,
    APBCommon_if.peripheral apb
);

    logic [PortWidth-1:0] PORTA;
    logic [PortWidth-1:0] DDRA;
    logic [PortWidth-1:0] PINA;
    
    always_ff @(posedge apb.clk or negedge apb.nReset) begin
        if (~apb.nReset) begin
            PORTA <= 0;
            DDRA <= 0;
            PINA <= 0;
        end else begin
            if (sel && apb.enable) begin
                case (apb.addr)
                    0: PORTA <= apb.wData;
                    1: DDRA <= apb.wData;
                    2: PINA <= apb.wData;
                    default: apb.subErr <= 1'b1;
                endcase
            end
        end
    end
endmodule
