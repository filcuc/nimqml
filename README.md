# NimQML

QML binding for the Nim programming language

## Requirements
* [DOtherside](https://github.com/filcuc/DOtherSide) 0.4.5 or higher
* [Nim](http://nim-lang.org/) 0.11.2 or higher

## Build instructions
* Compile and Install DOtherside in your system PATH (i.e. /usr/lib)
* nimble install nimqml

## Examples
* The examples can be built by executing the following command
* nimble compile -l:-lDOtherSide main.nim

This invokes the nim compiler asking to link the DOtherSide lib
