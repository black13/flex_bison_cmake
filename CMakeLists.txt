cmake_minimum_required(VERSION 3.1)

SET(CMAKE_C_COMPILER gcc-7)
SET(CMAKE_CXX_COMPILER g++-7)

find_package(BISON )
find_package(FLEX )

BISON_TARGET(MyParser ${CMAKE_CURRENT_SOURCE_DIR}/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(MyScanner ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l  ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(scanner
    main.cpp
    ${BISON_MyParser_OUTPUTS}
    ${FLEX_MyScanner_OUTPUTS}
)
 
