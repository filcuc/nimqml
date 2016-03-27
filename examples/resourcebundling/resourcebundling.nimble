# Package

version       = "0.1.0"
author        = "Filippo Cucchetto"
description   = "resourcebundling"
license       = "MIT"

bin = @["main"]

# Dependencies

requires "nimqml >= 0.5.0"

task build, "Compile the binary":
  exec ("nim c main")

before build:
  exec ("rcc --binary resources.qrc -o main.rcc")
