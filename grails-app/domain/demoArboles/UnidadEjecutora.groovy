package demoArboles

class UnidadEjecutora {
    TipoInstitucion tipoInstitucion
    String codigo
    UnidadEjecutora padre
    String nombre

    static auditable = [ignore: []]

    static mapping = {
        table 'unej'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'unej__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'unej__id'
            tipoInstitucion column: 'tpin__id'
            codigo column: 'unejcdgo'
            padre column: 'unejpdre'
            nombre column: 'unejnmbr'
        }
    }

    static constraints = {
        tipoInstitucion(blank: false, nullable: false, attributes: [mensaje: 'Tipo de institución'])
        codigo(maxSize: 6, blank: true, nullable: true, attributes: [mensaje: 'Código interno en la Institución'])
        padre(blank: true, nullable: true, attributes: [mensaje: 'Unidad Ejecutora padre'])
        nombre(size: 1..127, blank: false, attributes: [mensaje: 'Nombre de la entidad o ministerio'])
    }

    String toString() {
        return this.nombre
    }

    String getLabelArbol() {
        return this.nombre + (this.codigo ? " (" + this.codigo + ")" : "")
    }
}