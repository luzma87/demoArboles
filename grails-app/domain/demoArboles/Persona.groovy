package demoArboles

class Persona {
    String nombre
    String apellido
    UnidadEjecutora unidad
    String login
    String password
    int estaActivo
    String cargo

    static auditable = [ignore: []]

    static mapping = {
        table 'prsn'
        sort 'apellido'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prsn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prsn__id'
            nombre column: 'prsnnmbr'
            apellido column: 'prsnapll'
            login column: 'prsnlogn'
            password column: 'prsnpass'
            estaActivo column: 'prsnactv'
            unidad column: 'unej__id'
            cargo column: 'prsncrgo'
        }
    }

    static constraints = {
        nombre(matches: /^[a-zA-ZñÑ áéíóúÁÉÍÚÓüÜ-]+$/, size: 1..40, blank: false, attributes: ['mensaje': 'Nombre de la persona'])
        apellido(matches: /^[a-zA-ZñÑ áéíóúÁÉÍÚÓüÜ-]+$/, size: 1..40, blank: false, attributes: ['mensaje': 'Apellido de la persona'])
        login(matches: /^[a-zA-Z0-9_-]{1,15}$/, size: 1..15, blank: true, nullable: true, unique: true, attributes: [mensaje: 'Nombre de usuario'])
        password(matches: /^[a-zA-Z0-9ñÑáéíóúÁÉÍÚÓüÜ_-]+$/, size: 1..64, password: true, blank: true, nullable: true, attributes: [mensaje: 'Contraseña para el ingreso al sistema'])
        estaActivo(inList: [1, 0], size: 1..1, blank: true, nullable: true, attributes: [mensaje: 'Usuario activo o no'])
        unidad(blank: true, nullable: true, attributes: [mensaje: 'Unidad Ejecutora a la que pertenece el usuario'])
        cargo(blank: true, nullable: true, size: 1..255, attributes: [mensaje: 'Cargo'])
    }

    String toString() {
        return "${this.nombre} ${this.apellido}"
    }

    boolean getEsJefe() {
        if (this.cargo) {
            return this.cargo.toLowerCase().contains('jefe')
        }
        return false
    }

    boolean getEsDirector() {
        if (this.cargo) {
            return this.cargo.toLowerCase().contains('director')
        }
        return false
    }

    String getLabelArbol() {
        return this.nombre + (this.login ? " (" + this.login + ")" : "")
    }
}