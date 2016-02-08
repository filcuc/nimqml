proc setup*(variant: QVariant) =
  ## Setup a new QVariant
  dos_qvariant_create(variant.vptr)

proc setup*(variant: QVariant, value: cint) =
  ## Setup a new QVariant given a cint value
  dos_qvariant_create_int(variant.vptr, value)

proc setup*(variant: QVariant, value: bool) =
  ## Setup a new QVariant given a bool value
  dos_qvariant_create_bool(variant.vptr, value)

proc setup*(variant: QVariant, value: string) =
  ## Setup a new QVariant given a string value
  dos_qvariant_create_string(variant.vptr, value)

proc setup*(variant: QVariant, value: QObject) =
  ## Setup a new QVariant given a QObject
  dos_qvariant_create_qobject(variant.vptr, value.vptr.DosQObject)

proc setup*(variant: QVariant, value: DosQVariant) =
  ## Setup a new QVariant given another QVariant.
  ## The inner value of the QVariant is copied
  dos_qvariant_create_qvariant(variant.vptr, value)

proc setup*(variant: QVariant, value: cfloat) =
  ## Setup a new QVariant given a cfloat value
  dos_qvariant_create_float(variant.vptr, value)

proc setup*(variant: QVariant, value: cdouble) =
  ## Setup a new QVariant given a cdouble value
  dos_qvariant_create_double(variant.vptr, value)

proc setup*(variant: QVariant, value: QVariant) =
  ## Setup a new QVariant given another QVariant.
  ## The inner value of the QVariant is copied
  setup(variant, value.vptr)

proc delete*(variant: QVariant) =
  ## Delete a QVariant
  if variant.vptr.isNil:
    return
  debugMsg("QVariant", "delete")
  dos_qvariant_delete(variant.vptr)
  variant.vptr.resetToNil

proc newQVariant*(): QVariant =
  ## Return a new QVariant
  new(result, delete)
  result.setup()

proc newQVariant*(value: cint): QVariant =
  ## Return a new QVariant given a cint
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: bool): QVariant  =
  ## Return a new QVariant given a bool
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: string): QVariant  =
  ## Return a new QVariant given a string
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: QObject): QVariant  =
  ## Return a new QVariant given a QObject
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: DosQVariant): QVariant =
  ## Return a new QVariant given a raw QVariant pointer
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: QVariant): QVariant =
  ## Return a new QVariant given another QVariant
  new(result, delete)
  result.setup(value)

proc newQVariant*(value: float): QVariant =
  ## Return a new QVariant given a float
  new(result, delete)
  result.setup(value)

proc isNull*(variant: QVariant): bool =
  ## Return true if the QVariant value is null, false otherwise
  dos_qvariant_isnull(variant.vptr, result)

proc intVal*(variant: QVariant): int =
  ## Return the QVariant value as int
  var rawValue: cint
  dos_qvariant_toInt(variant.vptr, rawValue)
  result = rawValue.cint

proc `intVal=`*(variant: QVariant, value: int) =
  ## Sets the QVariant value int value
  var rawValue = value.cint
  dos_qvariant_setInt(variant.vptr, rawValue)

proc boolVal*(variant: QVariant): bool =
  ## Return the QVariant value as bool
  dos_qvariant_toBool(variant.vptr, result)

proc `boolVal=`*(variant: QVariant, value: bool) =
  ## Sets the QVariant bool value
  dos_qvariant_setBool(variant.vptr, value)

proc floatVal*(variant: QVariant): float =
  ## Return the QVariant value as float
  var rawValue: cfloat
  dos_qvariant_toFloat(variant.vptr, rawValue)
  result = rawValue.cfloat

proc `floatVal=`*(variant: QVariant, value: float) =
  ## Sets the QVariant float value
  dos_qvariant_setFloat(variant.vptr, value.cfloat)

proc doubleVal*(variant: QVariant): cdouble =
  ## Return the QVariant value as double
  var rawValue: cdouble
  dos_qvariant_toDouble(variant.vptr, rawValue)
  result = rawValue

proc `doubleVal=`*(variant: QVariant, value: cdouble) =
  ## Sets the QVariant double value
  dos_qvariant_setDouble(variant.vptr, value)

proc stringVal*(variant: QVariant): string =
  ## Return the QVariant value as string
  var rawCString: cstring
  dos_qvariant_toString(variant.vptr, rawCString)
  result = $rawCString
  dos_chararray_delete(rawCString)

proc `stringVal=`*(variant: QVariant, value: string) =
  ## Sets the QVariant string value
  dos_qvariant_setString(variant.vptr, value)

proc `qobjectVal=`*(variant: QVariant, value: QObject) =
  ## Sets the QVariant qobject value
  dos_qvariant_setQObject(variant.vptr, value.vptr.DosQObject)

proc assign*(leftValue: QVariant, rightValue: QVariant) =
  ## Assign a QVariant with another. The inner value of the QVariant is copied
  dos_qvariant_assign(leftValue.vptr, rightValue.vptr)

proc toQVariantSequence(a: openarray[DosQVariant]): seq[QVariant] =
  ## Convert an array of DosQVariant to a sequence of QVariant
  result = @[]
  for x in a:
    result.add(newQVariant(x))

proc delete(a: openarray[QVariant]) =
  ## Delete an array of QVariants
  for x in a:
    x.delete
