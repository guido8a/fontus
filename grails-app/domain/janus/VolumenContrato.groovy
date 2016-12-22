package janus

class VolumenContrato {

    ObraContrato obraContrato
    SubPresupuesto subPresupuesto
    Area   area
    Item item
    double volumenCantidad
    int volumenOrden
    double volumenPrecio
    double volumenSubtotal
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
            area column: 'area__id'
        }
    }

    static constraints = {
        obraContrato(blank: false, attributes: [title: 'obra'])
        item(blank: false, attributes: [title: 'item'])
        volumenCantidad(blank: false, attributes: [title: 'cantidad'])
        subPresupuesto(blank: false, attributes: [title: 'subPresupuesto'])
        volumenRuta(blank: true, nullable: true, maxSize: 1, inList: ['S', 'N'], attributes: [title: 'ruta critica'])
        area(blank: false, nullable: false )
    }
}
