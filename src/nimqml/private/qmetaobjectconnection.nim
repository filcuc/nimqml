type QMetaObjectConnection = ref object
  vptr: DosQMetaObjectConnection

proc delete*(self: QMetaObjectConnection) =
  debugMsg("QMetaObjectConnection", "delete")
  if self.vptr.isNil:
    dos_qmetaobject_connection_delete(self.vptr)
    self.vptr.resetToNil

proc new*(typ: type QMetaObjectConnection, vptr: DosQMetaObjectConnection): QMetaObjectConnection =
  new(result, delete)
  result.vptr = vptr
