cmake_minimum_required(VERSION 3.4)
project(LetsBuildASimpleInterpreter)

add_custom_target(LetsBuildASimpleInterpreter
        COMMAND /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES Package.swift Sources/main.swift)