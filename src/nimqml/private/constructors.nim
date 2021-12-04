############# QObject #############
proc setup*(self: QObject) 
proc delete*(self: QObject) =
  debugMsg("QObject", "delete")
  ## Delete a QObject
  if not self.owner or self.vptr.isNil:
    return
  dos_qobject_delete(self.vptr)
  self.vptr.resetToNil

proc newQObject*(): QObject =
  ## Return a new QObject
  new(result, delete)
  result.setup()

############# QAbstractItemModel #############
proc setup*(self: QAbstractItemModel)
proc delete*(self: QAbstractItemModel)
proc newQAbstractItemModel*(): QAbstractItemModel =
  ## Return a new QAbstractItemModel
  debugMsg("QAbstractItemModel", "new")
  new(result, delete)
  result.setup()

############# QAbstractListModel #############
proc setup*(self: QAbstractListModel)
proc delete*(self: QAbstractListModel)
proc newQAbstractListModel*(): QAbstractListModel =
  ## Return a new QAbstractListModel
  debugMsg("QAbstractListModel", "new")
  new(result, delete)
  result.setup()

############# QAbstractTableModel #############
proc setup*(self: QAbstractTableModel)
proc delete*(self: QAbstractTableModel)
proc newQAbstractTableModel*(): QAbstractTableModel =
  ## Return a new QAbstractTableModel
  debugMsg("QAbstractTableModel", "new")
  new(result, delete)
  result.setup()

############# QVariant #############
proc setup*(variant: QVariant)
proc setup*(variant: QVariant, value: int)
proc setup*(variant: QVariant, value: bool)
proc setup*(variant: QVariant, value: string)
proc setup*(variant: QVariant, value: QObject)
proc setup*(variant: QVariant, value: DosQVariant, takeOwnership: Ownership)
proc setup*(variant: QVariant, value: cfloat)
proc setup*(variant: QVariant, value: cdouble)
proc setup*(variant: QVariant, value: QVariant)
proc delete*(variant: QVariant)

proc newQVariant*(): QVariant =
  ## Return a new QVariant
  new(result, delete)
  result.setup()

proc newQVariant*(value: int): QVariant =
  ## Return a new QVariant given a cint
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: bool): QVariant =
  ## Return a new QVariant given a bool
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: string): QVariant =
  ## Return a new QVariant given a string
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: QObject): QVariant =
  ## Return a new QVariant given a QObject
  new(result, delete)
  result.setup(value)

proc newQVariant(value: DosQVariant, takeOwnership: Ownership): QVariant =
  ## Return a new QVariant given a raw QVariant pointer
  new(result, delete)
  result.setup(value, takeOwnership)

proc newQVariant*(value: QVariant): QVariant =
  ## Return a new QVariant given another QVariant
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: cfloat): QVariant =
  ## Return a new QVariant given a float
  new(result, delete)
  result.setup(value)

############# QUrl #############
proc setup*(self: QUrl, url: string, mode: QUrlParsingMode)
proc delete*(self: QUrl)
proc newQUrl*(url: string, mode: QUrlParsingMode = QUrlParsingMode.Tolerant): QUrl =
  ## Create a new QUrl
  new(result, delete)
  result.setup(url, mode)

############# QQuickView #############
proc setup*(self: QQuickView)
proc delete*(self: QQuickView)
proc newQQuickView*(): QQuickView =
  ## Return a new QQuickView
  new(result, delete)
  result.setup()

############# QQmlApplicationEngine #############
proc setup*(self: QQmlApplicationEngine)
proc delete*(self: QQmlApplicationEngine)
proc newQQmlApplicationEngine*(): QQmlApplicationEngine =
  ## Return a new QQmlApplicationEngine
  new(result, delete)
  result.setup()

############# QModelIndex #############
proc setup*(self: QModelIndex)
proc setup(self: QModelIndex, other: DosQModelIndex, takeOwnership: Ownership)
proc delete*(self: QModelIndex)

proc newQModelIndex*(): QModelIndex =
  ## Return a new QModelIndex
  new(result, delete)
  result.setup()

proc newQModelIndex(vptr: DosQModelIndex, takeOwnership: Ownership): QModelIndex =
  ## Return a new QModelIndex given a raw index
  new(result, delete)
  result.setup(vptr, takeOwnership)  

############# QMetaObjectConnection #############
proc delete*(self: QMetaObjectConnection)
proc new*(typ: type QMetaObjectConnection, vptr: DosQMetaObjectConnection): QMetaObjectConnection =
  new(result, delete)
  result.vptr = vptr  

############# QMetaObject #############
proc setup(superClass: QMetaObject,
           className: string,
           signals: seq[SignalDefinition],
           slots: seq[SlotDefinition],
           properties: seq[PropertyDefinition]): DosQMetaObject
proc delete*(metaObject: QMetaObject)

proc newQObjectMetaObject*(): QMetaObject =
  ## Create the QMetaObject of QObject
  debugMsg("QMetaObject", "newQObjectMetaObject")
  new(result, delete)
  result.vptr = dos_qobject_qmetaobject()

proc newQAbstractItemModelMetaObject*(): QMetaObject =
  ## Create the QMetaObject of QAbstractItemModel
  debugMsg("QMetaObject", "newQAbstractItemModelMetaObject")
  new(result, delete)
  result.vptr = dos_qabstractitemmodel_qmetaobject()

proc newQAbstractListModelMetaObject*(): QMetaObject =
  ## Create the QMetaObject of QAbstractListModel
  debugMsg("QMetaObject", "newQAbstractListModelMetaObject")
  new(result, delete)
  result.vptr = dos_qabstractlistmodel_qmetaobject()

proc newQAbstractTableModelMetaObject*(): QMetaObject =
  ## Create the QMetaObject of QAbstractTableModel
  debugMsg("QMetaObject", "newQAbstractItemTableMetaObject")
  new(result, delete)
  result.vptr = dos_qabstracttablemodel_qmetaobject()

proc newQMetaObject*(superClass: QMetaObject, className: string,
                     signals: seq[SignalDefinition],
                     slots: seq[SlotDefinition],
                     properties: seq[PropertyDefinition]): QMetaObject =
  ## Create a new QMetaObject
  debugMsg("QMetaObject", "newQMetaObject" & className)
  new(result, delete)
  result.signals = signals
  result.slots = slots
  result.properties = properties
  result.vptr = setup(superClass, className, signals, slots, properties)

############# QHashIntByteArray #############
proc setup*(self: QHashIntByteArray)
proc delete*(self: QHashIntByteArray)
proc newQHashIntQByteArray*(): QHashIntByteArray =
  ## Create a new QHashIntQByteArray
  new(result, delete)
  result.setup()

############# QGuiApplication #############
proc setup*(self: QGuiApplication)
proc delete*(self: QGuiApplication)
proc newQGuiApplication*(): QGuiApplication =
  ## Return a new QApplication
  new(result, delete)
  result.setup()

############# LambdaInvoker #############
proc new(typ: type LambdaInvoker): LambdaInvoker =
  ## Create the lambda invoker
  new(result)
  result.id = 0
  result.lock.initLock()
  result.lambdas = initTable[int, LambdaInvokerProc]()
  
