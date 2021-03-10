import nimqml
import macros
import os
import sugar
import strformat

type Temp = object
type RefTemp = ref object


QtObject:
  type Contact* = ref object of QObject
    name: string
    surname: string

  proc firstName*(self: Contact): string {.slot.} =
    result = self.name

  proc firstNameChanged*(self: Contact, firstName: string) {.signal.}

  method setFirstName(self: Contact, name: string) {.slot.} =
    if self.name != name:
      self.name = name
      self.firstNameChanged(name)

  proc `firstName=`*(self: Contact, name: string) = self.setFirstName(name)


  QtProperty[string] firstName:
    read = firstName
    write = setFirstName
    notify = firstNameChanged


proc superClass(n: NimNode): NimNode {.compileTime.} =
  let inherit = n[2][0][1]
  if inherit.kind == nnkOfInherit:
    return inherit[0].getImpl()
  return newNimNode(nnkEmpty)

proc isQObject(impl: NimNode): bool {.compileTime.} =
  var typ = impl
  while typ.kind == nnkTypeDef:
    let name = typ[0]
    if $name == "QObject":
      return true
    typ = superClass(typ)
  return false

proc childrenOfKind(n: NimNode, kind: NimNodeKind): seq[NimNode] {.compiletime.} =
  ## Return the sequence of child nodes of the given kind
  result = @[]
  for c in n:
    if c.kind == kind:
      result.add(c)

proc getPragmas(n: NimNode): seq[string] {.compiletime.} =
  ## Return the pragmas of a node
  result = @[]
  let pragmas = n.childrenOfKind(nnkPragma)
  if pragmas.len != 1:
    return
  let pragma = pragmas[0]
  for c in pragma:
    doAssert(c.kind == nnkSym)
    result.add($c)

proc isSlot(n: NimNode): bool {.compiletime.} =
  ## return true if the given proc/method is a slotn
  n.kind in {nnkProcDef, nnkMethodDef} and "slot" in n.getPragmas

proc isSignal(n: NimNode): bool {.compiletime.} =
  ## Return true if the given procdef is a signal 
  n.kind in {nnkProcDef, nnkMethodDef} and "signal" in n.getPragmas

type MyProcInfo = object
  name: string
  params: seq[string]
  isSlot: bool
  isSignal: bool

proc extractQObjectSignalsAndSlots(procDefs: seq[NimNode]): seq[MyProcInfo] =
  ## Given a list of proc definitions extract the slot and signals
  for def in procDefs:
    # Check if slot is a signal or slo 
    let procIsSlot = isSlot(def)
    let procIsSignal = isSignal(def)
    if not procIsSlot and not procIsSignal:
      continue

    # Check that we have at least the return type and a first argument
    let procName = def[0]
    let procParams = def[3]
    let procParamsCount = procParams.len
    if procParamsCount < 2:
      continue

    # Check first arguments to be a ref type
    let procReturnType = procParams[0]
    let procFirstParam = procParams[1]
    let procFirstParamName = procFirstParam[0]
    let procFirstParamTypeSym = procFirstParam[1]
    if procFirstParamTypeSym.typeKind != ntyRef:
      continue

    # Check first type to be a QObject
    let procFirstParamTypeDef = procFirstParamTypeSym.getImpl
    if not isQObject(procFirstParamTypeDef):
      continue

    # Collect info
    var procInfo = MyProcInfo(name: "", params: @[], isSlot: false, isSignal: false)
    procInfo.name = $procName
    for param in procParams[1 .. ^1]:
      procInfo.params.add($param[1])
    procInfo.isSlot = procIsSlot
    procInfo.isSignal = procIsSignal
    result.add(procInfo)

macro foo(node: typed): void =
  var procDefs: seq[NimNode] = @[]
  if node.kind == nnkSym:
    let impl = node.getImpl
    impl.expectKind(nnkProcDef)
    procDefs.add(impl)
  elif node.kind == nnkClosedSymChoice:
    for sym in node.children:
      let impl = sym.getImpl
      impl.expectKind({nnkProcDef, nnkMethodDef})
      procDefs.add(impl)
  else:
    raiseAssert("Invalid Node")
  
  let procAndSignalsInfo = extractQObjectSignalsAndSlots(procDefs)
  for info in procAndSignalsInfo:
    echo fmt"Name {info.name} is slot {info.isSlot} is signal {info.isSignal}"

    
proc intproc(i: RefTemp) = discard
proc intproc(i: Contact) {.compiletime.} = discard
proc intproc(i: QObject) = discard
proc intproc(i: int) = discard

proc main() =
  foo(firstNameChanged)


if isMainModule:
  main()
  GC_fullcollect()
