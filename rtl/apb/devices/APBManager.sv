/**
  @brief Manager that uses the AMBA APB protocol directly as the transmission
    protocol

  @input device     managing device
  @input bus        bus to managed
 */

module APBManager (
    GenericBus_if device,
    APBCommon_if bus,
    input [bus.PrphNum - 1:0] localSel, 
    output [bus.AddrWidth-1:0] localAddr    
);
  always_comb begin
    device.rData = bus.rData;
    bus.wData = device.wData;
    bus.addr = device.addr;
    localAddr = device.addr;
    bus.selectors = localSel;
  end
// Always_comb must have something for every situation
  always_comb begin
    bus.prot = device.prot;
    bus.strb = device.wStrb;
    bus.write = device.wEn && !device.rEn;
    bus.enable = device.wEn ^ device.rEn;
  end
// wEn and rEn both being high is meaningless in generic -> check this in test bench
// Generic pov -> device tells you it's done by wEn going low -> done writing
// Assume for generic, rEn goes up for single cycle
  always_comb begin
    device.busy = !bus.ready;
    device.error = bus.subError;
  end
endmodule
