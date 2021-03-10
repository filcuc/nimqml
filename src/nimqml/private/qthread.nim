let qthreadStaticMetaObjectInstance = newQThreadMetaObject()

proc staticMetaObject*(c: type QThread): QMetaObject =
  ## Return the QMetaObject
  qthreadStaticMetaObjectInstance

proc staticMetaObject*(self: QThread): QMetaObject =
  ## Return the QMetaObject of QAbstractItemModel
  QThread.staticMetaObject

method metaObject*(self: QThread): QMetaObject =
  ## Return the QMetaObject
  QThread.staticMetaObject

proc start*(self: QThread) =
  ## Starts the QThread
  dos_qthread_start(self.vptr.DosQThread)

proc isRunning*(self: QThread): bool =
  ## Return true if the QThread is running, false otherwise
  dos_qthread_isRunning(self.vptr.DosQThread)

proc quit*(self: QThread) =
  ## Quit the QThread. Equivalent to exit(0)
  dos_qthread_quit(self.vptr.DosQThread)

proc quit*(typ: type QThread): string =
  var str = dos_slot_macro("quit()")
  result = $str
  dos_chararray_delete(str)

proc exit(self: QThread, exitCode: cint) =
  ## Exit the QThread with the given exitCode
  dos_qthread_exit(self.vptr.DosQThread, exitCode)

proc wait*(self: QThread) =
  ## Quit the QThread
  dos_qthread_wait_forever(self.vptr.DosQThread)

proc wait*(self: QThread, time: culonglong) =
  ## Quit the QThread
  dos_qthread_wait_for(self.vptr.DosQThread, time)

proc exec*(self: QThread): int =
  ## Start the QThread event loop
  debugMsg("QThread", "exec")
  var exitCode = 0.cint
  discard dos_qthread_exec(self.vptr.DosQThread, exitCode)
  debugMsg("QThread", "exec exited")
  result = exitCode

method run*(self: QThread) {.base.} =
  ## Enter code execute inside the QThread thread. By default execute QThread.exec
  discard self.exec()

proc runCallback(selfPtr: pointer) {.cdecl, exportc.} =
  debugMsg("QThread", "runCallback")
  let self = cast[QThread](selfPtr)
  self.run()

proc startedCallback(selfPtr: pointer) {.cdecl, exportc.} =
  setupForeignThreadGc()
  debugMsg("QThread", "startedCallback")


proc finishedCallback(selfPtr: pointer) {.cdecl, exportc.} =
  debugMsg("QThread", "finishedCallback")

proc setup*(self: QThread) =
  ## Setup a new QThread
  debugMsg("QThread", "setup")
  let callbacks = DosQThreadCallbacks(started: startedCallback, finished: finishedCallback, run: runCallback)
  self.vptr = dos_qthread_create(addr(self[]), self.metaObject.vptr, qobjectCallback, callbacks).DosQObject
  debugMsg("QThread", "setupf")

proc delete*(self: QThread) =
  ## Delete a QThread
  debugMsg("QThread", "delete")
  self.QObject.delete

proc newQThread*(): QThread =
  ## Creates a new QThread
  QThread.new

proc new*(c: type QThread): QThread =
  ## Creates a new QThread
  debugMsg("QThread", "new")
  new(result, delete)
  result.setup()
  result.owner = true

proc currentThread*(c: type QThread): QThread =
  ## Return the current QThread
  result(new, delete)
  result.owner = false

proc currentThreadId*(c: type QThread): pointer =
  ## Return the current QThread id
  dos_qthread_currentThreadId()

proc finished*(typ: type QObject): string =
  ## Signature for the QThread finished signal
  var str = dos_signal_macro("finished()")
  result = $str
  dos_chararray_delete(str)

proc started*(typ: type QObject): string =
  ## Signature for the QThread started signal
  var str = dos_signal_macro("started()")
  result = $str
  dos_chararray_delete(str)
