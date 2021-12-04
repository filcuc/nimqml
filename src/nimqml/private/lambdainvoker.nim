proc add(self: LambdaInvoker, l: LambdaInvokerProc): int =
  ## Add a lambda and return its id
  self.lock.acquire()
  result = self.id
  self.id.inc()
  self.lambdas[result] = l
  self.lock.release()

proc add(self: LambdaInvoker, l: proc()): int =
  let k = proc(args: seq[QVariant]) = l()
  return self.add(k)

proc add[T0](self: LambdaInvoker, l: proc(t0: T0)): int =
  let k = proc(args: seq[QVariant]) =
    if args.len > 0:
      l(args[0].value(T0))
    else:
      echo "Too few arguments during lambda invokation"
  return self.add(k)

proc add[T0, T1](self: LambdaInvoker, l: proc(t0: T0, t1: T1)): int =
  let k = proc(args: seq[QVariant]) =
    if args.len > 1:
      l(args[0].value(T0), args[1].value(T1))
    else:
      echo "Too few arguments during lambda invokation"
  return self.add(k)

proc add[T0, T1, T2](self: LambdaInvoker, l: proc(t0: T0, t1: T1, t2: T2)): int =
  let k = proc(args: seq[QVariant]) =
    if args.len > 2:
      l(args[0].value(T0), args[1].value(T1), args[2].value(T2))
    else:
      echo "Too few arguments during lambda invokation"
  return self.add(k)

proc get(self: LambdaInvoker, id: int): LambdaInvokerProc =
  ## Return the lambda with the given id
  self.lock.acquire()
  result = self.lambdas.getOrDefault(id)
  self.lock.release()

proc invoke(self: LambdaInvoker, id: int, arguments: seq[QVariant]) =
  let l = self.get(id)
  if l != nil:
    l(arguments)

let invokerInstance = LambdaInvoker.new()
  
proc instance(typ: type LambdaInvoker): LambdaInvoker =
  result = invokerInstance

proc lambdaCallback(data: pointer, numArguments: cint, arguments: ptr DosQVariantArray) {.cdecl, exportc.} =
  let id = cast[int](data)
  let arguments = toQVariantSequence(arguments, numArguments, Ownership.Clone)
  LambdaInvoker.instance.invoke(id, arguments)
