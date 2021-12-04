proc delete*(self: QMetaObjectConnection) =
  debugMsg("QMetaObjectConnection", "delete")
  if self.vptr.isNil:
    dos_qmetaobject_connection_delete(self.vptr)
    self.vptr.resetToNil
