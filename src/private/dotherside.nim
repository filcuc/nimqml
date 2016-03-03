type
  NimQObject = pointer
  NimQAbstractListModel = pointer
  DosQMetaObject = distinct pointer
  DosQObject = distinct pointer
  DosQObjectWrapper = distinct pointer
  DosQVariant = distinct pointer
  DosQQmlContext = distinct pointer
  DosQQmlApplicationEngine = distinct pointer
  DosQVariantArray {.unchecked.} = array[0..0, DosQVariant]
  DosQMetaType = cint
  DosQMetaTypeArray {.unchecked.} = array[0..0, DosQMetaType]
  DosQUrl = distinct pointer
  DosQQuickView = distinct pointer
  DosQHashIntByteArray = distinct pointer
  DosQModelIndex = distinct pointer
  DosQAbstractListModel = distinct pointer

  DosSignalDefinition = object
    name: cstring
    parametersCount: cint
    parametersMetaTypes: pointer

  DosSignalDefinitions = object
    count: cint
    definitions: pointer

  DosSlotDefinition = object
    name: cstring
    returnMetaType: cint
    parametersCount: cint
    parametersMetaTypes: pointer

  DosSlotDefinitions = object
    count: cint
    definitions: pointer

  DosPropertyDefinition = object
    name: cstring
    propertyMetaType: cint
    readSlot: cstring
    writeSlot: cstring
    notifySignal: cstring

  DosPropertyDefinitions = object
    count: cint
    definitions: pointer

  DosCreateCallback = proc(id: cint, wrapper: DosQObjectWrapper, nimQObject: var NimQObject, dosQObject: var DosQObject) {.cdecl.}
  DosDeleteCallback = proc(id: cint, nimQObject: NimQObject) {.cdecl.}

  DosQmlRegisterType = object
    major: cint
    minor: cint
    uri: cstring
    qml: cstring
    staticMetaObject: DosQMetaObject
    createCallback: DosCreateCallback
    deleteCallback: DosDeleteCallback

  DosQObjectCallBack = proc(nimobject: NimQObject, slotName: DosQVariant, numArguments: cint, arguments: ptr DosQVariantArray) {.cdecl.}

  DosRowCountCallback    = proc(nimmodel: NimQAbstractListModel, rawIndex: DosQModelIndex, result: var cint) {.cdecl.}
  DosColumnCountCallback = proc(nimmodel: NimQAbstractListModel, rawIndex: DosQModelIndex, result: var cint) {.cdecl.}
  DosDataCallback        = proc(nimmodel: NimQAbstractListModel, rawIndex: DosQModelIndex, role: cint, result: DosQVariant) {.cdecl.}
  DosSetDataCallback     = proc(nimmodel: NimQAbstractListModel, rawIndex: DosQModelIndex, value: DosQVariant, role: cint, result: var bool) {.cdecl.}
  DosRoleNamesCallback   = proc(nimmodel: NimQAbstractListModel, result: DosQHashIntByteArray) {.cdecl.}
  DosFlagsCallback       = proc(nimmodel: NimQAbstractListModel, index: DosQModelIndex, result: var cint) {.cdecl.}
  DosHeaderDataCallback  = proc(nimmodel: NimQAbstractListModel, section: cint, orientation: cint, role: cint, result: DosQVariant) {.cdecl.}

# Conversion
proc resetToNil[T](x: var T) = x = nil.pointer.T
proc isNil[T](x: T): bool = x.pointer == nil

# QApplication
proc dos_qapplication_create() {.cdecl, importc.}
proc dos_qapplication_exec() {.cdecl, importc.}
proc dos_qapplication_quit() {.cdecl, importc.}
proc dos_qapplication_delete() {.cdecl, importc.}

# QGuiApplication
proc dos_qguiapplication_create() {.cdecl, importc.}
proc dos_qguiapplication_exec() {.cdecl, importc.}
proc dos_qguiapplication_quit() {.cdecl, importc.}
proc dos_qguiapplication_delete() {.cdecl, importc.}

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
proc dos_qobject_qmetaobject(vptr: var DosQmetaObject) {.cdecl, importc.}
proc dos_qobject_create(qobject: var DosQObject, nimobject: NimQObject, metaObject: DosQMetaObject, dosQObjectCallback: DosQObjectCallBack) {.cdecl, importc.}
proc dos_qobject_objectName(qobject: DosQObject, result: var cstring) {.cdecl, importc.}
proc dos_qobject_setObjectName(qobject: DosQObject, name: cstring) {.cdecl, importc.}
proc dos_qobject_signal_emit(qobject: DosQObject, signalName: cstring, argumentsCount: cint, arguments: ptr DosQVariantArray) {.cdecl, importc.}
proc dos_qobject_delete(qobject: DosQObject) {.cdecl, importc.}

# QAbstractListModel
proc dos_qabstractlistmodel_qmetaobject(vptr: var DosQmetaObject) {.cdecl importc.}

# QMetaObject
proc dos_qmetaobject_create(vptr: var DosQmetaObject,
                             superclassMetaObject: DosQMetaObject,
                             className: cstring,
                             signalDefinitions: ptr DosSignalDefinitions,
                             slotDefinitions: ptr DosSlotDefinitions,
                             propertyDefinitions: ptr DosPropertyDefinitions) {.cdecl, importc.}
