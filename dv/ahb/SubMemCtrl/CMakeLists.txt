
target_sources(tests PRIVATE SubMemCtrl.cpp)
nyu_add_sv(amba
    SubMemCtrl_tl.sv
)
list(APPEND TOP_MODULES SubMemCtrl_tl)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)
