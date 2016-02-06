import dotherside

type
  QMetaType = int

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

  QMetaObject = ref object of RootObj
    vptr: pointer
    signalDefinitions: seq[SignalDefinition]
    slotDefinitions: seq[SlotDefinition]
    propertyDefinitions: seq[PropertyDefinition]


proc newQMetaObject(superClass: QMetaObject, className: string,
                    signalDefinitions: seq[SignalDefinition],
                    slotDefinitions: seq[SlotDefinition],
                    propertyDefinitions: seq[PropertyDefinition]): QMetaObject =
  new(result)
  result.signalDefinitions = signalDefinitions
  result.slotDefinitions = slotDefinitions
  result.propertyDefinitions = propertyDefinitions

  var dosSignals: seq[DosSignalDefinition]
  for signal in signalDefinitions:
    let dosSignal = DosSignalDefinition(name: signal.name.cstring,
                                        parametersCount: signal.parametersTypes.len.cint,
                                        parametersMetaTypes: signal.parametersTypes[0].unsafeAddr)
    dosSignals.add(dosSignal)

  var dosSlots: seq[DosSlotDefinition]
  for slot in slotDefinitions:
    let dosSlot = DosSlotDefinition(name: slot.name.cstring, returnMetaType:slot.returnMetaType.cint,
                                    parameterssCount: slot.parametersTypes.len.cint,
                                    parametersMetaTypes: slot.parametersTypes[0].unsafeAddr)
    dosSlots.add(dosSlot)

  var dosProperties = seq[DosPropertyDefinition]
  for property in propertyDefinitions:
    let dosProperty = DosPropertyDefinition(name: property.name.cstring, propertyMetaType: property.propertyMetaType.cint,
                                            readSlot: property.readSlot.cstring, writeSlot: property.writeSlot.cstring,
                                            notifySignal: property.notifySignal.cstring)
    dosProperties.add(dosProperty)
