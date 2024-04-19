// Used GenericBusManager.sv as template for outline

/**
  @brief Manager that uses the GenericBus protocol directly as the transmission
    protocol

  @input device     managing device
  @input bus        bus to managed
 */

module APBManager (
    APBCommon_if bus,
    APBCommon_if bridge
);
  always_comb begin
    bridge.rData = bus.rData;
    bridge.subError <= bus.subError;
  end

  always_ff @(posedge bridge.clk, negedge bridge.nReset) begin
    if (!bridge.nReset) begin
      bus.write <= 0;
      bus.addr <= 0;
      bus.wData <= 0;
      bus.prot <= 0;
      bus.enable <= 0;

    /** 
    - Alert subordinate that we're writing to it
    - Set up write and enable
    - Check ready signal 
    **/    
    end else if (!bus.ready || !bus.enable) begin // wake up bus
      bus.sel[bridge.sel] <= 1;
    end else if (bus.ready && !bus.enable) begin
      bus.enable <= 1;
      bus.write <= bridge.write;
      bus.addr <= bridge.addr;
      bus.prot <= bridge.prot;
      bus.wData <= bridge.wData;
    end else if (bus.subError) begin
      bus.enable = 0;
    end
  end
endmodule

/**
APB Interface Signals
NEED TO GIVE DIRECTION -> Logic just says we care about variable

  input [AddrWidth-1:0] addr;           // Address bus
  input [3:0] prot;                     // protected piece of mail 
  output [PrphNum-1:0] selectors;       // sending a bit on the selector on bus where peripherals live; 
  think as array of subordinates live (bit will let subordinate to get ready) -> Read APB Spec for more detail
                                        // To know where each subordinate lives, address is sent to decoder & 
                                        decoder tells us which subordinate we need to talk to in array
  output enable;                        // Bit that tells us if person is getting multiple "packages"
  output write;
  inout [DataWidth - 1:0] wData;        // 1 of 2 Data Buses
  inout(?) [DataWidth/8 - 1:0] strb;    // Ignore bc AHB ignores strobe 
  input ready;                        
  inout [DataWidth - 1:0] rData;        // 2 of 2 Data buses
  input subError;


My APB will support up to 8 subordinates
**/