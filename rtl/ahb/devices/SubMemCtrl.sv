/**
  @brief Subordinate to interface witht he memory controller

  @note See https://github.com/NYU-Processor-Design/nyu-mem
*/

/**
  @brief Subordinate to interface witht he memory controller

  @note See https://github.com/NYU-Processor-Design/nyu-mem
*/

module SubMemCtrl #(
    parameter ADDR_WIDTH = 32,  // Address width
    parameter DATA_WIDTH = 32   // Data width
)(
    input wire                       HCLK,       // clock
    input wire                       HRESETn,    // reset
    input wire [ADDR_WIDTH-1:0]      HADDR,      // address
    input wire                       HWRITE,     // write
    input wire [1:0]                 HTRANS,     // transfer
    input wire [2:0]                 HSIZE,      // tranfer size
    input wire [DATA_WIDTH-1:0]      HWDATA,     // write data
    output wire [DATA_WIDTH-1:0]     HRDATA,     // read data
    output wire                      HREADY,     // transfer ready
    output wire [1:0]                HRESP,      // transfer response
    // Memory Controller Interface
    output wire [ADDR_WIDTH-1:0]     MemAddr,    // Memory address
    output wire                      MemWrite,   // Memory write enable
    output wire [DATA_WIDTH-1:0]     MemWData,   // Memory write data
    input wire [DATA_WIDTH-1:0]      MemRData,   // Memory read data
    output wire                      MemReq,     // Memory request signal
    input wire                       MemReady    // Memory ready signal
);

    reg [DATA_WIDTH-1:0] internalRData;
    reg                   internalReady;
    reg [1:0]             internalResp;

    assign HRDATA = internalRData;
    assign HREADY = internalReady;
    assign HRESP = internalResp;
    
    assign MemAddr = HADDR;
    assign MemWrite = HWRITE && (HTRANS[1] && HREADY);  // init write
    assign MemWData = HWDATA;
    assign MemReq = HTRANS[1] && HREADY;  // Transfer request signal

    // AHB to Memory Controller Interface Logic
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            internalRData <= 0;
            internalReady <= 0;
            internalResp <= 2'b00; // OKAY
        end else begin
            internalReady <= MemReady;
            if (MemReady) begin
                if (HWRITE) begin
                    // handle write
                    internalResp <= 2'b00; // OKAY
                end else begin
                    // handle read
                    internalRData <= MemRData;
                    internalResp <= 2'b00; // OKAY
                end
            end else begin
                internalResp <= 2'b01; // WAIT state
            end
        end
    end

endmodule


