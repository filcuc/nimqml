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

method rowCount*(self: QAbstractListModel, index: QModelIndex): int {.base.} =
  ## Return the model's row count
  0

proc rowCountCallback(modelPtr: pointer, rawIndex: DosQModelIndex, result: var cint) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "rowCountCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  result = model.rowCount(index).cint

method columnCount*(self: QAbstractListModel, index: QModelIndex): int {.base.} =
  ## Return the model's column count
  1

proc columnCountCallback(modelPtr: pointer, rawIndex: DosQModelIndex, result: var cint) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "columnCountCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  result = model.columnCount(index).cint

method data*(self: QAbstractListModel, index: QModelIndex, role: int): QVariant {.base.} =
  ## Return the data at the given model index and role
  nil

proc dataCallback(modelPtr: pointer, rawIndex: DosQModelIndex, role: cint, result: DosQVariant) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "dataCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  let variant = data(model, index, role.int)
  if variant != nil:
    dos_qvariant_assign(result, variant.vptr)
    variant.delete

method setData*(self: QAbstractListModel, index: QModelIndex, value: QVariant, role: int): bool {.base.} =
  ## Sets the data at the given index and role. Return true on success, false otherwise
  false

proc setDataCallback(modelPtr: pointer, rawIndex: DosQModelIndex, DosQVariant: DosQVariant,  role: cint, result: var bool) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "setDataCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  let variant = newQVariant(DosQVariant)
  result = model.setData(index, variant, role.int)

method roleNames*(self: QAbstractListModel): Table[int,string] {.base.} =
  ## Return the model role names
  nil

proc roleNamesCallback(modelPtr: pointer, hash: DosQHashIntByteArray) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "roleNamesCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let table = model.roleNames()
  for key, val in table.pairs:
    dos_qhash_int_qbytearray_insert(hash, key.cint, val.cstring)

method flags*(self: QAbstractListModel, index: QModelIndex): QtItemFlag {.base.} =
  ## Return the item flags and the given index
  return QtItemFlag.None

proc flagsCallback(modelPtr: pointer, rawIndex: DosQModelIndex, result: var cint) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "flagsCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let index = newQModelIndex(rawIndex)
  result = model.flags(index).cint

method headerData*(self: QAbstractListModel, section: int, orientation: QtOrientation, role: int): QVariant {.base.} =
  ## Returns the data for the given role and section in the header with the specified orientation
  nil

proc headerDataCallback(modelPtr: pointer, section: cint, orientation: cint, role: cint, result: DosQVariant) {.cdecl, exportc.} =
  debugMsg("QAbstractListModel", "headerDataCallback")
  let model = cast[QAbstractListModel](modelPtr)
  let variant = model.headerData(section.int, orientation.QtOrientation, role.int)
  if variant != nil:
    dos_qvariant_assign(result, variant.vptr)
    variant.delete

method onSlotCalled*(self: QAbstractListModel, slotName: string, arguments: openarray[QVariant]) =
  ## Called from the dotherside library when a slot is called from Qml.

proc setup*(self: QAbstractListModel) =
  ## Setup a new QAbstractListModel
  debugMsg("QAbstractListModel", "setup")
  self.vptr = dos_qabstractlistmodel_create(addr(self[]), self.metaObject.vptr,
                                            qobjectCallback, rowCountCallback, columnCountCallback,
                                            dataCallback, setDataCallback, roleNamesCallback,
                                            flagsCallback, headerDataCallback).DosQObject

proc delete*(self: QAbstractListModel) =
  ## Delete the given QAbstractListModel
  debugMsg("QAbstractListModel", "delete")
  self.QObject.delete()

proc newQAbstractListModel*(): QAbstractListModel =
  ## Return a new QAbstractListModel
  debugMsg("QAbstractListModel", "new")
  new(result, delete)
  result.setup()

proc beginInsertRows*(self: QAbstractListModel, parentIndex: QModelIndex, first: int, last: int) =
  ## Notify the view that the model is about to inserting the given number of rows
  debugMsg("QAbstractListModel", "beginInsertRows")
  dos_qabstractlistmodel_beginInsertRows(self.vptr.DosQAbstractListModel, parentIndex.vptr, first.cint, last.cint)

proc endInsertRows*(self: QAbstractListModel) =
  ## Notify the view that the rows have been inserted
  debugMsg("QAbstractListModel", "endInsertRows")
  dos_qabstractlistmodel_endInsertRows(self.vptr.DosQAbstractListModel)

proc beginRemoveRows*(self: QAbstractListModel, parentIndex: QModelIndex, first: int, last: int) =
  ## Notify the view that the model is about to remove the given number of rows
  debugMsg("QAbstractListModel", "beginRemoveRows")
  dos_qabstractlistmodel_beginRemoveRows(self.vptr.DosQAbstractListModel, parentIndex.vptr, first.cint, last.cint)

proc endRemoveRows*(self: QAbstractListModel) =
  ## Notify the view that the rows have been removed
  debugMsg("QAbstractListModel", "endRemoveRows")
  dos_qabstractlistmodel_endRemoveRows(self.vptr.DosQAbstractListModel)

proc beginResetModel*(self: QAbstractListModel) =
  ## Notify the view that the model is about to resetting
  debugMsg("QAbstractListModel", "beginResetModel")
  dos_qabstractlistmodel_beginResetModel(self.vptr.DosQAbstractListModel)

proc endResetModel*(self: QAbstractListModel) =
  ## Notify the view that model has finished resetting
  debugMsg("QAbstractListModel", "endResetModel")
  dos_qabstractlistmodel_endResetModel(self.vptr.DosQAbstractListModel)

proc dataChanged*(self: QAbstractListModel,
                 topLeft: QModelIndex,
                 bottomRight: QModelIndex,
                 roles: openArray[int]) =
  ## Notify the view that the model data changed
  debugMsg("QAbstractListModel", "dataChanged")
  var copy: seq[cint]
  for i in roles:
    copy.add(i.cint)
  dos_qabstractlistmodel_dataChanged(self.vptr.DosQAbstractListModel, topLeft.vptr,
                                     bottomRight.vptr, copy[0].addr, copy.len.cint)
