/**
  @brief Common Signals for a single-controller AMBA 5 AHB Interface

  @note See https://www.arm.com/architecture/system-architectures/amba/amba-5

  @param DataWidth  bit-width of data transfers
  @param AddrWidth  bit-width of an address
  @param PrphNum    number of peripherals supported by the interface
*/

module SimpleDecoder #(
    PrphNum = 2
) (
    AHBCommon_if.decoder ahb,
    output [PrphNum - 1:0] sel
);

  localparam selWidth = $clog2(PrphNum);

  logic [selWidth - 1:0] prph = ahb.addr[ahb.AddrWidth-1:ahb.AddrWidth-selWidth];

  always_ff @(posedge ahb.clk, negedge ahb.nReset) begin
    if (!ahb.nReset) sel <= '0;
    else sel <= 1 << prph;
  end

endmodule
