INCLUDE(FindPkgConfig)
PKG_CHECK_MODULES(PC_CUDA_EXAMPLE cuda_example)

FIND_PATH(
    CUDA_EXAMPLE_INCLUDE_DIRS
    NAMES cuda_example/api.h
    HINTS $ENV{CUDA_EXAMPLE_DIR}/include
        ${PC_CUDA_EXAMPLE_INCLUDEDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/include
          /usr/local/include
          /usr/include
)

FIND_LIBRARY(
    CUDA_EXAMPLE_LIBRARIES
    NAMES gnuradio-cuda_example
    HINTS $ENV{CUDA_EXAMPLE_DIR}/lib
        ${PC_CUDA_EXAMPLE_LIBDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/lib
          ${CMAKE_INSTALL_PREFIX}/lib64
          /usr/local/lib
          /usr/local/lib64
          /usr/lib
          /usr/lib64
          )

include("${CMAKE_CURRENT_LIST_DIR}/cuda_exampleTarget.cmake")

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CUDA_EXAMPLE DEFAULT_MSG CUDA_EXAMPLE_LIBRARIES CUDA_EXAMPLE_INCLUDE_DIRS)
MARK_AS_ADVANCED(CUDA_EXAMPLE_LIBRARIES CUDA_EXAMPLE_INCLUDE_DIRS)
