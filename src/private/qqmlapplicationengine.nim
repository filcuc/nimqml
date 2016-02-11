proc setup*(self: QQmlApplicationEngine) =
  ## Setup a QQmlApplicationEngine
  dos_qqmlapplicationengine_create(self.vptr)

proc loadData*(self:QQmlApplicationEngine, data: string) =
  ## Load the given data
  dos_qqmlapplicationengine_load_data(self.vptr, data.cstring)

proc load*(self: QQmlApplicationEngine, filename: string) =
  ## Load the given Qml file
  dos_qqmlapplicationengine_load(self.vptr, filename.cstring)

proc addImportPath*(self: QQmlApplicationEngine, path: string) =
  ## Add an import path
  dos_qqmlapplicationengine_add_import_path(self.vptr, path.cstring)

proc setRootContextProperty*(self: QQmlApplicationEngine, name: string, value: QVariant) =
  ## Set a root context property
  var context: DosQQmlContext
  dos_qqmlapplicationengine_context(self.vptr, context)
  dos_qqmlcontext_setcontextproperty(context, name.cstring, value.vptr)

proc delete*(self: QQmlApplicationEngine) =
  ## Delete the given QQmlApplicationEngine
  debugMsg("QQmlApplicationEngine", "delete")
  if self.vptr.isNil:
    return
  dos_qqmlapplicationengine_delete(self.vptr)
  self.vptr.resetToNil

proc newQQmlApplicationEngine*(): QQmlApplicationEngine =
  ## Return a new QQmlApplicationEngine
  new(result, delete)
  result.setup()
