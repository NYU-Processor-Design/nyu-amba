/**
  @brief Common Signals for a single-controller AMBA 5 AHB Interface

  @note See https://www.arm.com/architecture/system-architectures/amba/amba-5

  @param DataWidth  bit-width of data transfers
  @param AddrWidth  bit-width of an address
  @param SubordinateNum    number of peripherals supported by the interface
*/

module SimpleDecoder #(
    SubordinateNum = 2
) (
    AHBCommon_if.decoder ahb,
    output [SubordinateNum - 1:0] sel
);

  localparam selWidth = $clog2(SubordinateNum);

  logic [selWidth - 1:0] subordinate = ahb.addr[ahb.AddrWidth-1:ahb.AddrWidth-selWidth];

  always_ff @(posedge ahb.clk, negedge ahb.nReset) begin
    if (!ahb.nReset) sel <= '0;
    else sel <= 1 << subordinate;
  end

endmodule
