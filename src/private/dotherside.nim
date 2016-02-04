type
  CArray* {.unchecked.}[T] = array[0..0, T]

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
    paremetersCount*: cint
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

proc dos_qmetaobject_create*(vptr: var pointer,
                          superclassMetaObject: pointer,
                          className: cstring,
                          signalDefinitions: DosSignalDefinitions,
                          slotDefinitions: DosSlotDefinitions,
                          propertyDefinitions: DosPropertyDefinitions) {.cdecl, importc.}

proc dos_qmetaobject_delete*(vptr: var pointer) {.cdecl, importc.}
