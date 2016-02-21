import tables

var ctorTable = initTable[cint, proc():QObject]()

proc creator(id: cint, nimQObject:var NimQObject, dosQObject: var DosQObject) {.cdecl.} =
  let qobject: QObject = ctorTable[id]()
  GC_ref(qobject)
  nimQObject = addr(qobject[])
  dosQObject = qobject.vptr

proc deleter(id: cint, nimQObject: NimQObject) {.cdecl.} =
  let qobject = cast[QObject](nimQObject)
  GC_unref(qobject)

proc qmlRegisterType*[T](uri: string, major: int, minor: int, qmlName: string, ctor: proc(): T) {.cdecl.} =
  var result: cint = 0
  let metaObject: QMetaObject = T.staticMetaObject()
  let dosQmlRegisterType = DosQmlRegisterType(major: major.cint, minor: minor.cint, uri: uri.cstring,
                                              qml: qmlName.cstring, staticMetaObject: metaObject.vptr,
                                              createCallback: creator, deleteCallback: deleter)
  dos_qdeclarative_qmlregistertype(dosQmlRegisterType.unsafeAddr, result)
  ctorTable[result] = proc(): QObject = ctor().QObject

proc qmlRegisterSingletonType*[T](uri: string, major: int, minor: int, qmlName: string, ctor: proc(): T) {.cdecl.} =
  var result: cint = 0
  let metaObject: QMetaObject = T.staticMetaObject()
  let dosQmlRegisterType = DosQmlRegisterType(major: major.cint, minor: minor.cint, uri: uri.cstring,
                                              qml: qmlName.cstring, staticMetaObject: metaObject.vptr,
                                              createCallback: creator, deleteCallback: deleter)
  dos_qdeclarative_qmlregistersingletontype(dosQmlRegisterType.unsafeAddr, result)
  ctorTable[result] = proc(): QObject = ctor().QObject
