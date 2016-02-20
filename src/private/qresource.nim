proc registerResource*(c: type QResource, filename: cstring) =
  dos_qresource_register(filename.cstring)
