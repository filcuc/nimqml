type
  DosQMetaObject* = distinct pointer

  DosSignalDefinition* = object
    name*: cstring
    parametersCount*: cint
    parametersMetaTypes*: pointer

  DosSignalDefinitions* = object
    count*: cint
    definitions*: pointer

  DosSlotDefinition* = object
    name*: cstring
    returnMetaType*: cint
    parametersCount*: cint
    parametersMetaTypes*: pointer

  DosSlotDefinitions* = object
    count*: cint
    definitions*: pointer

  DosPropertyDefinition* = object
    name*: cstring
    propertyMetaType*: cint
    readSlot*: cstring
    writeSlot*: cstring
    notifySignal*: cstring

  DosPropertyDefinitions* = object
    count*: cint
    definitions*: pointer

proc resetToNil*[T](x: var T) = x = nil.pointer.T
proc isNil*[T](x: T): bool = x.pointer == nil

# QObject
proc dos_qobject_qmetaobject*(vptr: var DosQmetaObject) {.cdecl, importc.}

# QAbstractListModel
proc dos_qabstractlistmodel_qmetaobject*(vptr: var DosQmetaObject) {.cdecl importc.}

# QMetaObject
proc dos_qmetaobject_create*(vptr: var DosQmetaObject,
                             superclassMetaObject: DosQMetaObject,
                             className: cstring,
                             signalDefinitions: DosSignalDefinitions,
                             slotDefinitions: DosSlotDefinitions,
                             propertyDefinitions: DosPropertyDefinitions) {.cdecl, importc.}

proc dos_qmetaobject_delete*(vptr: DosQmetaObject) {.cdecl, importc.}
