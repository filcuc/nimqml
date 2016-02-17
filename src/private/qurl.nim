proc setup*(self: QUrl, url: string, mode: QUrlParsingMode) =
  ## Setup a new QUrl
  dos_qurl_create(self.vptr, url.cstring, mode.cint)

proc delete(self: QUrl) =
  ## Delete a QUrl
  if self.vptr.isNil:
    return
  debugMsg("QUrl", "delete")
  dos_qurl_delete(self.vptr)
  self.vptr.resetToNil

proc newQUrl(url: string, mode: QUrlParsingMode = QUrlParsingMode.Tolerant): QUrl =
  ## Create a new QUrl
  new(result, delete)
  result.setup(url, mode)

proc toString(self: QUrl): string =
  ## Return the url string
  var str: cstring
  dos_qurl_to_string(self.vptr, str)
  result = $str
  dos_chararray_delete(str)
