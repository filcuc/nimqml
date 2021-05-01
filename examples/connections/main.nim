import nimqml


QtObject:
  type Contact* = ref object of QObject
    name: string

  proc delete*(self: Contact) =
    self.QObject.delete

  proc setup(self: Contact) =
    self.QObject.setup

  proc newContact(): Contact =
    new(result, delete)
    result.name = ""
    result.setup

  proc name*(self: Contact): string {.slot.} =
    result = self.name

  proc nameChanged*(self: Contact, firstName: string) {.signal.}

  proc setName*(self: Contact, name: string) {.slot.} =
    if self.name != name:
      self.name = name
      self.nameChanged(name)

  proc `name=`*(self: Contact, name: string) = self.setName(name)

  QtProperty[string] name:
    read = name
    write = setName
    notify = nameChanged


proc main() =
  block: # Raw string connection
    let c1 = newContact()
    let c2 = newContact()
    discard QObject.connect(c1, SIGNAL("nameChanged(QString)"), c2, SLOT("setName(QString)"))
    assert(c1.name != "John" and c2.name != "John")
    c1.setName("John")
    assert(c2.name == "John")
  block: # Signal and slot connection
    let c1 = newContact()
    let c2 = newContact()
    discard QObject.connect(c1, nameChanged, c2, setName)
    assert(c1.name != "John" and c2.name != "John")
    c1.setName("John")
    assert(c2.name == "John")
  block: # Signal and lambda connection
    let c1 = newContact()
    let c2 = newContact()
    proc callback(name: string) =
      c2.setName(name)
    discard QObject.connect(c1, nameChanged, callback)
    assert(c1.name != "John" and c2.name != "John")
    c1.setName("John")
    assert(c2.name == "John")
  block: # Signal and lambda with context
    let c1 = newContact()
    let c2 = newContact()
    proc callback(name: string) =
      c2.setName(name)
    discard QObject.connect(c1, nameChanged, c2, callback)
    assert(c1.name != "John" and c2.name != "John")
    c1.setName("John")
    assert(c2.name == "John")
  block: # Signal and slot disconnection with connection
    let c1 = newContact()
    let c2 = newContact()
    let c = QObject.connect(c1, nameChanged, c2, setName)
    assert(c1.name != "John" and c2.name != "John")
    c1.setName("John")
    assert(c2.name == "John")
    QObject.disconnect(c)
    c1.setName("Doo")
    assert(c2.name == "John")
  block: # Signal and slot disconnection automatic with destruction
    let c1 = newContact()
    block:
      let c2 = newContact()
      defer: c2.delete
      discard QObject.connect(c1, nameChanged, c2, setName)
      assert(c1.name != "John" and c2.name != "John")
      c1.setName("John")
      assert(c2.name == "John")
    c1.setName("Doo")

if isMainModule:
  main()
  GC_fullcollect()
