cmake_minimum_required(VERSION 3.30)

project(CxxTemplate LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)

option(CXX_TEMPLATE_ENABLE_TEST "Enable building tests" OFF)

add_subdirectory(src)

if(CXX_TEMPLATE_ENABLE_TEST)
  enable_testing()
  add_subdirectory(tests)
endif()
