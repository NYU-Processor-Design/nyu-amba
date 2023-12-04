option(TEST_ALL "Test all devices" TRUE)

find_package(Catch2 3 REQUIRED CONFIG)
find_package(nyu-util REQUIRED CONFIG)

add_executable(tests)
set(TOP_MODULES "")

if(TEST_AHB OR TEST_ALL)
  add_subdirectory(ahb)
  add_subdirectory(apb)
endif()

if(TEST_GENERIC OR TEST_ALL)
  add_subdirectory(generic)
endif()

nyu_link_sv(tests PRIVATE amba)
nyu_target_verilate(tests
  TOP_MODULES ${TOP_MODULES}
  ARGS COVERAGE
)

target_link_libraries(tests PRIVATE Catch2::Catch2WithMain nyu::covrecorder)
target_compile_features(tests PRIVATE cxx_std_23)

include(Catch)
catch_discover_tests(tests)
