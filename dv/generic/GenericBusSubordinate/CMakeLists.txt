target_sources(tests PRIVATE GenericBusSubordinate.cpp)
nyu_add_sv(tests
  GenericBusSubordinate_tl.sv
)
list(APPEND TOP_MODULES GenericBusSubordinate_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)
