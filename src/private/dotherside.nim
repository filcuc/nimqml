import os, strutils

proc getDllName: string =
  case system.hostOS:
    of "windows":
      "DOtherSide.dll"
    of "macosx":
      "libDOtherSide.dylib"
    else:
      "libDOtherSide.so"

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
proc isNil(x: DosQMetaObject): bool = x.pointer.isNil
proc isNil(x: DosQVariant): bool = x.pointer.isNil
proc isNil(x: DosQObject): bool = x.pointer.isNil
proc isNil(x: DosQQmlApplicationEngine): bool = x.pointer.isNil
proc isNil(x: DosQUrl): bool = x.pointer.isNil
proc isNil(x: DosQQuickView): bool = x.pointer.isNil
proc isNil(x: DosQHashIntByteArray): bool = x.pointer.isNil
proc isNil(x: DosQModelIndex): bool = x.pointer.isNil

# CharArray
proc dos_chararray_delete(str: cstring) {.cdecl, dynlib: getDllName(), importc.}

# QCoreApplication
proc dos_qcoreapplication_application_dir_path(): cstring {.cdecl, dynlib: getDllName(), importc.}

# QApplication
proc dos_qapplication_create() {.cdecl, dynlib: getDllName(), importc.}
proc dos_qapplication_exec() {.cdecl, dynlib: getDllName(), importc.}
proc dos_qapplication_quit() {.cdecl, dynlib: getDllName(), importc.}
proc dos_qapplication_delete() {.cdecl, dynlib: getDllName(), importc.}

# QGuiApplication
proc dos_qguiapplication_create() {.cdecl, dynlib: getDllName(), importc.}
proc dos_qguiapplication_exec() {.cdecl, dynlib: getDllName(), importc.}
proc dos_qguiapplication_quit() {.cdecl, dynlib: getDllName(), importc.}
proc dos_qguiapplication_delete() {.cdecl, dynlib: getDllName(), importc.}

# QQmlContext
proc dos_qqmlcontext_setcontextproperty(context: DosQQmlContext, propertyName: cstring, propertyValue: DosQVariant) {.cdecl, dynlib: getDllName(), importc.}

# QQmlApplicationEngine
proc dos_qqmlapplicationengine_create(): DosQQmlApplicationEngine {.cdecl, dynlib: getDllName(), importc.}
proc dos_qqmlapplicationengine_load(engine: DosQQmlApplicationEngine, filename: cstring) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qqmlapplicationengine_load_url(engine: DosQQmlApplicationEngine, url: DosQUrl) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qqmlapplicationengine_load_data(engine: DosQQmlApplicationEngine, data: cstring) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qqmlapplicationengine_add_import_path(engine: DosQQmlApplicationEngine, path: cstring) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qqmlapplicationengine_context(engine: DosQQmlApplicationEngine): DosQQmlContext {.cdecl, dynlib: getDllName(), importc.}
proc dos_qqmlapplicationengine_delete(engine: DosQQmlApplicationEngine) {.cdecl, dynlib: getDllName(), importc.}

