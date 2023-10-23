`ifndef AHB_COMMON_PKG
`define AHB_COMMON_PKG

package AHBCommon_pkg;
  typedef enum bit [1:0] {
    RESP_OKAY,
    RESP_ERROR,
    RESP_RETRY,
    RESP_SPLIT
  } ahb_resp_t;

  typedef enum bit [1:0] {
    TRANS_IDLE,
    TRANS_BUSY,
    TRANS_NONSEQ,
    TRANS_SEQ
  } ahb_trans_t;

  typedef enum logic [1:0] {
    STATE_IDLE,
    STATE_READ,
    STATE_WRITE,
    STATE_ERROR
  } ahb_sub_state_t;

  typedef enum bit [2:0] {
    BURST_SINGLE,
    BURST_UNDEFINED_INCREMENT,
    BURST_WRAP_4,
    BURST_INCREMENT_4,
    BURST_WRAP_8,
    BURST_INCREMENT_8,
    BURST_WRAP_16,
    BURST_INCREMENT_16
  } ahb_burst_t;

endpackage

`endif  // AHB_COMMON_PKG
