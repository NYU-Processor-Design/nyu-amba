cmake_minimum_required(VERSION 3.27)

include(cmake/BootstrapVcpkg.cmake)

project(nyu-amba VERSION 0.1.0)

find_package(nyu-cmake CONFIG REQUIRED)

add_library(amba INTERFACE)

add_subdirectory(rtl)

if(NYU_BUILD_TESTS)
  enable_testing()
  add_subdirectory(dv)
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

nyu_install_sv(
  EXPORT nyuAmbaTargets
  TARGETS amba
  NAMESPACE nyu::
  EXPORT_DEST ${CMAKE_INSTALL_DATADIR}/nyu-amba
  SV_DEST ${CMAKE_INSTALL_DATADIR}/nyu-amba/sv
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/nyu-amba-config-version.cmake
  COMPATIBILITY ExactVersion
  ARCH_INDEPENDENT
)

install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/nyu-amba-config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/nyu-amba-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/nyu-amba
)