# QVariant
proc dos_qvariant_create(): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_int(value: cint): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_bool(value: bool): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_string(value: cstring): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_qobject(value: DosQObject): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_qvariant(value: DosQVariant): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_float(value: cfloat): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_create_double(value: cdouble): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_delete(variant: DosQVariant) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_isnull(variant: DosQVariant): bool {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_toInt(variant: DosQVariant): cint {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_toBool(variant: DosQVariant): bool {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_toString(variant: DosQVariant): cstring {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_toDouble(variant: DosQVariant): cdouble {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_toFloat(variant: DosQVariant): cfloat {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_setInt(variant: DosQVariant, value: cint) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_setBool(variant: DosQVariant, value: bool) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_setString(variant: DosQVariant, value: cstring) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_assign(leftValue: DosQVariant, rightValue: DosQVariant) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_setFloat(variant: DosQVariant, value: float)  {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_setDouble(variant: DosQVariant, value: cdouble) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qvariant_setQObject(variant: DosQVariant, value: DosQObject) {.cdecl, dynlib: getDllName(), importc.}

# QObject
proc dos_qobject_qmetaobject(): DosQMetaObject {.cdecl, dynlib: getDllName(), importc.}
proc dos_qobject_create(nimobject: NimQObject, metaObject: DosQMetaObject, dosQObjectCallback: DosQObjectCallBack): DosQObject {.cdecl, dynlib: getDllName(), importc.}
proc dos_qobject_objectName(qobject: DosQObject): cstring {.cdecl, dynlib: getDllName(), importc.}
proc dos_qobject_setObjectName(qobject: DosQObject, name: cstring) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qobject_signal_emit(qobject: DosQObject, signalName: cstring, argumentsCount: cint, arguments: ptr DosQVariantArray) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qobject_delete(qobject: DosQObject) {.cdecl, dynlib: getDllName(), importc.}

# QAbstractListModel
proc dos_qabstractlistmodel_qmetaobject(): DosQMetaObject {.cdecl dynlib: getDllName(), importc.}

# QMetaObject
proc dos_qmetaobject_create(superclassMetaObject: DosQMetaObject,
                            className: cstring,
                            signalDefinitions: ptr DosSignalDefinitions,
                            slotDefinitions: ptr DosSlotDefinitions,
                            propertyDefinitions: ptr DosPropertyDefinitions): DosQMetaObject {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmetaobject_delete(vptr: DosQMetaObject) {.cdecl, dynlib: getDllName(), importc.}

# QUrl
proc dos_qurl_create(url: cstring, parsingMode: cint): DosQUrl {.cdecl, dynlib: getDllName(), importc.}
proc dos_qurl_delete(vptr: DosQUrl) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qurl_to_string(vptr: DosQUrl): cstring {.cdecl, dynlib: getDllName(), importc.}

# QQuickView
proc dos_qquickview_create(): DosQQuickView {.cdecl, dynlib: getDllName(), importc.}
proc dos_qquickview_delete(view: DosQQuickView) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qquickview_show(view: DosQQuickView) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qquickview_source(view: DosQQuickView): cstring {.cdecl, dynlib: getDllName(), importc.}
proc dos_qquickview_set_source(view: DosQQuickView, filename: cstring) {.cdecl, dynlib: getDllName(), importc.}

# QHash<int, QByteArra>
proc dos_qhash_int_qbytearray_create(): DosQHashIntByteArray {.cdecl, dynlib: getDllName(), importc.}
proc dos_qhash_int_qbytearray_delete(qHash: DosQHashIntByteArray) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qhash_int_qbytearray_insert(qHash: DosQHashIntByteArray, key: int, value: cstring) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qhash_int_qbytearray_value(qHash: DosQHashIntByteArray, key: int): cstring {.cdecl, dynlib: getDllName(), importc.}

# QModelIndex
proc dos_qmodelindex_create(): DosQModelIndex {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_create_qmodelindex(other: DosQModelIndex): DosQModelIndex {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_delete(modelIndex: DosQModelIndex) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_row(modelIndex: DosQModelIndex): cint {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_column(modelIndex: DosQModelIndex): cint {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_isValid(modelIndex: DosQModelIndex): bool {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_data(modelIndex: DosQModelIndex, role: cint): DosQVariant {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_parent(modelIndex: DosQModelIndex): DosQModelIndex {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_child(modelIndex: DosQModelIndex, row: cint, column: cint): DosQModelIndex {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_sibling(modelIndex: DosQModelIndex, row: cint, column: cint): DosQModelIndex {.cdecl, dynlib: getDllName(), importc.}
proc dos_qmodelindex_assign(leftSide: DosQModelIndex, rightSide: DosQModelIndex) {.cdecl, dynlib: getDllName(), importc.}

# QAbstractListModel
proc dos_qabstractlistmodel_create(modelPtr: NimQAbstractListModel,
                                   metaObject: DosQMetaObject,
                                   qobjectCallback: DosQObjectCallBack,
                                   rowCountCallback: DosRowCountCallback,
                                   columnCountCallback: DosColumnCountCallback,
                                   dataCallback: DosDataCallback,
                                   setDataCallback: DosSetDataCallBack,
                                   roleNamesCallback: DosRoleNamesCallback,
                                   flagsCallback: DosFlagsCallback,
                                   headerDataCallback: DosHeaderDataCallback): DosQAbstractListModel {.cdecl, dynlib: getDllName(), importc.}

proc dos_qabstractlistmodel_beginInsertRows(model: DosQAbstractListModel,
                                            parentIndex: DosQModelIndex,
                                            first: cint,
                                            last: cint) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qabstractlistmodel_endInsertRows(model: DosQAbstractListModel) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qabstractlistmodel_beginRemoveRows(model: DosQAbstractListModel,
                                            parentIndex: DosQModelIndex,
                                            first: cint,
                                            last: cint) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qabstractlistmodel_endRemoveRows(model: DosQAbstractListModel) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qabstractlistmodel_beginResetModel(model: DosQAbstractListModel) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qabstractlistmodel_endResetModel(model: DosQAbstractListModel) {.cdecl, dynlib: getDllName(), importc.}
proc dos_qabstractlistmodel_dataChanged(model: DosQAbstractListModel,
                                        parentLeft: DosQModelIndex,
                                        bottomRight: DosQModelIndex,
                                        rolesArrayPtr: ptr cint,
                                        rolesArrayLength: cint) {.cdecl, dynlib: getDllName(), importc.}

# QResource
proc dos_qresource_register(filename: cstring) {.cdecl, dynlib: getDllName(), importc.}

# QDeclarative
proc dos_qdeclarative_qmlregistertype(value: ptr DosQmlRegisterType): cint {.cdecl, dynlib: getDllName(), importc.}
proc dos_qdeclarative_qmlregistersingletontype(value: ptr DosQmlRegisterType): cint {.cdecl, dynlib: getDllName(), importc.}
