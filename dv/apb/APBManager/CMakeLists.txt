target_sources(tests PRIVATE APBManager.cpp)
nyu_add_sv(tests
  APBManager_tl.sv
)
list(APPEND TOP_MODULES APBManager_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)