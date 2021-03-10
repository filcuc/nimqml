proc setup*(application: QApplication) =
  ## Setup a new QApplication
  dos_qapplication_create()
  application.deleted = false

proc exec*(application: QApplication) =
  ## Start the Qt event loop
  dos_qapplication_exec()

proc quit*(application: QApplication) =
  ## Quit the Qt event loop
  dos_qapplication_quit()

proc quit*(typ: type QApplication): string =
  var str = dos_slot_macro("quit()")
  result = $str
  dos_chararray_delete(str)

proc delete*(application: QApplication) =
  ## Delete the given QApplication
  if application.deleted:
    return
  debugMsg("QApplication", "delete")
  dos_qapplication_delete()
  application.deleted = true

proc new*(c: type QApplication): QApplication =
  ## Return a new QApplicationp
  new(result, delete)
  result.setup()

proc newQApplication*(): QApplication {.deprecated: "use QApplication.new".} =
  ## Return a new QApplication
  QApplication.new
