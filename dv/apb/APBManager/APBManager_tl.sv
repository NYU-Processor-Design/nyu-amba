module APBManager_tl #(
    DataWidth = 32,
    AddrWidth = 32,
    ProtWidth = 4,
    PrphNum   = 1
) (
    input clk,
    input nReset,

    // Managing Device signals
    input mgr_wEn,
    input mgr_rEn,
    input [AddrWidth - 1:0] mgr_addr,
    input [DataWidth - 1:0] mgr_wData,
    input [DataWidth/8 - 1:0] mgr_wStrb,
    input [ProtWidth - 1:0] mgr_prot,

    output logic [DataWidth - 1:0] mgr_rData,
    output logic mgr_error,
    output logic mgr_busy,

    // Bus signals
    input [AddrWidth - 1:0] bus_addr,          
    input [ProtWidth - 1:0] bus_prot,
    input bus_ready,                       
    input [DataWidth - 1:0] bus_rData,       
    input bus_subError,
                         
    output logic [PrphNum - 1:0] bus_selectors,       
    output logic bus_enable, 
    output logic bus_write,                       
    output logic [DataWidth - 1:0] bus_wData,       
    output logic [DataWidth/8 - 1:0] bus_strb,

    // Extraneous signals (source unknown)
    // Adjust localSel and localAddr -> Ask Vito
    input [PrphNum - 1:0] localSel, 
    output [AddrWidth-1:0] localAddr 
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

    mgr.prot = mgr_prot;
  end

  APBCommon_if #(DataWidth, AddrWidth, PrphNum) bus (
      clk,
      nReset
  );

  always_comb begin
    bus_write = bus.write;
    bus_enable = bus.enable;
    bus_wData = bus.wData;
    bus_strb = bus.strb;
    bus_selectors = bus.selectors;

    bus.addr = bus_addr;
    bus.rData = bus_rData;
    bus.subError = bus_subError;
    bus.ready = bus_ready;
    bus.prot = bus_prot;
  end

  APBManager bus_mgr (
      mgr,
      bus,
      localSel,
      localAddr
  );

endmodule

