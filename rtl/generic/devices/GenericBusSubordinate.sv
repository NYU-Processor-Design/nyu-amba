/**
  @brief Subordinate that uses the GenericBus protocol directly as the
    transmission protocol

  @input device     subordinate device
  @input bus        managing bus
 */
module GenericBusSubordinate #(
    BaseAddr = AddrWidth'(0),
    AddrMask = AddrWidth'('1)
) (
    GenericBus_if device,
    GenericBus_if bus
);

  localparam AddrWidth = bus.AddrWidth;

  always_comb begin
    if ((bus.addr & AddrMask) == BaseAddr) begin
      device.wEn  = bus.wEn;
      device.rEn  = bus.rEn;
      device.addr = bus.addr - BaseAddr;
    end else begin
      device.wEn  = 0;
      device.rEn  = 0;
      device.addr = 0;
    end

    device.wData = bus.wData;
    device.wStrb = bus.wStrb;
    device.isBurst = bus.isBurst;
    device.burstType = bus.burstType;
    device.burstLen = bus.burstLen;
    device.nonSec = bus.nonSec;
    device.prot = bus.prot;

    bus.rData = device.rData;
    bus.error = device.error;
    bus.busy = device.busy;
  end
endmodule
