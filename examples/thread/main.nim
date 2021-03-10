import nimqml
import os
import sugar

QtObject:
  type Worker = ref object of QObject

  proc setup(self: Worker) = self.QObject.setup

  proc delete(self: Worker) = self.QObject.delete

  proc new(c: type Worker): Worker =
    new(result, delete)
    result.setup()

  proc finished(self: Worker) {.signal.}

  proc process(self: Worker) {.slot.} =
    echo "Worker Hello World"
    self.finished()


proc main() =
  let app = QApplication.new()
  defer: app.delete
  let thread = QThread.new()
  defer: thread.delete
  let worker = Worker.new()
  defer: worker.delete
  worker.moveToThread(thread)
  discard QObject.connect(worker, Worker.finished, thread, () => thread.quit())
  discard QObject.connect(thread, QThread.finished, () => app.quit())
  discard QObject.connect(thread, QThread.started, worker, () => worker.process())
  thread.start()
  app.exec()


if isMainModule:
  main()
  GC_fullcollect()
