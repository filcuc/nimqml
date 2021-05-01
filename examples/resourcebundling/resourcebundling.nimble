# Package

version       = "0.1.0"
author        = "Filippo Cucchetto"
description   = "resourcebundling"
license       = "MIT"

bin = @["main"]

# Dependencies

requires @["nim >= 1.2.0", "nimqml >= 0.9.0"]

task build, "Compile the binary":
  exec ("nim c main")

before build:
  exec ("rcc --binary resources.qrc -o main.rcc")
