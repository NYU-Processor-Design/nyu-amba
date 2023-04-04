option(TEST_ALL "Test all devices" TRUE)

find_package(Catch2 3 REQUIRED CONFIG)

add_executable(tests)
set(TOP_MODULES "")

if(TEST_AHB OR TEST_ALL)
  add_subdirectory(ahb)
endif()

nyu_link_sv(tests PRIVATE amba)
nyu_target_verilate(tests
  TOP_MODULES ${TOP_MODULES}
  ARGS COVERAGE
)

target_link_libraries(tests PRIVATE Catch2::Catch2WithMain)

include(Catch)
catch_discover_tests(tests)
