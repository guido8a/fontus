package janus

class CronogramaContrato {


    VolumenContrato volumenContrato
    ObraContrato obraContrato
    int cronogramaPeriodo
    Double cronogramaCantidad
    Double cronogramaPorcentaje
    Double cronogramaPrecio

    static auditable = true
    static mapping = {
        table 'crng'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'crng__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'crng__id'
            volumenContrato column: 'vocr__id'
            obraContrato column: 'obcr__id'
            cronogramaPeriodo column: 'crngprdo'
            cronogramaCantidad column: 'crngcntd'
            cronogramaPorcentaje column: 'crngprct'
            cronogramaPrecio column: 'crngprco'

        }
    }

    static constraints = {
    }
}
