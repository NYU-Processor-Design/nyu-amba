/**
  @brief Manager that uses the GenericBus protocol directly as the transmission
    protocol

  @input device     managing device
  @input bus        bus to managed
 */
module GenericBusManager (
    GenericBus_if device,
    GenericBus_if bus
);
  always_comb begin
    device.rData = bus.rData;
    device.error = bus.error;
    device.busy  = bus.busy;
  end

  always_ff @(posedge device.clk, negedge device.nReset) begin
    if (!device.nReset) begin
      bus.wEn <= 0;
      bus.rEn <= 0;
      bus.addr <= 0;
      bus.wStrb <= 0;
      bus.wData <= 0;

      bus.isBurst <= 0;
      bus.burstType <= 0;
      bus.burstLen <= 0;
      bus.nonSec <= 0;
      bus.prot <= 0;
    end else if (!bus.busy || (!bus.rEn && !bus.wEn)) begin
      bus.wEn <= device.wEn;
      bus.rEn <= device.rEn;
      bus.addr <= device.addr;
      bus.wStrb <= device.wStrb;
      bus.wData <= device.wData;

      bus.isBurst <= device.isBurst;
      bus.burstType <= device.burstType;
      bus.burstLen <= device.burstLen;
      bus.nonSec <= device.nonSec;
      bus.prot <= device.prot;
    end
  end
endmodule
