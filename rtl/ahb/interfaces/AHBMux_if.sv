/**
  @brief Interface between an AMBA 5 multiplexor and a single peripheral

  @note See https://www.arm.com/architecture/system-architectures/amba/amba-5

  @param DataWidth  bit-width of data transfers

  @logic rData    read data from Prph -> Mux
  @logic readyOut if previous transfer in complete
  @logic resp     status of transfer
*/

interface AHBMux_if #(
    DataWidth = 32
);
  logic [DataWidth - 1:0] rData;
  logic readyOut;
  logic resp;

  modport prph(output rData, output readyOut, output resp);

  modport mux(input rData, input readyOut, input resp);
endinterface
