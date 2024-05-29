target_sources(tests PRIVATE APBSubordinate.cpp)
nyu_add_sv(tests
  APBSubordinate_tl.sv
)
list(APPEND TOP_MODULES APBSubordinate_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)