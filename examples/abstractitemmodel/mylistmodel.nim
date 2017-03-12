import NimQml, Tables

type
  RoleNames {.pure.} = enum
    Name = UserRole + 1,

QtObject:
  type
    MyListModel* = ref object of QAbstractItemModel
      names*: seq[string]

  proc delete(self: MyListModel) =
    self.QAbstractItemModel.delete

  proc setup(self: MyListModel) =
    self.QAbstractItemModel.setup

  proc newMyListModel*(): MyListModel =
    new(result, delete)
    result.names = @["John", "Max", "Paul", "Anna"]
    result.setup

  method columnCount(self: MyListModel, index: QModelIndex = nil): int =
    return 1

  method rowCount(self: MyListModel, index: QModelIndex = nil): int =
    return self.names.len

  method data(self: MyListModel, index: QModelIndex, role: int): QVariant =
    if not index.isValid:
      return
    if index.row < 0 or index.row >= self.names.len:
      return
    return newQVariant(self.names[index.row])

  method roleNames(self: MyListModel): Table[int, string] =
    { RoleNames.Name.int:"name"}.toTable
