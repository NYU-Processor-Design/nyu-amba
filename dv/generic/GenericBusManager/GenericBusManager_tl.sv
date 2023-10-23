module GenericBusManager_tl #(
    DataWidth = 32,
    AddrWidth = 32,
    ProtWidth = 4
) (
    input clk,
    input nReset,

    input mgr_wEn,
    input mgr_rEn,
    input [AddrWidth - 1:0] mgr_addr,
    input [DataWidth - 1:0] mgr_wData,
    input [DataWidth/8 - 1:0] mgr_wStrb,

    input [DataWidth - 1:0] bus_rData,
    input bus_error,
    input bus_busy,

    output logic bus_wEn,
    output logic bus_rEn,
    output logic [AddrWidth - 1:0] bus_addr,
    output logic [DataWidth - 1:0] bus_wData,
    output logic [DataWidth/8 - 1:0] bus_wStrb,

    output logic [DataWidth - 1:0] mgr_rData,
    output logic mgr_error,
    output logic mgr_busy,

    input mgr_isBurst,
    input [1:0] mgr_burstType,
    input [7:0] mgr_burstLen,
    input mgr_nonSec,
    input [ProtWidth - 1:0] mgr_prot,

    output logic bus_isBurst,
    output logic [1:0] bus_burstType,
    output logic [7:0] bus_burstLen,
    output logic bus_nonSec,
    output logic [ProtWidth - 1:0] bus_prot
);

  GenericBus_if #(DataWidth, AddrWidth, ProtWidth) mgr (
      clk,
      nReset
  );

  always_comb begin
    mgr.wEn = mgr_wEn;
    mgr.rEn = mgr_rEn;
    mgr.addr = mgr_addr;
    mgr.wData = mgr_wData;
    mgr.wStrb = mgr_wStrb;

    mgr_rData = mgr.rData;
    mgr_error = mgr.error;
    mgr_busy = mgr.busy;

    mgr.isBurst = mgr_isBurst;
    mgr.burstType = mgr_burstType;
    mgr.burstLen = mgr_burstLen;
    mgr.nonSec = mgr_nonSec;
    mgr.prot = mgr_prot;
  end

  GenericBus_if #(DataWidth, AddrWidth, ProtWidth) bus (
      clk,
      nReset
  );

  always_comb begin
    bus_wEn = bus.wEn;
    bus_rEn = bus.rEn;
    bus_addr = bus.addr;
    bus_wData = bus.wData;
    bus_wStrb = bus.wStrb;

    bus.rData = bus_rData;
    bus.error = bus_error;
    bus.busy = bus_busy;

    bus_isBurst = bus.isBurst;
    bus_burstType = bus.burstType;
    bus_burstLen = bus.burstLen;
    bus_nonSec = bus.nonSec;
    bus_prot = bus.prot;
  end

  GenericBusManager bus_mgr (
      mgr,
      bus
  );

endmodule
