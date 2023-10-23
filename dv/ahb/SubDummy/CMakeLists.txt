target_sources(tests PRIVATE SubDummy.cpp)
nyu_add_sv(tests
  SubDummy_tl.sv
)
list(APPEND TOP_MODULES SubDummy_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)
