proc applicationDirPath*(app: QCoreApplication): string =
  var str: cstring = nil
  dos_qcoreapplication_application_dir_path(str)
  result = $str
  dos_chararray_delete(str)
