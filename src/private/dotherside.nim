type
  NimQObject = pointer
  DosQMetaObject* = distinct pointer
  DosQObject* = distinct pointer
  DosQVariant* = distinct pointer
  DosQQmlContext* = distinct pointer
  DosQQmlApplicationEngine* = distinct pointer
  DosQVariantArray* {.unchecked.} = array[0..0, DosQVariant]
  DosQMetaType = cint
  DosQMetaTypeArray* {.unchecked.} = array[0..0, DosQMetaType]

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

  DosQObjectCallBack = proc(nimobject: NimQObject, slotName: DosQVariant, numArguments: cint, arguments: ptr DosQVariantArray) {.cdecl.}


# Conversion
proc resetToNil*[T](x: var T) = x = nil.pointer.T
proc isNil*[T](x: T): bool = x.pointer == nil

# QQmlContext
proc dos_qqmlcontext_setcontextproperty(context: DosQQmlContext, propertyName: cstring, propertyValue: DosQVariant) {.cdecl, importc.}

# QQmlApplicationEngine
proc dos_qqmlapplicationengine_create(engine: var DosQQmlApplicationEngine) {.cdecl, importc.}
proc dos_qqmlapplicationengine_load(engine: DosQQmlApplicationEngine, filename: cstring) {.cdecl, importc.}
proc dos_qqmlapplicationengine_load_data(engine: DosQQmlApplicationEngine, data: cstring) {.cdecl, importc.}
proc dos_qqmlapplicationengine_add_import_path(engine: DosQQmlApplicationEngine, path: cstring) {.cdecl, importc.}
proc dos_qqmlapplicationengine_context(engine: DosQQmlApplicationEngine, context: var DosQQmlContext) {.cdecl, importc.}
proc dos_qqmlapplicationengine_delete(engine: DosQQmlApplicationEngine) {.cdecl, importc.}

# QVariant
proc dos_qvariant_create(variant: var DosQVariant) {.cdecl, importc.}
proc dos_qvariant_create_int(variant: var DosQVariant, value: cint) {.cdecl, importc.}
proc dos_qvariant_create_bool(variant: var DosQVariant, value: bool) {.cdecl, importc.}
proc dos_qvariant_create_string(variant: var DosQVariant, value: cstring) {.cdecl, importc.}
proc dos_qvariant_create_qobject(variant: var DosQVariant, value: DosQObject) {.cdecl, importc.}
proc dos_qvariant_create_qvariant(variant: var DosQVariant, value: DosQVariant) {.cdecl, importc.}
proc dos_qvariant_create_float(variant: var DosQVariant, value: cfloat) {.cdecl, importc.}
proc dos_qvariant_create_double(variant: var DosQVariant, value: cdouble) {.cdecl, importc.}
proc dos_qvariant_delete(variant: DosQVariant) {.cdecl, importc.}
proc dos_qvariant_isnull(variant: DosQVariant, isNull: var bool) {.cdecl, importc.}
proc dos_qvariant_toInt(variant: DosQVariant, value: var cint) {.cdecl, importc.}
proc dos_qvariant_toBool(variant: DosQVariant, value: var bool) {.cdecl, importc.}
proc dos_qvariant_toString(variant: DosQVariant, value: var cstring) {.cdecl, importc.}
proc dos_qvariant_setInt(variant: DosQVariant, value: cint) {.cdecl, importc.}
proc dos_qvariant_setBool(variant: DosQVariant, value: bool) {.cdecl, importc.}
proc dos_qvariant_setString(variant: DosQVariant, value: cstring) {.cdecl, importc.}
proc dos_qvariant_assign(leftValue: DosQVariant, rightValue: DosQVariant) {.cdecl, importc.}
proc dos_qvariant_toFloat(variant: DosQVariant, value: var cfloat) {.cdecl, importc.}
proc dos_qvariant_setFloat(variant: DosQVariant, value: float)  {.cdecl, importc.}
proc dos_qvariant_toDouble(variant: DosQVariant, value: var cdouble) {.cdecl, importc.}
proc dos_qvariant_setDouble(variant: DosQVariant, value: cdouble) {.cdecl, importc.}
proc dos_qvariant_setQObject(variant: DosQVariant, value: DosQObject) {.cdecl, importc.}
proc dos_chararray_delete(str: cstring) {.cdecl, importc.}

# QObject
proc dos_qobject_qmetaobject*(vptr: var DosQmetaObject) {.cdecl, importc.}
proc dos_qobject_create(qobject: var DosQObject, nimobject: NimQObject, metaObject: DosQMetaObject, dosQObjectCallback: DosQObjectCallBack) {.cdecl, importc.}
proc dos_qobject_objectName(qobject: DosQObject, result: var cstring) {.cdecl, importc.}
proc dos_qobject_setObjectName(qobject: DosQObject, name: cstring) {.cdecl, importc.}
proc dos_qobject_signal_emit(qobject: DosQObject, signalName: cstring, argumentsCount: cint, arguments: ptr DosQVariantArray) {.cdecl, importc.}
proc dos_qobject_delete(qobject: DosQObject) {.cdecl, importc.}

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
