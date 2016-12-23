package janus

import org.springframework.dao.DataIntegrityViolationException

class CronogramaContratoNController extends janus.seguridad.Shield {

    def dbConnectionService
    def preciosService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [cronogramaContratoNInstanceList: CronogramaContratoN.list(params), params: params]
    } //list

    def form_ajax() {
        def cronogramaContratoNInstance = new CronogramaContratoN(params)
        if(params.id) {
            cronogramaContratoNInstance = CronogramaContratoN.get(params.id)
            if(!cronogramaContratoNInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Cronograma Contrato N con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [cronogramaContratoNInstance: cronogramaContratoNInstance]
    } //form_ajax

    def save() {
        def cronogramaContratoNInstance
        if(params.id) {
            cronogramaContratoNInstance = CronogramaContratoN.get(params.id)
            if(!cronogramaContratoNInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Cronograma Contrato N con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            cronogramaContratoNInstance.properties = params
        }//es edit
        else {
            cronogramaContratoNInstance = new CronogramaContratoN(params)
        } //es create
        if (!cronogramaContratoNInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Cronograma Contrato N " + (cronogramaContratoNInstance.id ? cronogramaContratoNInstance.id : "") + "</h4>"

            str += "<ul>"
            cronogramaContratoNInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'list')
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Cronograma Contrato N " + cronogramaContratoNInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Cronograma Contrato N " + cronogramaContratoNInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def cronogramaContratoNInstance = CronogramaContratoN.get(params.id)
        if (!cronogramaContratoNInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Cronograma Contrato N con id " + params.id
            redirect(action: "list")
            return
        }
        [cronogramaContratoNInstance: cronogramaContratoNInstance]
    } //show

    def delete() {
        def cronogramaContratoNInstance = CronogramaContratoN.get(params.id)
        if (!cronogramaContratoNInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Cronograma Contrato N con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            cronogramaContratoNInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message =  "Se ha eliminado correctamente Cronograma Contrato N " + cronogramaContratoNInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message =  "No se pudo eliminar Cronograma Contrato N " + (cronogramaContratoNInstance.id ? cronogramaContratoNInstance.id : "")
            redirect(action: "list")
        }
    } //delete



    def cronogramaContrato () {
        println("params crono " + params)

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def obra = ObraContrato.get(params.id)
//        def subpres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def subpres = VolumenContrato.findAllByObraContrato(obra).subPresupuesto.unique()
        def persona = Persona.get(session.usuario.id)
//        def duenoObra = esDuenoObra(obra) ? 1 : 0
        def duenoObra = ''

        def subpre = params.subpre
        if (!subpre) {
            subpre = subpres[0].id
        }

        def areaSel = 0

        if(params.area && params.area != 'null'){
            areaSel = params.area.toInteger()
        }


        def detalle

        if (subpre != "-1")  {
            if(params.area){
//                detalle = VolumenesObra.findAllByObraAndSubPresupuestoAndArea(obra, SubPresupuesto.get(subpre),Area.get(params.area), [sort: "orden"])
                detalle = VolumenContrato.findAllByObraContratoAndSubPresupuestoAndArea(obra, SubPresupuesto.get(subpre),Area.get(params.area))
            }else{
                detalle = VolumenContrato.findAllByObraContratoAndSubPresupuesto(obra, SubPresupuesto.get(subpre))
            }

        } else {
            detalle =  VolumenContrato.findAllByObraContrato(obra)
        }

        def valores
//        if (subpre == '-1'){
//            preciosVlob = preciosService.rbro_pcun_v2(obra?.id)
//        }else {
//            preciosVlob = preciosService.rbro_pcun_v3(obra?.id, subpre)
//        }

        if (subpre && subpre != "-1" ) {
            valores = preciosService.rbro_pcun_cntr(obra.id, subpre, areaSel, "asc")
        }

        if(subpre == "-1") {
            valores = preciosService.rbro_pcun_cntr(obra.id, 0, 0, "asc")
        }

//        println("valores " + valores)

        def areas = []
        def lsta = []

        if(subpre != '-1') {
            cn.eachRow("select distinct area__id from vocr where obcr__id = ${obra.id} and sbpr__id = ${subpre}".toString()) {d ->
                lsta.add(d.area__id)
            }
            areas = Area.findAllByIdInList(lsta, [sort:"descripcion"])
        }
        cn.close()

        def precios = [:]
        def pcun = [:]

        preciosService.ac_rbroObra(obra.id)

        detalle.each { dt ->
            precios.put(dt.id.toString(), valores.find { it.vlob__id == dt.id}?.totl)
            pcun.put(dt.id.toString(), valores.find { it.vlob__id == dt.id}?.pcun)
        }

//
//        println("precios " + precios)
//        println("pcun " + pcun)


//        def tieneMatriz = false
//        cn.eachRow("select count(*) cuenta from mfrb where obra__id = ${obra.id}".toString()) { d ->
//            tieneMatriz = d.cuenta > 0
//        }
//        cn.close()

        def paraPlazo = detalle

        if(!params.subpre && !params.area){
            detalle = ''
        }

        def meses = Math.ceil((obra.contrato.plazo)/30)
//        println("meses " + meses)

        return [detalle: detalle, precios: precios, pcun: pcun, obra: obra, subpres: subpres, subpre: subpre,
                persona: persona, duenoObra: duenoObra, areas: areas, paraPlazo: paraPlazo, meses: meses]
    }


    def cargarAreasContrato_ajax () {
        def cn = dbConnectionService.getConnection()
        def lsta = []
        def areas

            cn.eachRow("select distinct area__id from vocr where obcr__id = ${params.obra} and sbpr__id = ${params.sbpr}".toString()) {d ->
                lsta.add(d.area__id)
            }
            areas = Area.findAllByIdInList(lsta, [sort:"descripcion"])
        cn.close()

        [areas:areas]
    }
} //fin controller
