# Package

version       = "0.1.0"
author        = "Filippo Cucchetto"
description   = "resourcebundling"
license       = "MIT"

bin = @["resourcebundling"]

# Dependencies

requires "nimqml >= 0.5.0"

task compileresources, "Compile the qrc into rcc":
  exec ("rcc --binary resources.qrc -o main.rcc")
  setCommand("nop")

task compilebinary, "Compile the binary":
  setCommand "c"
