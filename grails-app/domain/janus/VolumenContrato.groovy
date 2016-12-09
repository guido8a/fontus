package janus

class VolumenContrato {

    ObraContrato obraContrato
    SubPresupuesto subPresupuesto
    Item item
    Double volumenCantidad
    int volumenOrden
    Double volumenPrecio
    Double volumenSubtotal
    String volumenRuta

    static auditable = true
    static mapping = {
        table 'vocr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'vocr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'vocr__id'
            obraContrato column: 'obcr__id'
            subPresupuesto column: 'sbpr__id'
            item column: 'item__id'
            volumenCantidad column: 'vocrcntd'
            volumenOrden column: 'vocrordn'
            volumenPrecio column: 'vocrpcun'
            volumenSubtotal column: 'vocrsbtt'
            volumenRuta column: 'vocrrtcr'
        }
    }

    static constraints = {
    }
}
