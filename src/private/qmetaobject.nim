import dotherside

type
  QMetaType = int

  SignalDefinition* = object
    name: string
    parametersTypes: seq[QMetaType]

  SlotDefinition* = object
    name: string
    returnType: QMetaType
    parametersTypes: seq[QMetaType]

  PropertyDefinition* = object
    name: string
    propertyType: QMetaType
    readSlot: string
    writeSlot: string
    notifySignal: string

  QMetaObject = ref object of RootObj
    vptr: pointer
    signalDefinitions: seq[SignalDefinition]
    slotDefinitions: seq[SlotDefinition]
    propertyDefinitions: seq[PropertyDefinition]


proc convert(signals: seq[SignalDefinition]): seq[DosSignalDefinition] =
  discard()


proc newQMetaObject(superClass: QMetaObject, className: string,
                    signalDefinitions: seq[SignalDefinition],
                    slotDefinitions: seq[SlotDefinition],
                    propertyDefinitions: seq[PropertyDefinition]): QMetaObject =
  new(result)
  result.signalDefinitions = signalDefinitions
  result.slotDefinitions = slotDefinitions
  result.propertyDefinitions = propertyDefinitions
