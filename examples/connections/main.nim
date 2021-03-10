import nimqml
import macros
import os
import sugar


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
  echo n.treeRepr
  echo $(inherit.treeRepr)

proc isQObject(impl: NimNode): bool {.compileTime.} =
  impl.expectKind(nnkTypeDef)

  let name = impl[0]
  if $name == "QObject":
    return true
  let superclass = superClass(impl)
  return true


macro foo(node: typed): void =
  var procDefs: seq[NimNode] = @[]
  if node.kind == nnkSym:
#    echo "nnkSym"
    let impl = node.getImpl
    impl.expectKind(nnkProcDef)
    procDefs.add(impl)
  elif node.kind == nnkClosedSymChoice:
#    echo "nnkClosedSymChoice"
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
      continue
    echo "OK"


proc intproc(i: RefTemp) = discard
proc intproc(i: QObject) = discard
proc intproc(i: int) = discard

proc main() =
  foo(intproc)

if isMainModule:
  main()
  GC_fullcollect()
