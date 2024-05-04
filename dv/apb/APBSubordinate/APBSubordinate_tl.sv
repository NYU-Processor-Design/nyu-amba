module APBSubordinate_tl #(
    DataWidth = 32,
    AddrWidth = 32,
    ProtWidth = 4,
    PrphNum   = 1
) (
    input clk,
    input nReset,

    output logic sub_wEn,
    output logic sub_rEn,
    output logic [AddrWidth - 1:0] sub_addr,
    output logic [DataWidth - 1:0] sub_wData,
    output logic [DataWidth/8 - 1:0] sub_wStrb,
    output logic [ProtWidth - 1:0] sub_prot,

    input [DataWidth - 1:0] sub_rData,
    input sub_error,
    input sub_busy,

    input bus_write,
    input bus_enable,
    input [AddrWidth - 1:0] bus_addr,
    input [DataWidth - 1:0] bus_wData,
    input [DataWidth/8 - 1:0] bus_strb,
    input [ProtWidth - 1:0] bus_prot,
    input [PrphNum - 1:0] bus_selectors,

    output logic [DataWidth - 1:0] bus_rData,
    output logic bus_subError,
    output logic bus_ready

);

  GenericBus_if #(DataWidth, AddrWidth, ProtWidth) sub (
      clk,
      nReset
  );

  always_comb begin
    sub_wEn = sub.wEn;
    sub_rEn = sub.rEn;
    sub_addr = sub.addr;
    sub_wData = sub.wData;
    sub_wStrb = sub.wStrb;
    sub_prot = sub.prot;

    sub.rData = sub_rData;
    sub.error = sub_error;
    sub.busy = sub_busy;
  end

  APBCommon_if #(DataWidth, AddrWidth, PrphNum) bus (
      clk,
      nReset
  );

  always_comb begin
    bus.write = bus_write;
    bus.enable = bus_enable;
    bus.addr = bus_addr;
    bus.wData = bus_wData;
    bus.strb = bus_strb;
    bus.prot = bus_prot;
    bus.selectors = bus_selectors;

    bus_rData = bus.rData;
    bus_subError = bus.subError;
    bus_ready = bus.ready;
  end

  APBSubordinate #(32'h100, 32'hFFFFFF00) bus_sub (
      sub,
      bus
  );

endmodule
