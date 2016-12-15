package janus

import janus.pac.TipoProcedimiento

class VolumenObraController extends janus.seguridad.Shield {
    def buscadorService
    def preciosService
    def dbConnectionService

    def volObra() {

        def grupoFiltrado = Grupo.findAllByCodigoNotIlikeAndCodigoNotIlikeAndCodigoNotIlike('1', '2', '3');
        def subpreFiltrado = []
        def var
        subpreFiltrado = SubPresupuesto.list([sort:"descripcion"])


        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion = Direccion.get(persona?.departamento?.direccion?.id)
//        def grupo = Grupo.findAllByDireccion(direccion)

//        def subPresupuesto1 = SubPresupuesto.findAllByGrupoInList(grupo)
        def subPresupuesto1 = SubPresupuesto.list()

        def obra = Obra.get(params.id)
        def volumenes = VolumenesObra.findAllByObra(obra)

        def duenoObra = 0

        duenoObra = esDuenoObra(obra)? 1 : 0

        def valorMenorCuantia = TipoProcedimiento.findBySigla("MCD").techo
        def valorLicitacion = TipoProcedimiento.findBySigla("LICO").minimo

        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]

        [obra: obra, volumenes: volumenes, campos: campos, subPresupuesto1: subPresupuesto1, grupoFiltrado: grupoFiltrado,
         subpreFiltrado: subpreFiltrado, grupos: grupoFiltrado, persona: persona, vmc: valorMenorCuantia, duenoObra: duenoObra,
        valorLicitacion: valorLicitacion]
    }

    def cargarSubpres() {
//        println("params" + params)
        def grupo = Grupo.get(params.grupo)
//        def subs = SubPresupuesto.findAllByGrupo(grupo,[sort:"descripcion"])
        def subs = SubPresupuesto.list([sort:"descripcion"])
        [subs: subs]
    }

    def cargarAreas() {
//        println("params" + params)
        def cn = dbConnectionService.getConnection()
        def lsta = []
        cn.eachRow("select distinct area__id from vlob where obra__id = ${params.obra} and sbpr__id = ${params.sbpr}".toString()) {d ->
            lsta.add(d.area__id)
        }
        def areas = Area.findAllByIdInList(lsta, [sort:"descripcion"])

        [areas: areas]
    }



    def setMontoObra() {
        def tot = params.monto
        try {
            tot = tot.toDouble()
        } catch (e) {
            tot = 0
        }
//        println " total de la obra:; $tot"
        def obra = Obra.get(params.obra)
        if (obra.valor != tot) {
            obra.valor = tot
            obra.save(flush: true)
        }

        // actualiza el rendimiento de rubros transporte TR%
        /** existe el peligro de que este rubro sea actualizado en otra obra mientras se procesa la obra actual **/
//        preciosService.ac_transporteDesalojo(obra.id)

        render "ok"
    }

    def cargaCombosEditar() {

        def sub = SubPresupuesto.get(params.id)
        def grupo = sub?.grupo
        def subs = SubPresupuesto.findAllByGrupo(grupo,[sort:"descripcion"])
        [subs: subs, sub: sub]
    }


    def buscarRubroCodigo() {
        println "aqui "+params
        def rubro = Item.findByCodigoAndTipoItem(params.codigo?.trim()?.toUpperCase(), TipoItem.get(2))
        if (rubro) {
            render "" + rubro.id + "&&" + rubro.tipoLista?.id + "&&" + rubro.nombre + "&&" + rubro.unidad?.codigo
            return
        } else {
            render "-1"
            return
        }
    }


    def addItem() {
        println "addItem " + params
        def obra = Obra.get(params.obra)
//        def rubro2 = Item.get(params.rubro)
//        def rubro = Item.get(params.id)
        def rubro = Item.findByCodigoIlike(params.cod)
        def sbpr = SubPresupuesto.get(params.sub)
        def volumen
        def msg = ""
//        if (params.vlob_id)
        if (params.id)
            volumen = VolumenesObra.get(params.id)
        else {

            volumen = new VolumenesObra()
//            def v=VolumenesObra.findByItemAndObra(rubro,obra)
            def v = VolumenesObra.findAll("from VolumenesObra where obra=${obra.id} and item=${rubro.id} and subPresupuesto=${sbpr.id}")
//            println "v "+v
            if (v.size() > 0) {
                v = v.pop()
                if (params.override == "1") {
                    v.cantidad += params.cantidad.toDouble()
                    v.save(flush: true)
                    redirect(action: "tabla", params: [obra: obra.id, sub: v.subPresupuesto.id, ord: params.ord])
                    return
                } else {
                    msg = "error"
                    render msg
                    return
                }
            }
        }
//        println "volumn :" + volumen

        volumen.cantidad = params.cantidad.toDouble()
        volumen.orden = params.orden.toInteger()
        volumen.subPresupuesto = SubPresupuesto.get(params.sub)
        volumen.obra = obra
        volumen.item = rubro
        volumen.descripcion = params.dscr
        volumen.area = Area.get(params.area)

        if (!volumen.save(flush: true)) {
            println "error volumen obra " + volumen.errors
            render "error"
        } else {
            preciosService.actualizaOrden(volumen, "insert")
            redirect(action: "tabla", params: [obra: obra.id, sub: volumen.subPresupuesto.id, ord: params.ord, area: params.area])
        }
    }

    def copiarItem() {

//        println "copiarItem "+ params

        def obra = Obra.get(params.obra)
        def rubro = Item.get(params.rubro)
        def sbprDest = SubPresupuesto.get(params.subDest)
        def sbpr = SubPresupuesto.get(params.sub)
        def areaOrigen = Area.get(params.areaOrigen)
        def areaDestino = Area.get(params.areaDestino)
        def obraDestino = Obra.get(params.obraDestino)

        def itemVolumen = VolumenesObra.findByItemAndSubPresupuestoAndArea(rubro, sbpr,areaOrigen)
        def itemVolumenDest = VolumenesObra.findByItemAndSubPresupuestoAndObraAndArea(rubro, sbprDest, obraDestino, areaDestino)

//        println("---> origen " +  itemVolumen)
//        println("---> destino " +  itemVolumenDest)

        def volumen

        def volu = VolumenesObra.list()

        if (params.id)
            volumen = VolumenesObra.get(params.id)
        else {
            if (itemVolumenDest) {
                flash.clase = "alert-error"
                flash.message = "No se puede copiar el rubro " + rubro.nombre
                redirect(action: "tablaCopiarRubro", params: [obra: obra.id, sub: sbpr.id, area: areaOrigen.id, band: 1])
                return
            } else {
//                volumen = VolumenesObra.findByObraAndItemAndSubPresupuesto(obra, rubro, sbprDest)
//                if (volumen == null)
                    volumen = new VolumenesObra()
            }
        }

        if(params.canti){
            volumen.cantidad = params.canti.toDouble()
        }else{
            volumen.cantidad = itemVolumen.cantidad.toDouble()
        }

        volumen.orden = (volu.orden.size().toInteger()) + 1
//        volumen.orden = 100
        volumen.area = areaDestino
        volumen.subPresupuesto = SubPresupuesto.get(params.subDest)
        volumen.obra = obraDestino
        volumen.item = rubro
        if (!volumen.save(flush: true)) {
            flash.clase = "alert-error"
            flash.message = "Error, al copiar los rubros "
            redirect(action: "tablaCopiarRubro", params: [obra: obra.id])
        } else {
            preciosService.actualizaOrden(volumen, "insert")
            flash.clase = "alert-success"
            flash.message = "Copiado rubro " + rubro.nombre
            redirect(action: "tablaCopiarRubro", params: [obra: obra.id, sub: volumen.subPresupuesto.id])
        }

    }


    /** carga tabla de detalle de volúmenes de obra **/
    def tabla() {
//        println "params tabla Vlob--->>>> $params"
        def cn = dbConnectionService.getConnection()
        def subPre = params.sub?.toInteger()
        def areaSel = 0
        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def direccion = Direccion.get(persona?.departamento?.direccion?.id)
        def grupo = Grupo.findAllByDireccion(direccion)
//        def subPresupuesto1 = SubPresupuesto.findAllByGrupoInList(grupo)
        def subPresupuesto1 = SubPresupuesto.list()
        def obra = Obra.get(params.obra)
        def duenoObra = 0
        def valores
        def orden

        if(params.area && params.area != 'null'){
            areaSel = params.area.toInteger()
        }

        if (params.ord == '1') {
            orden = 'asc'
        } else {
            orden = 'desc'
        }

        // actualiza el rendimiento de rubros transporte TR% si la obra no está registrada y herr. menor
        if(obra.estado != 'R') {
            println "actualiza desalojo y herramienta menor"
//            preciosService.ac_transporteDesalojo(obra.id)
            preciosService.ac_rbroObra(obra.id)
        }

        if (subPre && subPre != "-1" ) {
            valores = preciosService.rbro_pcun_v5(obra.id, subPre, areaSel, orden)
        }
        if(subPre == 0) {
            valores = preciosService.rbro_pcun_v4(obra.id, orden)
        }

//        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        def lsta = []
        cn.eachRow("select distinct sbpr__id from vlob where obra__id = ${obra.id}".toString()) {d ->
            lsta.add(d.sbpr__id)
        }
        def subPres = SubPresupuesto.findAllByIdInList(lsta)

        def estado = obra.estado

        duenoObra = esDuenoObra(obra)? 1 : 0

        def todosSub = SubPresupuesto.get(0)
//        subPres.add(todosSub)
        subPres += todosSub

//        println "..........1"

        def areas = []
        if(subPre > 0) {
            lsta = []
            cn.eachRow("select distinct area__id from vlob where obra__id = ${obra.id} and sbpr__id = ${subPre}".toString()) {d ->
                lsta.add(d.area__id)
            }
            areas = Area.findAllByIdInList(lsta, [sort:"descripcion"])
        }


//        println "subPres: $subPres"
        cn.close()

        [subPres: subPres, subPre: subPre, obra: obra, valores: valores, areaSel: areaSel, areas: areas,
         subPresupuesto1: subPresupuesto1, estado: estado, msg: params.msg, persona: persona, duenoObra: duenoObra]
    }

    def esDuenoObra(obra) {
//
        def dueno = false
        def funcionElab = Funcion.findByCodigo('E')
        def personasUtfpu = PersonaRol.findAllByFuncionAndPersonaInList(funcionElab, Persona.findAllByDepartamento(Departamento.findByCodigo('DNCP')))
        def responsableRol = PersonaRol.findByPersonaAndFuncion(obra?.responsableObra, funcionElab)

        if (responsableRol) {
            if (obra?.responsableObra?.departamento?.direccion?.id == Persona.get(session.usuario.id).departamento?.direccion?.id) {
                dueno = true
            } else {
                dueno = personasUtfpu.contains(responsableRol) && session.usuario.departamento.codigo == 'DNCP'
            }
        }
        dueno
    }


    def eliminarRubro() {
        println "elm rubro " + params
        def vol = VolumenesObra.get(params.id)
        def obra = vol.obra
        def orden = vol.orden
        def msg = "ok"
        def cronos = Cronograma.findAllByVolumenObra(vol)
        cronos.each { c ->
            if (c.porcentaje == 0) {
                c.delete(flush: true)
            } else {
                msg = "Error no se puede borrar el rubro porque esta presente en el cronograma con un valor diferente de cero."
            }
        }

        try {
            if (msg == "ok") {
                preciosService.actualizaOrden(vol, "delete")
                vol.delete(flush: true)
            }

        } catch (e) {
            println "e " + e
            msg = "Error"
        }
        redirect(action: "tabla", params: [obra: obra.id, sub: vol.subPresupuesto.id, ord: 1, msg: msg])


    }

    def copiarRubros() {

        def obra = Obra.get(params.obra)
        def volumenes = VolumenesObra.findAllByObra(obra)
        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        return [obra: obra, volumenes: volumenes, subPres: subPres]

    }

    def tablaCopiarRubro() {

        println("tabla " + params)

        def usuario = session.usuario.id
        def persona = Persona.get(usuario)
        def obra = Obra.get(params.obra)
        def valores
        def subpre = params.sub.toInteger()
        def area

        if(params.area && params.area != '-1'){
            area = params.area.toInteger()
        }

        if(subpre && subpre != '-1'){
          valores = preciosService.rbro_pcun_v5(obra.id, subpre, area, "asc")
        }

        def subPres = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()

        def precios = [:]
        def fecha = obra.fechaPreciosRubros
        def dsps = obra.distanciaPeso
        def dsvl = obra.distanciaVolumen
        def lugar = obra.lugar
        def prch = 0
        def prvl = 0
        def indirecto = obra.totales / 100

        preciosService.ac_rbroObra(obra.id)

        [precios: precios, subPres: subPres, subPre: params.sub, obra: obra, precioVol: prch, precioChof: prvl, indirectos: indirecto * 100, valores: valores]
    }


    def buscaRubro() {

        def listaTitulos = ["Código", "Descripción", "Unidad"]
        def listaCampos = ["codigo", "nombre", "unidad"]
        def funciones = [null, null]
        def url = g.createLink(action: "buscaRubro", controller: "rubro")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-rubro").modal("hide");'
//        funcionJs += '$("#item_id").val($(this).attr("regId"));$("#item_codigo").val($(this).attr("prop_codigo"));$("#item_nombre").val($(this).attr("prop_nombre"))'
        funcionJs += '$("#item_id").val($(this).attr("regId"));$("#item_codigo").val($(this).attr("prop_codigo"));$("#item_nombre").val($(this).attr("prop_nombre"));$("#item_unidad").val($(this).attr("prop_unidad"))'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and tipoItem = 2 and codigo not like 'H%'"  // no lista los que inician con H
//        def extras = " and tipoItem = 2"  // no lista los que inician con H
        if (!params.reporte) {
            def lista = buscadorService.buscar(Item, "Item", "excluyente", params, true, extras) /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Item
            session.funciones = funciones
            def anchos = [20, 80] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Item", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Rubros", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def origen_ajax () {
        def obra = Obra.get(params.obra)
        def origen = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        return [origen: origen, obra: obra]
    }

    def cargarAreaOrigen_ajax () {
        def cn = dbConnectionService.getConnection()
        def lsta = []
        if(params.obra){
            cn.eachRow("select distinct area__id from vlob where obra__id = ${params.obra} and sbpr__id = ${params.sbpr}".toString()) {d ->
                lsta.add(d.area__id)
            }
        }

        def areas = Area.findAllByIdInList(lsta, [sort:"descripcion"])
        return [areas: areas]
    }

    def cargarSubDestino_ajax () {
        def obra = Obra.get(params.obra)
        def destino = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
        return [destino: destino, obra: obra]
    }


    def cargarAreaDestino_ajax () {
        def cn = dbConnectionService.getConnection()
        def lsta = []
        if(params.obra){
            cn.eachRow("select distinct area__id from vlob where obra__id = ${params.obra} and sbpr__id = ${params.sbpr}".toString()) {d ->
                lsta.add(d.area__id)
            }
        }

        def areas = Area.findAllByIdInList(lsta, [sort:"descripcion"])
        return [areas: areas]
    }

    def volObraContrato() {

        def contrato = Contrato.get(params.id)
        def obrasContrato = ObraContrato.findAllByContrato(contrato)
        def vocr = VolumenContrato.findAllByObraContratoInList(obrasContrato)

        def subpresupuestos = vocr.subPresupuesto.unique()

        def campos = ["codigo": ["Código", "string"], "nombre": ["Descripción", "string"]]

        return [contrato: contrato, subPres: subpresupuestos, campos: campos]
    }

    def tablaRubrosContrato_ajax() {

        def contrato = Contrato.get(params.contrato)
        def subpresupuesto = SubPresupuesto.get(params.sub)
        def obrasContrato = ObraContrato.findAllByContrato(contrato)
        def volumenes = VolumenContrato.findAllByObraContratoInListAndSubPresupuesto(obrasContrato, subpresupuesto)

        return[valores: volumenes]
    }

    def borrarRubroContrato_ajax () {
        def volumen = VolumenContrato.get(params.id)
        if(volumen.delete(flush: true)){
            render "no"
        }else{
            render "ok"
        }
    }

    def agregarItemContrato_ajax () {
        println("--> " + params)
    }
}
