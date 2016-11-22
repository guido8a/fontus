package janus

class Area implements Serializable {
    String descripcion
    static auditable = true
    static mapping = {
        table 'area'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'area__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'area__id'
            descripcion column: 'areadscr'
        }
    }
    static constraints = {
        descripcion(blank: false, nullable: false, attributes: [title: 'Area del subpresupuesto'])
    }
}