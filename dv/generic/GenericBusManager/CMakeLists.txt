target_sources(tests PRIVATE GenericBusManager.cpp)
nyu_add_sv(tests
  GenericBusManager_tl.sv
)
list(APPEND TOP_MODULES GenericBusManager_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)
