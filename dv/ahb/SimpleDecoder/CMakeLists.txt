target_sources(tests PRIVATE SimpleDecoder_tb.cpp)
nyu_add_sv(amba
  SimpleDecoder_tl.sv
)
list(APPEND TOP_MODULES SimpleDecoder_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)
