type
  QObject* = ref object of RootObj
    vptr: DosQObject

  QVariant* = ref object of RootObj
    vptr: DosQVariant

  QMetaType* = cint

  SignalDefinition* = object
    name: string
    parametersTypes: seq[QMetaType]

  SlotDefinition* = object
    name: string
    returnMetaType: QMetaType
    parametersTypes: seq[QMetaType]

  PropertyDefinition* = object
    name: string
    propertyMetaType: QMetaType
    readSlot: string
    writeSlot: string
    notifySignal: string

  QMetaObject* = ref object of RootObj
    vptr: DosQMetaObject
    signals: seq[SignalDefinition]
    slots: seq[SlotDefinition]
    properties: seq[PropertyDefinition]
