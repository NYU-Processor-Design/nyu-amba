module GPIO #(
  PortWidth = 16
) (
    input sel,
    APBCommon_if.peripheral apb,
    input [PortWidth-1:0] PINA,
    inout [PortWidth-1:0] PORTA_PINS
);

    logic [PortWidth-1:0] PORTA;
    logic [PortWidth-1:0] DDRA;
    // logic [PortWidth-1:0] PINA;
    genvar i;
    generate
        for (i = 0; i < PortWidth; i = i + 1) begin
            assign PORTA_PINS[i] = DDRA[i] == 1'b1 ? PORTA[i] : PINA[i];
        end
    endgenerate
    
    always_ff @(posedge apb.clk or negedge apb.nReset) begin
        if (~apb.nReset) begin
            PORTA <= 0;
            DDRA <= 0;
            apb.subErr <= 1'b0;
        end else begin
            if (sel && apb.enable) begin
                if (apb.write) begin
                    case (apb.addr)
                        0: PORTA <= apb.wData[PortWidth-1:0];
                        1: DDRA <= apb.wData[PortWidth-1:0];
                        default: apb.subErr <= 1'b1;
                    endcase
                end else begin
                    case (apb.addr)
                        0: apb.rData <= {{(apb.AddrWidth-PortWidth){1'b0}}, PORTA};
                        1: apb.rData <= {{(apb.AddrWidth-PortWidth){1'b0}}, DDRA};
                        2: apb.rData <= {{(apb.AddrWidth-PortWidth){1'b0}}, PORTA_PINS};
                        default: apb.subErr <= 1'b1;
                    endcase
                end
            end
        end
    end
endmodule
