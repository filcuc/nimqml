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

  proc setFirstName(self: Contact, name: string) {.slot.} =
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
    doAssert(c.kind == nnkIdent)
    result.add($c)

proc isSlot(n: NimNode): bool {.compiletime.} =
  n.kind in {nnkProcDef, nnkMethodDef} and "slot" in n.getPragmas

proc isSignal(n: NimNode): bool {.compiletime.} =
  n.kind in {nnkProcDef, nnkMethodDef} and "signal" in n.getPragmas

macro foo(node: typed): void =
  var procDefs: seq[NimNode] = @[]
  if node.kind == nnkSym:
    let impl = node.getImpl
    impl.expectKind(nnkProcDef)
    procDefs.add(impl)
  elif node.kind == nnkClosedSymChoice:
    for sym in node.children:
      let impl = sym.getImpl
      impl.expectKind(nnkProcDef)
      procDefs.add(impl)
  else:
    raiseAssert("Invalid Node")
  
  for impl in procDefs:
    let name = impl[0]
    let params = impl[3]
    let paramsCount = params.len
    let returnType = params[0]
    if paramsCount < 2:
      continue
    let firstParam = params[1]
    let firstParamName = firstParam[0]
    let firstParamTypeSym = firstParam[1]
    if firstParamTypeSym.typeKind != ntyRef:
      continue
    let firstParamTypeDef = firstParamTypeSym.getImpl
    if not isQObject(firstParamTypeDef):
      echo $firstParamTypeSym & " is not a QObject"
      continue

#    echo $firstParamTypeSym & " is a QObject"
    echo impl.treeRepr()
#    echo getPragmas(impl)
    
proc intproc(i: RefTemp) = discard
proc intproc(i: Contact) {.compiletime.} = discard
proc intproc(i: QObject) = discard
proc intproc(i: int) = discard

proc main() =
  foo(firstNameChanged)


if isMainModule:
  main()
  GC_fullcollect()
