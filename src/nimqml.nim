import locks
import tables

## NimQml aims to provide binding to the QML for the Nim programming language

template debugMsg(message: string) =
  echo "NimQml: ", message

template debugMsg(typeName: string, procName: string) =
  when defined(debug):
    debugMsg(typeName & ": " & procName)

include "nimqml/private/nimqmlmacros.nim"
include "nimqml/private/dotherside.nim"
include "nimqml/private/nimqmltypes.nim"
include "nimqml/private/constructors.nim"
include "nimqml/private/qvariant.nim"
include "nimqml/private/lambdainvoker.nim"
include "nimqml/private/qmetaobjectconnection.nim"
include "nimqml/private/qmetaobject.nim"
include "nimqml/private/qobject.nim"
include "nimqml/private/qqmlapplicationengine.nim"
include "nimqml/private/qcoreapplication.nim"
include "nimqml/private/qguiapplication.nim"
include "nimqml/private/qapplication.nim"
include "nimqml/private/qurl.nim"
include "nimqml/private/qquickview.nim"
include "nimqml/private/qhashintbytearray.nim"
include "nimqml/private/qmodelindex.nim"
include "nimqml/private/qabstractitemmodel.nim"
include "nimqml/private/qabstractlistmodel.nim"
include "nimqml/private/qabstracttablemodel.nim"
include "nimqml/private/qresource.nim"
include "nimqml/private/qdeclarative.nim"

