type
  QObject* = ref object of RootObj ## \
    ## A QObject
    vptr: DosQObject

  QAbstractListModel* = ref object of QObject ## \
    ## A QAbstractListModel

  QVariant* = ref object of RootObj ## \
    ## A QVariant
    vptr: DosQVariant

  QQmlApplicationEngine* = ref object of RootObj ## \
    ## A QQmlApplicationEngine
    vptr: DosQQmlApplicationEngine

  QApplication = ref object of RootObj ## \
    ## A QApplication
    deleted: bool

  QGuiApplication = ref object of RootObj ## \
    ## A QGuiApplication
    deleted: bool

  QQuickView* = ref object of RootObj ## \
    # A QQuickView
    vptr: DosQQuickView

  QHashIntByteArray* = ref object of RootObj ## \
    # A QHash<int, QByteArray>
    vptr: DosQHashIntByteArray

  QModelIndex* = ref object of RootObj ## \
    # A QModelIndex
    vptr: DosQModelIndex

  QResource* = ref object of RootObj ## \
    # A QResource

  QtItemFlag* {.pure.} = enum ## \
    ## Item flags
    ##
    ## This enum mimic the Qt::itemFlag C++ enum
    None = 0.cint,
    IsSelectable = 1.cint,
    IsEditable = 2.cint,
    IsDragEnabled = 4.cint,
    IsDropEnabled = 8.cint,
    IsUserCheckable = 16.cint,
    IsEnabled = 32.cint,
    IsTristate = 64.cint,
    NeverHasChildren = 128.cint

  QtOrientation* {.pure.} = enum ## \
    ## Define orientation
    ##
    ## This enum mimic the Qt::Orientation C++ enum
    Horizontal = 1.cint,
    Vertical = 2.cint

  QMetaType* {.pure.} = enum ## \
    ## Qt metatypes values used for specifing the
    ## signals and slots argument and return types.
    ##
    ## This enum mimic the QMetaType::Type C++ enum
    UnknownType = 0.cint,
    Bool = 1.cint,
    Int = 2.cint,
    QString = 10.cint,
    VoidStar = 31.cint,
    QObjectStar = 39.cint,
    QVariant = 41.cint,
    Void = 43.cint,

  SignalDefinition* = object
    name*: string
    parametersTypes*: seq[QMetaType]

  SlotDefinition* = object
    name*: string
    returnMetaType*: QMetaType
    parametersTypes*: seq[QMetaType]

  PropertyDefinition* = object
    name*: string
    propertyMetaType*: QMetaType
    readSlot*: string
    writeSlot*: string
    notifySignal*: string

  QMetaObject* = ref object of RootObj
    vptr: DosQMetaObject
    signals: seq[SignalDefinition]
    slots: seq[SlotDefinition]
    properties: seq[PropertyDefinition]

  QUrl* = ref object of RootObj
    vptr: DosQUrl

  QUrlParsingMode {.pure.} = enum
    Tolerant = 0.cint
    Strict = 1.cint
