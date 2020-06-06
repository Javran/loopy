cmake_minimum_required(VERSION 3.5.1)

project(AdderService C CXX)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17"
)

find_package(Threads REQUIRED)


# Find Protobuf installation
# Looks for protobuf-config.cmake file installed by Protobuf's cmake installation.
set(protobuf_MODULE_COMPATIBLE TRUE)
find_package(Protobuf CONFIG REQUIRED)
message(STATUS "Using protobuf ${protobuf_VERSION}")

set(_PROTOBUF_LIBPROTOBUF protobuf::libprotobuf)
set(_REFLECTION gRPC::grpc++_reflection)
set(_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)

# Find gRPC installation
# Looks for gRPCConfig.cmake file installed by gRPC's cmake installation.
find_package(gRPC CONFIG REQUIRED)
message(STATUS "Using gRPC ${gRPC_VERSION}")

set(_GRPC_GRPCPP gRPC::grpc++)
set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:gRPC::grpc_cpp_plugin>)

# Proto file
get_filename_component(adder_proto "../protos/adder.proto" ABSOLUTE)
get_filename_component(adder_proto_path "${adder_proto}" PATH)

# Generated sources
set(adder_proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/adder.pb.cc")
set(adder_proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/adder.pb.h")
set(adder_grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/adder.grpc.pb.cc")
set(adder_grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/adder.grpc.pb.h")
add_custom_command(
      OUTPUT "${adder_proto_srcs}" "${adder_proto_hdrs}" "${adder_grpc_srcs}" "${adder_grpc_hdrs}"
      COMMAND ${_PROTOBUF_PROTOC}
      ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${adder_proto_path}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${adder_proto}"
      DEPENDS "${adder_proto}")

# Include generated *.pb.h files
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

add_executable(adder_server "adder_server.cc"
    ${adder_proto_srcs}
    ${adder_grpc_srcs})
target_link_libraries(adder_server
    ${_REFLECTION}
    ${_GRPC_GRPCPP}
    ${_PROTOBUF_LIBPROTOBUF})
