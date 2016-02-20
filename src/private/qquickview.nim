proc setup*(self: QQuickView) =
  ## Setup a new QQuickView
  dos_qquickview_create(self.vptr)

proc delete*(self: QQuickView) =
  ## Delete the given QQuickView
  if self.vptr.isNil:
    return
  debugMsg("QQuickView", "delete")
  dos_qquickview_delete(self.vptr)
  self.vptr.resetToNil

proc newQQuickView*(): QQuickView =
  ## Return a new QQuickView
  new(result, delete)
  result.setup()

proc source*(self: QQuickView): cstring =
  ## Return the source Qml file loaded by the view
  var length: int
  dos_qquickview_source(self.vptr, result, length)

proc `source=`*(self: QQuickView, filename: cstring) =
  ## Sets the source Qml file laoded by the view
  dos_qquickview_set_source(self.vptr, filename)

proc show*(self: QQuickView) =
  ## Sets the view visible
  dos_qquickview_show(self.vptr)
