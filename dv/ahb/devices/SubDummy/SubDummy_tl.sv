module SubDummy_tl (
    input logic clk
);
logic nReset;

AHBCommon_if ahb_com_if ( clk, nReset );

SubDummy sd ( ahb_com_if.subordinate );

endmodule
