project(grpc)

########## GRPC ############
# Setup static target for gRPC++

# Include third_party libraries
add_subdirectory(third_party/zlib)
target_include_directories(
  zlibstatic 
  PUBLIC
    third_party/zlib
    ${CMAKE_CURRENT_BINARY_DIR}/third_party/zlib
)

# Protobuf 

# gpr
include(cmake/utils.cmake)
include(cmake/libgpr.cmake)

include(cmake/libgrpc_unsecure.cmake)
include(cmake/libgrpc++_unsecure.cmake)
#include(cmake/libgrpc++.cmake)


