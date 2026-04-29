cmake_minimum_required(VERSION 3.20)

project(CxxTemplate LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(CXX_TEMPLATE_ENABLE_TEST "Enable building tests" OFF)

add_subdirectory(src)

if(CXX_TEMPLATE_ENABLE_TEST)
  enable_testing()
  add_subdirectory(tests)
endif()
