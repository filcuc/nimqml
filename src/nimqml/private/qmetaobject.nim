proc delete*(metaObject: QMetaObject) =
  ## Delete a QMetaObject
  debugMsg("QMetaObject", "delete")
  if metaObject.vptr.isNil:
    return
  dos_qmetaobject_delete(metaObject.vptr)
  metaObject.vptr.resetToNil

proc setup(superClass: QMetaObject,
           className: string,
           signals: seq[SignalDefinition],
           slots: seq[SlotDefinition],
           properties: seq[PropertyDefinition]): DosQMetaObject =
  var dosSignalParameters = newSeqOfCap[seq[DosParameterDefinition]](signals.len)
  for i in 0..<signals.len:
    var parameters = newSeqOfCap[DosParameterDefinition](signals[i].parameters.len)
    for p in signals[i].parameters:
      parameters.add(DosParameterDefinition(name: p.name.cstring, metaType: p.metaType.cint))
    dosSignalParameters.add(parameters)

  var dosSignals = newSeqOfCap[DosSignalDefinition](signals.len)
  for i in 0..<signals.len:
    let parametersCount = dosSignalParameters[i].len.cint
    let name = signals[i].name.cstring
    let dosSignal = DosSignalDefinition(name: name, parametersCount: parametersCount, parameters: if parametersCount > 0: dosSignalParameters[i][0].unsafeAddr else: nil)
    dosSignals.add(dosSignal)

  var dosSlotParameters = newSeqOfCap[seq[DosParameterDefinition]](slots.len)
  for i in 0..<slots.len:
    var parameters = newSeqOfCap[DosParameterDefinition](slots[i].parameters.len)
    for p in slots[i].parameters:
      parameters.add(DosParameterDefinition(name: p.name.cstring, metaType: p.metaType.cint))
    dosSlotParameters.add(parameters)

  var dosSlots = newSeqOfCap[DosSlotDefinition](slots.len)
  for i in 0..<slots.len:
    let parametersCount = dosSlotParameters[i].len.cint
    let name = slots[i].name.cstring
    let returnMetaType = slots[i].returnMetaType.cint
    let dosSlot = DosSlotDefinition(name: name, returnMetaType: returnMetaType,
                                    parametersCount: parametersCount, parameters: if parametersCount > 0: dosSlotParameters[i][0].unsafeAddr else: nil)
    dosSlots.add(dosSlot)

  var dosProperties = newSeqOfCap[DosPropertyDefinition](properties.len)
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

  let signals = DosSignalDefinitions(count: dosSignals.len.cint, definitions: if dosSignals.len > 0: dosSignals[0].unsafeAddr else: nil)
  let slots = DosSlotDefinitions(count: dosSlots.len.cint, definitions: if dosSlots.len > 0: dosSlots[0].unsafeAddr else: nil)
  let properties = DosPropertyDefinitions(count: dosProperties.len.cint, definitions: if dosProperties.len > 0: dosProperties[0].unsafeAddr else: nil)

  return dos_qmetaobject_create(superClass.vptr, className.cstring, signals.unsafeAddr, slots.unsafeAddr, properties.unsafeAddr)

proc invokeMethod*(typ: type QMetaObject, context: QObject, l: LambdaInvokerProc, connectionType: ConnectionType = ConnectionType.AutoConnection): bool =
  let id = LambdaInvoker.instance.add(l)
  result = dos_qmetaobject_invoke_method(context.vptr, lambdaCallback, cast[pointer](id), connectionType.cint)
