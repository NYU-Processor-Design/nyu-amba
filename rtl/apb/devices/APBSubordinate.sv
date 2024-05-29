/**
  @brief Subordinate that uses the AMBA APB protocol directly as the
    transmission protocol

  @param BaseAddr  minimum address in the device address range
  @param AddrMask  (OPTIONAL) mask to be applied to bus address before 
                   comparison to BaseAddr

  @input device     subordinate device
  @input bus        managing bus
 */

module APBSubordinate #(
    BaseAddr = AddrWidth'(0),
    AddrMask = AddrWidth'('1)
) (
    GenericBus_if device,
    APBCommon_if bus
);

  localparam AddrWidth = bus.AddrWidth;

  always_comb begin
    if (bus.selectors) begin
      device.wEn  = bus.enable && bus.write;
      device.rEn  = bus.enable && !bus.write;
      device.addr = bus.addr - BaseAddr;
    end else begin
      device.wEn  = 0;
      device.rEn  = 0;
      device.addr = 0;
    end
    device.wData = bus.wData;
    device.wStrb = bus.strb;
    device.prot = bus.prot;

    bus.rData = device.rData;
    bus.subError = device.error;
    bus.ready = !device.busy;
  end
endmodule