proc dos_qmetaobject_delete(vptr: DosQmetaObject) {.cdecl, importc.}

# QUrl
proc dos_qurl_create(vptr: var DosQUrl, url: cstring, parsingMode: cint) {.cdecl, importc.}
proc dos_qurl_delete(vptr: DosQUrl) {.cdecl, importc.}
proc dos_qurl_to_string(vptr: DosQUrl, str: var cstring) {.cdecl, importc.}

# QQuickView
proc dos_qquickview_create(view: var DosQQuickView) {.cdecl, importc.}
proc dos_qquickview_delete(view: DosQQuickView) {.cdecl, importc.}
proc dos_qquickview_show(view: DosQQuickView) {.cdecl, importc.}
proc dos_qquickview_source(view: DosQQuickView, filename: var cstring, length: var int) {.cdecl, importc.}
proc dos_qquickview_set_source(view: DosQQuickView, filename: cstring) {.cdecl, importc.}

# QHash<int, QByteArra>
proc dos_qhash_int_qbytearray_create(qHash: var DosQHashIntByteArray) {.cdecl, importc.}
proc dos_qhash_int_qbytearray_delete(qHash: DosQHashIntByteArray) {.cdecl, importc.}
proc dos_qhash_int_qbytearray_insert(qHash: DosQHashIntByteArray, key: int, value: cstring) {.cdecl, importc.}
proc dos_qhash_int_qbytearray_value(qHash: DosQHashIntByteArray, key: int, value: var cstring) {.cdecl, importc.}

# QModelIndex
proc dos_qmodelindex_create(modelIndex: var DosQModelIndex) {.cdecl, importc.}
proc dos_qmodelindex_create_qmodelindex(modelIndex: var DosQModelIndex, other: DosQModelIndex) {.cdecl, importc.}
proc dos_qmodelindex_delete(modelIndex: DosQModelIndex) {.cdecl, importc.}
proc dos_qmodelindex_row(modelIndex: DosQModelIndex, row: var cint) {.cdecl, importc.}
proc dos_qmodelindex_column(modelIndex: DosQModelIndex, column: var cint) {.cdecl, importc.}
proc dos_qmodelindex_isValid(modelIndex: DosQModelIndex, column: var bool) {.cdecl, importc.}
proc dos_qmodelindex_data(modelIndex: DosQModelIndex, role: cint, data: DosQVariant) {.cdecl, importc.}
proc dos_qmodelindex_parent(modelIndex: DosQModelIndex, parent: DosQModelIndex) {.cdecl, importc.}
proc dos_qmodelindex_child(modelIndex: DosQModelIndex, row: cint, column: cint, parent: DosQModelIndex) {.cdecl, importc.}
proc dos_qmodelindex_sibling(modelIndex: DosQModelIndex, row: cint, column: cint, sibling: DosQModelIndex) {.cdecl, importc.}
proc dos_qmodelindex_assign(leftSide: DosQModelIndex, rightSide: DosQModelIndex) {.cdecl, importc.}

# QAbstractListModel
proc dos_qabstractlistmodel_create(model: var DosQAbstractListModel,
                                   modelPtr: NimQAbstractListModel,
                                   metaObject: DosQMetaObject,
                                   qobjectCallback: DosQObjectCallBack,
                                   rowCountCallback: DosRowCountCallback,
                                   columnCountCallback: DosColumnCountCallback,
                                   dataCallback: DosDataCallback,
                                   setDataCallback: DosSetDataCallBack,
                                   roleNamesCallback: DosRoleNamesCallback,
                                   flagsCallback: DosFlagsCallback,
                                   headerDataCallback: DosHeaderDataCallback) {.cdecl, importc.}

proc dos_qabstractlistmodel_delete(model: DosQAbstractListModel) {.cdecl, importc.}
proc dos_qabstractlistmodel_beginInsertRows(model: DosQAbstractListModel,
                                            parentIndex: DosQModelIndex,
                                            first: cint,
                                            last: cint) {.cdecl, importc.}
proc dos_qabstractlistmodel_endInsertRows(model: DosQAbstractListModel) {.cdecl, importc.}
proc dos_qabstractlistmodel_beginRemoveRows(model: DosQAbstractListModel,
                                            parentIndex: DosQModelIndex,
                                            first: cint,
                                            last: cint) {.cdecl, importc.}
proc dos_qabstractlistmodel_endRemoveRows(model: DosQAbstractListModel) {.cdecl, importc.}
proc dos_qabstractlistmodel_beginResetModel(model: DosQAbstractListModel) {.cdecl, importc.}
proc dos_qabstractlistmodel_endResetModel(model: DosQAbstractListModel) {.cdecl, importc.}
proc dos_qabstractlistmodel_dataChanged(model: DosQAbstractListModel,
                                        parentLeft: DosQModelIndex,
                                        bottomRight: DosQModelIndex,
                                        rolesArrayPtr: ptr cint,
                                        rolesArrayLength: cint) {.cdecl, importc.}

# QResource
proc dos_qresource_register(filename: cstring) {.cdecl, importc.}

# QDeclarative
proc dos_qdeclarative_qmlregistertype(value: ptr DosQmlRegisterType, result: var cint) {.cdecl, importc.}
proc dos_qdeclarative_qmlregistersingletontype(value: ptr DosQmlRegisterType, result: var cint) {.cdecl, importc.}
