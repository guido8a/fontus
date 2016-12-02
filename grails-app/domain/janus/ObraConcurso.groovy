package janus

import janus.pac.Concurso


class ObraConcurso {

    Obra obra
    Concurso concurso
    Double valor
    static auditable = true
    static mapping = {
        table 'obcn'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'obcn__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'obcn__id'
            obra column: 'obra__id'
            concurso column: 'cncr__id'
            valor column: 'obcnvlor'

        }
    }
    static constraints = {


    }
}
