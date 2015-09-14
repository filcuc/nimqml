import NimQml

QtObject:
  type Contact* = ref object of QObject
    name: string
    surname: string

  proc delete*(self: Contact) =
    let qobject = self.QObject
    qobject.delete

  proc newContact*(): Contact =
    new(result)
    result.name = ""
    result.create

  method firstName*(self: Contact): string {.slot.} =
    result = self.name

  method firstNameChanged*(self: Contact) {.signal.}

  method setFirstName(self: Contact, name: string) {.slot.} =
    if self.name != name:
      self.name = name
      self.firstNameChanged()

  proc `firstName=`*(self: Contact, name: string) = self.setFirstName(name)

  QtProperty[string] firstName:
    read = firstName
    write = setFirstName
    notify = firstNameChanged

  method surname*(self: Contact): string {.slot.} =
    result = self.surname

  method surnameChanged*(self: Contact) {.signal.}

  method setSurname(self: Contact, surname: string) {.slot.} =
    if self.surname != surname:
      self.surname = surname
      self.surnameChanged()

  proc `surname=`*(self: Contact, surname: string) = self.setSurname(surname)

  QtProperty[string] surname:
    read = surname
    write = setSurname
    notify = surnameChanged
