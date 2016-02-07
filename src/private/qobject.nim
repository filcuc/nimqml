let staticMetaObjectInstance = newQObjectMetaObject()

proc staticMetaObject*(c: type QObject): QMetaObject =
  ## Return the metaObject of QObject
  staticMetaObjectInstance

proc staticMetaObject*(self: QObject): QMetaObject =
  ## Return the metaObject of QObject
  staticMetaObjectInstance

proc objectName*(self: QObject): string =
  ## Return the QObject name
  var str: cstring
  dos_qobject_objectName(self.vptr, str)
  result = $str
  dos_chararray_delete(str)

proc `objectName=`*(self: QObject, name: string) =
  ## Sets the Qobject name
  dos_qobject_setObjectName(self.vptr, name.cstring)

method metaObject*(self: QObject): QMetaObject {.base.} =
  ## Return the metaObject
  QObject.staticMetaObject

proc emit*(qobject: QObject, signalName: string, arguments: openarray[QVariant] = []) =
  ## Emit the signal with the given name and values
  var dosArguments: seq[DosQVariant] = @[]
  for argument in arguments:
    dosArguments.add(argument.vptr)
  let dosNumArguments = dosArguments.len.cint
  let dosArgumentsPtr: ptr DosQVariant = if dosArguments.len > 0: dosArguments[0].unsafeAddr else: nil
  dos_qobject_signal_emit(qobject.vptr, signalName.cstring, dosNumArguments, cast[ptr DosQVariantArray](dosArgumentsPtr))

method onSlotCalled*(self: QObject, slotName: string, arguments: openarray[QVariant]) {.base.} =
  ## Called from the dotherside library when a slot is called from Qml.
  discard()

proc qobjectCallback(qobjectPtr: pointer, slotNamePtr: DosQVariant, numArguments: cint, dosArguments: ptr DosQVariantArray) {.cdecl, exportc.} =
  ## Called from the dotherside library for invoking a slot
  let qobject = cast[QObject](qobjectPtr)
  GC_ref(qobject)
  # Retrieve slot name
  let slotName = newQVariant(slotNamePtr)
  defer: slotName.delete
  # Retrieve arguments
  let arguments = toQVariantSequence(dosArguments[])
  defer: arguments.delete
  # Forward to args to the slot
  qobject.onSlotCalled(slotName.stringVal, arguments)
  # Update the slot return value
  dos_qvariant_assign(dosArguments[0], arguments[0].vptr)
  GC_unref(qobject)

proc setup*(self: QObject) =
  ## Initialize a new QObject
  dos_qobject_create(self.vptr, addr(self[]), QObject.staticMetaObject.vptr, qobjectCallback)

proc delete*(self: QObject) =
  ## Delete a QObject
  if self.vptr.isNil:
    return
  dos_qobject_delete(self.vptr)
  self.vptr.resetToNil

proc newQObject*(): QObject =
  ## Create a new QObject
  new(result, delete)
  result.setup()
