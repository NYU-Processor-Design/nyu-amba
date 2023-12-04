target_sources(tests PRIVATE GPIO.cpp)
nyu_add_sv(amba
  GPIO_tb.sv
)
list(APPEND TOP_MODULES GPIO_tb)
set(TOP_MODULES ${TOP_MODULES} PARENT_SCOPE)
