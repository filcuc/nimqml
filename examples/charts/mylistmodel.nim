import NimQml, Tables

type
  Point = object
    x: int
    y: int

QtObject:
  type
    MyListModel* = ref object of QAbstractListModel
      points*: seq[Point]

  proc delete(self: MyListModel) =
    self.QAbstractListModel.delete

  proc setup(self: MyListModel) =
    self.QAbstractListModel.setup

  proc newMyListModel*(): MyListModel =
    new(result, delete)
    result.points = @[Point(x: 10, y: 20), Point(x: 20, y: 30)]
    result.setup

  method rowCount(self: MyListModel, index: QModelIndex = nil): int =
    if index == nil or not index.isValid:
      return self.points.len
    return 0

  method columnCount(self: MyListModel, index: QModelIndex = nil): int =
    if index == nil or not index.isValid:
      return 2
    return 0

  method data(self: MyListModel, index: QModelIndex, role: int): QVariant =
    result = nil
    if not index.isValid:
      return 
    if index.row < 0 or index.row >= self.points.len:
      return
    if index.column < 0 or index.column >= 2:
      return
    let point = self.points[index.row]
    if index.column == 0:
      return newQVariant(point.x)
    elif index.column == 1:
      return newQVariant(point.y)
    else:
      return
