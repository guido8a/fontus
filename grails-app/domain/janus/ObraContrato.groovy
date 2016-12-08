package janus


class ObraContrato {

        Obra obra
        Contrato contrato
        Double valor
        static auditable = true
        static mapping = {
            table 'obcr'
            cache usage: 'read-write', include: 'non-lazy'
            id column: 'obcr__id'
            id generator: 'identity'
            version false
            columns {
                id column: 'obcr__id'
                obra column: 'obra__id'
                contrato column: 'cntr__id'
                valor column: 'obcrvlor'

            }
        }
        static constraints = {


        }
    }

