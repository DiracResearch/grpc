set(protobuf_MSVC_STATIC_RUNTIME ON CACHE BOOL "Static c++ runtime")

set(BORINGSSL_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/boringssl)
set(PROTOBUF_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/protobuf)
set(ZLIB_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/zlib)
set(CARES_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/cares)
set(GFLAGS_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/gflags)
set(BENCHMARK_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/benchmark)
set(BENCHMARK_ENABLE_TESTING OFF CACHE BOOL "")

if (MSVC)
    set(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} /IGNORE:4221")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4800 /wd4291 /wd4715")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4715")
else ()
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wno-expansion-to-defined")
    endif()
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wno-invalid-offsetof -Wno-unused-parameter")
endif()

add_subdirectory(grpc EXCLUDE_FROM_ALL)

mark_as_advanced(FORCE
                 BORINGSSL_ROOT_DIR
                 PROTOBUF_ROOT_DIR
                 ZLIB_ROOT_DIR
                 CARES_ROOT_DIR
                 GFLAGS_ROOT_DIR
                 BENCHMARK_ROOT_DIR
                 BENCHMARK_ENABLE_TESTING
                 BENCHMARK_ENABLE_LTO
                 BENCHMARK_USE_LIBCXX
                 CARES_INSTALL
                 CARES_SHARED
                 CARES_STATIC
                 CARES_STATIC_PIC
                 BORINGSSL_ENABLE_GTEST
                 gRPC_BENCHMARK_PROVIDER
                 gRPC_BUILD_TESTS
                 gRPC_CARES_PROVIDER
                 gRPC_GFLAGS_PROVIDER
                 gRPC_INSTALL
                 gRPC_INSTALL_BINDIR
                 gRPC_INSTALL_CMAKEDIR
                 gRPC_INSTALL_INCLUDEDIR
                 gRPC_INSTALL_LIBDIR
                 gRPC_PROTOBUF_PACKAGE_TYPE
                 gRPC_PROTOBUF_PROVIDER
                 gRPC_SSL_PROVIDER
                 gRPC_USE_PROTO_LITE
                 gRPC_ZLIB_PROVIDER
                 protobuf_MSVC_STATIC_RUNTIME
                 protobuf_BUILD_EXAMPLES
                 protobuf_BUILD_SHARED_LIBS
                 protobuf_BUILD_TESTS
                 protobuf_INSTALL_EXAMPLES
                 protobuf_WITH_ZLIB)

if (NOT PROTOC_COMMAND OR NOT GRPC_CPP_PLUG)
    if (CMAKE_CROSSCOMPILING)
        set(workdir ${CMAKE_BINARY_DIR}/host_binaries)
        execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory "${workdir}")
        message(STATUS "Building protoc & grpc_cpp_plugin for ${CMAKE_HOST_SYSTEM_PROCESSOR}...")
        
        # Generate makefiles, making sure CC and CXX env vars are unset (so that default system compiler is used)
        execute_process(COMMAND ${CMAKE_COMMAND} -E env --unset=CC --unset=CXX
                                ${CMAKE_COMMAND}
                                -DBORINGSSL_ROOT_DIR:STRING=${BORINGSSL_ROOT_DIR}
                                -DPROTOBUF_ROOT_DIR:STRING=${PROTOBUF_ROOT_DIR}
                                -DZLIB_ROOT_DIR:STRING=${ZLIB_ROOT_DIR}
                                -DCARES_ROOT_DIR:STRING=${CARES_ROOT_DIR}
                                -DGFLAGS_ROOT_DIR:STRING=${GFLAGS_ROOT_DIR}
                                -DBENCHMARK_ROOT_DIR:STRING=${BENCHMARK_ROOT_DIR}
                                -DgRPC_INSTALL_default:BOOL=OFF
                                -DgRPC_INSTALL:BOOL=OFF
                                ${CMAKE_CURRENT_SOURCE_DIR}/grpc
                        WORKING_DIRECTORY "${workdir}")

        # Build needed targets
        execute_process(COMMAND ${CMAKE_COMMAND} --build . --target protoc
                        WORKING_DIRECTORY "${workdir}")

        execute_process(COMMAND ${CMAKE_COMMAND} --build . --target grpc_cpp_plugin
                        WORKING_DIRECTORY "${workdir}")

        set(PROTOC_COMMAND "${workdir}/third_party/protobuf/protoc" CACHE FILEPATH "" FORCE)
        set(GRPC_CPP_PLUG "${workdir}/grpc_cpp_plugin" CACHE FILEPATH "" FORCE)
    else()
        set(PROTOC_COMMAND $<TARGET_FILE:protoc> CACHE FILEPATH "")
        set(GRPC_CPP_PLUG $<TARGET_FILE:grpc_cpp_plugin> CACHE FILEPATH "")
    endif()
endif()

if (MSVC)
    include(${CMAKE_CURRENT_LIST_DIR}/target_folders.cmake)
endif()
