import dotherside

type
  QMetaType = cint

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

proc delete*(metaObject: QMetaObject) =
  ## Delete a QMetaObject
  debugMsg("QMetaObject", "delete")
  if metaObject.vptr.isNil:
    return
  dos_qmetaobject_delete(metaObject.vptr)
  metaObject.vptr.resetToNil

proc newQObjectMetaObject*(): QMetaObject =
  ## Create the QMetaObject of QObject
  debugMsg("QMetaObject", "newQObjectMetaObject")
  new(result, delete)
  dos_qobject_qmetaobject(result.vptr)

proc newQAbstractListModelMetaObject*(): QMetaObject =
  ## Create the QMetaObject of QAbstractListModel
  debugMsg("QMetaObject", "newQAbstractListModelMetaObject")
  new(result, delete)
  dos_qabstractlistmodel_qmetaobject(result.vptr)

proc newQMetaObject*(superClass: QMetaObject, className: string,
                     signals: seq[SignalDefinition],
                     slots: seq[SlotDefinition],
                     properties: seq[PropertyDefinition]): QMetaObject =
  ## Create a new QMetaObject
  debugMsg("QMetaObject", "newQMetaObject")
  new(result, delete)
  result.signals = signals
  result.slots = slots
  result.properties = properties

  var dosSignals: seq[DosSignalDefinition] = @[]
  for i in 0..<signals.len:
    let name = signals[i].name.cstring
    let parametersCount = signals[i].parametersTypes.len.cint
    let parametersMetaTypes = if parametersCount > 0: signals[i].parametersTypes[0].unsafeAddr else: nil
    let dosSignal = DosSignalDefinition(name: name, parametersCount: parametersCount, parametersMetaTypes: parametersMetaTypes)
    dosSignals.add(dosSignal)

  var dosSlots: seq[DosSlotDefinition] = @[]
  for i in 0..<slots.len:
    let name = slots[i].name.cstring
    let returnMetaType = slots[i].returnMetaType.cint
    let parametersCount = slots[i].parametersTypes.len.cint
    let parametersMetaTypes = if parametersCount > 0: slots[i].parametersTypes[0].unsafeAddr else: nil
    let dosSlot = DosSlotDefinition(name: name, returnMetaType: returnMetaType,
                                    parametersCount: parametersCount, parametersMetaTypes: parametersMetaTypes)
    dosSlots.add(dosSlot)

  var dosProperties: seq[DosPropertyDefinition] = @[]
  for i in 0..<properties.len:
    let name = properties[i].name.cstring
    let propertyMetaType = properties[i].propertyMetaType.cint
    let readSlot = properties[i].readSlot.cstring
    let writeSlot = properties[i].writeSlot.cstring
    let notifySignal = properties[i].notifySignal.cstring
    let dosProperty = DosPropertyDefinition(name: name, propertyMetaType: propertyMetaType,
                                            readSlot: readSlot, writeSlot: writeSlot,
                                            notifySignal: notifySignal)
    dosProperties.add(dosProperty)

  dos_qmetaobject_create(result.vptr, superClass.vptr, className.cstring,
                         DosSignalDefinitions(count: dosSignals.len.cint, definitions: if dosSignals.len > 0: dosSignals[0].unsafeAddr else: nil),
                         DosSlotDefinitions(count: dosSlots.len.cint, definitions: if dosSlots.len > 0: dosSlots[0].unsafeAddr else: nil),
                         DosPropertyDefinitions(count: dosProperties.len.cint, definitions: if dosProperties.len > 0: dosProperties[0].unsafeAddr else: nil))
