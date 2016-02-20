proc setup*(self: var QModelIndex) =
  ## Setup a new QModelIndex
  dos_qmodelindex_create(self.vptr)

proc setup(self: var QModelIndex, vptr: DosQModelIndex) =
  ## Setup a new QModelIndex
  self.vptr = vptr

proc delete*(self: QModelIndex) =
  ## Delete the given QModelIndex
  if not self.vptr.isNil:
    return
  debugMsg("QModelIndex", "delete")
  dos_qmodelindex_delete(self.vptr)
  self.vptr.resetToNil

proc newQModelIndex*(): QModelIndex =
  ## Return a new QModelIndex
  new(result, delete)
  result.setup()

proc newQModelIndex(vptr: DosQModelIndex): QModelIndex =
  ## Return a new QModelIndex given a raw index
  new(result, delete)
  result.setup(vptr)

proc row*(self: QModelIndex): cint =
  ## Return the index row
  dos_qmodelindex_row(self.vptr, result)

proc column*(self: QModelIndex): cint =
  ## Return the index column
  dos_qmodelindex_column(self.vptr, result)

proc isValid*(self: QModelIndex): bool =
  ## Return true if the index is valid, false otherwise
  dos_qmodelindex_isValid(self.vptr, result)

proc data*(self: QModelIndex, role: cint): QVariant =
  ## Return the model data associated to the given role
  result = newQVariant()
  dos_qmodelindex_data(self.vptr, role, result.vptr)

proc parent*(self: QModelIndex): QModelIndex =
  ## Return the parent index
  result = newQModelIndex()
  dos_qmodelindex_parent(self.vptr, result.vptr)

proc child*(self: QModelIndex, row: cint, column: cint): QModelIndex =
  ## Return the child index associated to the given row and column
  result = newQModelIndex()
  dos_qmodelindex_child(self.vptr, row, column, result.vptr)

proc sibling*(self: QModelIndex, row: cint, column: cint): QModelIndex =
  ## Return the sibling index associated to the given row and column
  result = newQModelIndex()
  dos_qmodelindex_sibling(self.vptr, row, column, result.vptr)
