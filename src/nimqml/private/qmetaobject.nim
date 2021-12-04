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
  var dosParameters: seq[seq[DosParameterDefinition]] = @[]

  var dosSignals: seq[DosSignalDefinition] = @[]
  for i in 0..<signals.len:
    let name = signals[i].name.cstring
    let parametersCount = signals[i].parameters.len.cint
    var parameters: seq[DosParameterDefinition] = @[]
    for p in signals[i].parameters:
      parameters.add(DosParameterDefinition(name: p.name.cstring, metaType: p.metaType.cint))
    let dosSignal = DosSignalDefinition(name: name, parametersCount: parametersCount, parameters: if parameters.len > 0: parameters[0].unsafeAddr else: nil)
    dosParameters.add(parameters)
    dosSignals.add(dosSignal)

  var dosSlots: seq[DosSlotDefinition] = @[]
  for i in 0..<slots.len:
    let name = slots[i].name.cstring
    let returnMetaType = slots[i].returnMetaType.cint
    let parametersCount = slots[i].parameters.len.cint
    var parameters: seq[DosParameterDefinition] = @[]
    for p in slots[i].parameters:
      parameters.add(DosParameterDefinition(name: p.name.cstring, metaType: p.metaType.cint))
    let dosSlot = DosSlotDefinition(name: name, returnMetaType: returnMetaType,
                                    parametersCount: parametersCount, parameters: if parameters.len > 0: parameters[0].unsafeAddr else: nil)
    dosParameters.add(parameters)
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

  let signals = DosSignalDefinitions(count: dosSignals.len.cint, definitions: if dosSignals.len > 0: dosSignals[0].unsafeAddr else: nil)
  let slots = DosSlotDefinitions(count: dosSlots.len.cint, definitions: if dosSlots.len > 0: dosSlots[0].unsafeAddr else: nil)
  let properties = DosPropertyDefinitions(count: dosProperties.len.cint, definitions: if dosProperties.len > 0: dosProperties[0].unsafeAddr else: nil)

  return dos_qmetaobject_create(superClass.vptr, className.cstring, signals.unsafeAddr, slots.unsafeAddr, properties.unsafeAddr)

proc invokeMethod*(typ: type QMetaObject, context: QObject, l: LambdaInvokerProc, connectionType: ConnectionType = ConnectionType.AutoConnection): bool =
  let id = LambdaInvoker.instance.add(l)
  result = dos_qmetaobject_invoke_method(context.vptr, lambdaCallback, cast[pointer](id), connectionType.cint)
