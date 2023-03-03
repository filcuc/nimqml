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

proc setup*(self: QAbstractListModel) =
  ## Setup a new QAbstractListModel
  debugMsg("QAbstractListModel", "setup")

  let qaimCallbacks = DosQAbstractItemModelCallbacks(rowCount: rowCountCallback,
  columnCount: columnCountCallback,
  data: dataCallback,
  setData: setDataCallback,
  roleNames: roleNamesCallback,
  flags: flagsCallback,
  headerData: headerDataCallback,
  index: indexCallback,
  parent: parentCallback,
  hasChildren: hasChildrenCallback,
  canFetchMore: canFetchMoreCallback,
  fetchMore: fetchMoreCallback)

  self.vptr = dos_qabstractlistmodel_create(addr(self[]), self.metaObject.vptr,
                                            qobjectCallback, qaimCallbacks).DosQObject

proc delete*(self: QAbstractListModel) =
  ## Delete the given QAbstractItemModel
  debugMsg("QAbstractItemModel", "delete")
  self.QObject.delete()

method columnCount(self: QAbstractListModel, index: QModelIndex): int =
  return dos_qabstractlistmodel_columnCount(self.vptr.DosQAbstractListModel, index.vptr)

method parent(self: QAbstractListModel, child: QModelIndex): QModelIndex =
  let indexPtr = dos_qabstractlistmodel_parent(self.vptr.DosQAbstractListModel, child.vptr)
  result = newQModelIndex(indexPtr, Ownership.Take)

method index*(self: QAbstractListModel, row: int, column: int, parent: QModelIndex): QModelIndex =
  let indexPtr = dos_qabstractlistmodel_index(self.vptr.DosQAbstractListModel, row.cint, column.cint, parent.vptr)
  result = newQModelIndex(indexPtr, Ownership.Take)

