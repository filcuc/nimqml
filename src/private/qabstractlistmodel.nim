import tables

let qAbstractListModelStaticMetaObjectInstance = newQAbstractListModelMetaObject()

proc staticMetaObject*(c: type QAbstractListModel): QMetaObject =
  ## Return the metaObject of QAbstractListModel
  qAbstractListModelStaticMetaObjectInstance

proc staticMetaObject*(self: QAbstractListModel): QMetaObject =
  ## Return the metaObject of QAbstractListModel
  qAbstractListModelStaticMetaObjectInstance

method metaObject*(self: QAbstractListModel): QMetaObject =
  # Return the metaObject
  QAbstractListModel.staticMetaObject

method rowCount*(self: QAbstractListModel, index: QModelIndex): cint {.base.} =
  ## Return the model's row count
  return 0

proc rowCountCallback(modelPtr: pointer, rawIndex: DosQModelIndex, result: var cint) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "rowCountCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  result = model.rowCount(index)

method columnCount*(self: QAbstractListModel, index: QModelIndex): cint {.base.} =
  ## Return the model's column count
  return 1

proc columnCountCallback(modelPtr: pointer, rawIndex: DosQModelIndex, result: var cint) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "columnCountCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  result = model.columnCount(index)

method data*(self: QAbstractListModel, index: QModelIndex, role: cint): QVariant {.base.} =
  ## Return the data at the given model index and role
  return nil

proc dataCallback(modelPtr: pointer, rawIndex: DosQModelIndex, role: cint, result: DosQVariant) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "dataCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  let variant = data(model, index, role)
  if variant != nil:
    dos_qvariant_assign(result, variant.vptr)
    variant.delete

method setData*(self: QAbstractListModel, index: QModelIndex, value: QVariant, role: cint): bool {.base.} =
  ## Sets the data at the given index and role. Return true on success, false otherwise
  return false

proc setDataCallback(modelPtr: pointer, rawIndex: DosQModelIndex, DosQVariant: DosQVariant,  role: cint, result: var bool) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "setDataCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  let variant = newQVariant(DosQVariant)
  result = model.setData(index, variant, role)

method roleNames*(self: QAbstractListModel): Table[cint, cstring] {.base.} =
  ## Return the model role names
  result = initTable[cint, cstring]()

proc roleNamesCallback(modelPtr: pointer, hash: DosQHashIntByteArray) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "roleNamesCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let table = model.roleNames()
  for key, val in table.pairs:
    dos_qhash_int_qbytearray_insert(hash, key, val)

method flags*(self: QAbstractListModel, index: QModelIndex): QtItemFlag {.base.} =
  ## Return the item flags and the given index
  return QtItemFlag.None

proc flagsCallback(modelPtr: pointer, rawIndex: DosQModelIndex, result: var cint) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "flagsCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  result = model.flags(index).cint

method headerData*(self: QAbstractListModel, section: cint, orientation: QtOrientation, role: cint): QVariant {.base.} =
  ## Returns the data for the given role and section in the header with the specified orientation
  return nil

proc headerDataCallback(modelPtr: pointer, section: cint, orientation: cint, role: cint, result: DosQVariant) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "headerDataCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let variant = model.headerData(section, orientation.QtOrientation, role)
  if variant != nil:
    dos_qvariant_assign(result, variant.vptr)
    variant.delete


method onSlotCalled*(self: QAbstractListModel, slotName: string, arguments: openarray[QVariant]) =
  ## Called from the dotherside library when a slot is called from Qml.

proc setup*(self: QAbstractListModel) =
  echo "NimQml: QAbstractListModel.setup"
  ## Setup a new QAbstractListModel
  dos_qabstractlistmodel_create(self.vptr.DosQAbstractListModel, addr(self[]), self.metaObject.vptr,
                                qobjectCallback, rowCountCallback, columnCountCallback,
                                dataCallback, setDataCallback, roleNamesCallback,
                                flagsCallback, headerDataCallback)

proc delete*(self: QAbstractListModel) =
  ## Delete the given QAbstractListModel
  if self.vptr.isNil:
    return
  debugMsg("QAbstractListModel", "delete")
  dos_qabstractlistmodel_delete(self.vptr.DosQAbstractListModel)
  self.vptr.resetToNil

proc newQAbstractListModel*(): QAbstractListModel =
  ## Return a new QAbstractListModel
  new(result, delete)
  result.setup()

proc beginInsertRows*(self: QAbstractListModel, parentIndex: QModelIndex, first: int, last: int) =
  ## Notify the view that the model is about to inserting the given number of rows
  dos_qabstractlistmodel_beginInsertRows(self.vptr.DosQAbstractListModel, parentIndex.vptr, first.cint, last.cint)

proc endInsertRows*(self: QAbstractListModel) =
  ## Notify the view that the rows have been inserted
  dos_qabstractlistmodel_endInsertRows(self.vptr.DosQAbstractListModel)

proc beginRemoveRows*(self: QAbstractListModel, parentIndex: QModelIndex, first: int, last: int) =
  ## Notify the view that the model is about to remove the given number of rows
  dos_qabstractlistmodel_beginRemoveRows(self.vptr.DosQAbstractListModel, parentIndex.vptr, first.cint, last.cint)

proc endRemoveRows*(self: QAbstractListModel) =
  ## Notify the view that the rows have been removed
  dos_qabstractlistmodel_endRemoveRows(self.vptr.DosQAbstractListModel)

proc beginResetModel*(self: QAbstractListModel) =
  ## Notify the view that the model is about to resetting
  dos_qabstractlistmodel_beginResetModel(self.vptr.DosQAbstractListModel)

proc endResetModel*(self: QAbstractListModel) =
  ## Notify the view that model has finished resetting
  dos_qabstractlistmodel_endResetModel(self.vptr.DosQAbstractListModel)

proc dataChanged*(self: QAbstractListModel,
                 topLeft: QModelIndex,
                 bottomRight: QModelIndex,
                 roles: seq[cint]) =
  ## Notify the view that the model data changed
  var copy = roles
  dos_qabstractlistmodel_dataChanged(self.vptr.DosQAbstractListModel, topLeft.vptr,
                                     bottomRight.vptr, copy[0].addr, copy.len.cint)
