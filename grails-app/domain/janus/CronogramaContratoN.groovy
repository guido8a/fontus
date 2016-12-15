package janus

class CronogramaContratoN {


    VolumenContrato volumenContrato
    ObraContrato obraContrato
    int cronogramaPeriodo
    Double cronogramaCantidad
    Double cronogramaPorcentaje
    Double cronogramaPrecio

    static auditable = true
    static mapping = {
        table 'crct'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'crct__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'crct__id'
            volumenContrato column: 'vocr__id'
            obraContrato column: 'obcr__id'
            cronogramaPeriodo column: 'crctprdo'
            cronogramaCantidad column: 'crctcntd'
            cronogramaPorcentaje column: 'crctprct'
            cronogramaPrecio column: 'crctprco'

        }
    }

    static constraints = {
    }
}
