module GenericBusSubordinate_tl #(
    DataWidth = 32,
    AddrWidth = 32,
    ProtWidth = 4
) (
    input clk,
    input nReset,

    output logic sub_wEn,
    output logic sub_rEn,
    output logic [AddrWidth - 1:0] sub_addr,
    output logic [DataWidth - 1:0] sub_wData,
    output logic [DataWidth/8 - 1:0] sub_wStrb,

    output logic [DataWidth - 1:0] bus_rData,
    output logic bus_error,
    output logic bus_busy,

    input bus_wEn,
    input bus_rEn,
    input [AddrWidth - 1:0] bus_addr,
    input [DataWidth - 1:0] bus_wData,
    input [DataWidth/8 - 1:0] bus_wStrb,

    input [DataWidth - 1:0] sub_rData,
    input sub_error,
    input sub_busy,

    output logic sub_isBurst,
    output logic [1:0] sub_burstType,
    output logic [7:0] sub_burstLen,
    output logic sub_nonSec,
    output logic [ProtWidth - 1:0] sub_prot,

    input bus_isBurst,
    input [1:0] bus_burstType,
    input [7:0] bus_burstLen,
    input bus_nonSec,
    input [ProtWidth - 1:0] bus_prot
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

    sub.rData = sub_rData;
    sub.error = sub_error;
    sub.busy = sub_busy;

    sub_isBurst = sub.isBurst;
    sub_burstType = sub.burstType;
    sub_burstLen = sub.burstLen;
    sub_nonSec = sub.nonSec;
    sub_prot = sub.prot;
  end

  GenericBus_if #(DataWidth, AddrWidth, ProtWidth) bus (
      clk,
      nReset
  );

  always_comb begin
    bus.wEn = bus_wEn;
    bus.rEn = bus_rEn;
    bus.addr = bus_addr;
    bus.wData = bus_wData;
    bus.wStrb = bus_wStrb;

    bus_rData = bus.rData;
    bus_error = bus.error;
    bus_busy = bus.busy;

    bus.isBurst = bus_isBurst;
    bus.burstType = bus_burstType;
    bus.burstLen = bus_burstLen;
    bus.nonSec = bus_nonSec;
    bus.prot = bus_prot;
  end

  GenericBusSubordinate #(32'h100, 32'hFFFFFF00) bus_sub (
      sub,
      bus
  );

endmodule
