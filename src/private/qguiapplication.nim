# QGuiApplication
proc dos_qguiapplication_create() {.cdecl, importc.}
proc dos_qguiapplication_exec() {.cdecl, importc.}
proc dos_qguiapplication_quit() {.cdecl, importc.}
proc dos_qguiapplication_delete() {.cdecl, importc.}

proc create*(application: QGuiApplication) =
  ## Create a new QApplication
  dos_qguiapplication_create()
  application.deleted = false

proc exec*(application: QGuiApplication) =
  ## Start the Qt event loop
  dos_qguiapplication_exec()

proc quit*(application: QGuiApplication) =
  ## Quit the Qt event loop
  dos_qguiapplication_quit()

proc delete*(application: QGuiApplication) =
  ## Delete the given QApplication
  if not application.deleted:
    debugMsg("QApplication", "delete")
    dos_qguiapplication_delete()
    application.deleted = true

proc newQGuiApplication*(): QGuiApplication =
  ## Return a new QApplication
  new(result, delete)
  result.create()
