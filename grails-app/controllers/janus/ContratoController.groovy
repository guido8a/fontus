package janus

import janus.ejecucion.FormulaPolinomicaContractual
import janus.ejecucion.FormulaPolinomicaReajuste
import janus.ejecucion.FormulaSubpresupuesto
import janus.ejecucion.PeriodosInec
import janus.ejecucion.Planilla
import janus.ejecucion.TipoFormulaPolinomica
import janus.ejecucion.TipoPlanilla
import janus.pac.Concurso
import janus.pac.CronogramaContrato
import janus.pac.DocumentoProceso
import janus.pac.Oferta
import janus.pac.PeriodoValidez
import org.springframework.dao.DataIntegrityViolationException


class ContratoController extends janus.seguridad.Shield {

    def buscadorService
    def preciosService
    def dbConnectionService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "registroContrato", params: params)
    } //index

    def list() {
        [contratoInstanceList: Contrato.list(params), params: params]
    } //list

    def fechasPedidoRecepcion() {
        println("params f" + params)
        def contrato = Contrato.get(params.id)
        return [contrato: contrato]
    }

    def saveFechas() {
        def contrato = Contrato.get(params.id)
        contrato.fechaPedidoRecepcionContratista = new Date().parse("dd-MM-yyyy", params.fechaPedidoRecepcionContratista)
        contrato.fechaPedidoRecepcionFiscalizador = new Date().parse("dd-MM-yyyy", params.fechaPedidoRecepcionFiscalizador)
        contrato.obra.fechaFin = contrato.fechaPedidoRecepcionFiscalizador

        def liquidacion = Planilla.findByContratoAndTipoPlanilla(contrato, TipoPlanilla.findByCodigo('Q'))
        if(liquidacion){
            liquidacion?.fechaFin = contrato.fechaPedidoRecepcionFiscalizador
            liquidacion.save(flush: true)
        }

        contrato.obra.save(flush: true)
        if (!contrato.save(flush: true)) {
            println "Error al guardar fechas de pedido de recepcion (contrato controller l.33): " + contrato.errors
            flash.clase = "alert-error"
            flash.message = "Ha ocurrido un error al guardar las fechas de pedido de repción: "
            flash.message += g.renderErrors(bean: contrato)
        } else {
            flash.clase = "alert-success"
            flash.message = "Fechas de pedido de recepción guardadas correctamente"
        }
        redirect(action: "fechasPedidoRecepcion", id: contrato.id)
    }

    def verContrato() {
        def contrato
//        println "params de verContrato: $params"
        if (params.contrato) {
            contrato = Contrato.get(params.contrato)
//            println "ANT " + contrato

            if(contrato){
                if (!contrato?.anticipo) {
//                println "...no tiene anticipo....."
                    if (contrato.monto && contrato.porcentajeAnticipo) {
//                    println "\ttiene monto y porcentaje de anticipo....calcula el monto del anticipo...."
                        def anticipo = contrato.monto * (contrato.porcentajeAnticipo / 100)
                        contrato.anticipo = anticipo
                        contrato.save(flush: true)
                    } else {
                        println "\tno tiene monto o porcentaje de anticipo...no puedo calcular el monto del anticipo...."
                    }
                }

                /* sólo si el usaurio es un Directos puede acceder al os botones de Adminsitrador, Fiscalizador y Delegado */
//            def obra = contrato.oferta.concurso.obra
                def obra = contrato.obra
//            println ".........." + obra
                /** direccion administradora del contrato **/
                def dptoDireccion = Departamento.findAllByDireccion(contrato.depAdministrador.direccion)
//            println "departamentos... a listar:" + dptoDireccion
                def personalDireccion = Persona.findAllByDepartamentoInList(dptoDireccion)
                def directores = PersonaRol.findAllByFuncionAndPersonaInList(Funcion.findByCodigo("D"), personalDireccion).persona.id
//            println "directores:" + directores + "  usurio: $session.usuario id:" + session.usuario.id
                def esDirector = directores.contains(session.usuario.id) ? "S" : "N"
//            println "esDirector: $esDirector directores: $directores"


                def personalFis = Persona.findAllByDepartamento(Departamento.findByCodigo('FISC'))
                def directoresFis = PersonaRol.findAllByFuncionAndPersonaInList(Funcion.findByCodigo("D"), personalFis).persona.id
                def esDirFis = directoresFis.contains(session.usuario.id) ? "S" : "N"

                def campos = ["codigo": ["Contrato No.", "string"], "nombre": ["Nombre", "string"], "prov": ["Contratista", "string"]]

                [campos: campos, contrato: contrato, esDirector: esDirector, esDirFis: esDirFis]
            }else{
                def campos = ["codigo": ["Contrato No.", "string"], "nombre": ["Nombre", "string"], "prov": ["Contratista", "string"]]
                [campos: campos]
            }


        } else {
            def campos = ["codigo": ["Contrato No.", "string"], "nombre": ["Nombre", "string"], "prov": ["Contratista", "string"]]
            [campos: campos]
        }
    }

    def delegadoPrefecto() {
        def contrato = Contrato.get(params.id)
        return [contrato: contrato]
    }

    def delegadoFiscalizacion() {
        def contrato = Contrato.get(params.id)
        return [contrato: contrato]
    }

    def saveDelegado() {
        println "AQUI: "+params
        def contrato = Contrato.get(params.id)
        def delegado = Persona.get(params.pref)

        contrato.delegadoPrefecto = delegado
        if (!contrato.save(flush: true)) {
            render "NO_" + contrato.errors
        } else {
            render "OK"
        }
    }

    def saveDelegadoFisc() {
        def contrato = Contrato.get(params.id)
        def delegado = Persona.get(params.pref)

        contrato.delegadoFiscalizacion = delegado
        if (!contrato.save(flush: true)) {
            render "NO_" + contrato.errors
        } else {
            render "OK"
        }
    }

//    def saveRegistrar() {
//        def contrato = Contrato.get(params.id)
//        def obra = contrato.obra
//
//        def errores = ""
//
//        //tiene q tener cronograma y formula polinomica
//        def detalle = VolumenesObra.findAllByObra(obra, [sort: "orden"])
//        def cronos = CronogramaContratoN.findAllByVolumenObraInList(detalle)
////        println "suma de la obra: ${cronos.precio.sum()}, valor de la obra: ${contrato.monto}"
//        if (cronos.precio.sum().round(2) != contrato.monto.round(2)) {
//            errores += "<li>No cuadra los totales del cronograma ${cronos.precio.sum()} con el valor del contrato: ${contrato.monto}</li>"
//        }
//        def pcs = FormulaPolinomicaContractual.withCriteria {
//            and {
//                eq("contrato", contrato)
//                or {
//                    ilike("numero", "c%")
//                    and {
//                        ne("numero", "P0")
//                        ne("numero", "p01")
//                        ilike("numero", "p%")
//                    }
//                }
//                order("numero", "asc")
//            }
//        }
//        if (cronos.size() == 0 || pcs.size() == 0) {
//            if (cronos.size() == 0) {
//                errores += "<li>No ha generado el cronograma de contrato.</li>"
//            }
//            if (pcs.size() == 0) {
//                errores += "<li>No ha generado la fórmula polinómica contractual.</li>"
//            }
//        }
//        def crono = 0
//        detalle.each {
//            def tmp = CronogramaContratoN.findAllByVolumenObra(it)
//            tmp.each { tm ->
//                crono += tm.porcentaje
////                crono += tm.precio
//            }
////            println "crono: $crono"
//            if (!((crono.toDouble().round(2) <= 100.01) || (crono.toDouble().round(2) >= 99.99))) {
//                errores += "<li>La suma de porcentajes del volumen de obra: ${it.item.codigo} (${crono.toDouble().round(2)}) en el cronograma contractual es diferente de 100%</li>"
//            }
//            crono = 0
//        }
//        def fps = FormulaPolinomicaContractual.findAllByContrato(contrato)
////        println "fps "+fps
//        def totalP = 0
//        fps.each { fp ->
//            if (fp.numero =~ "p") {
////                println "sumo "+fp.numero+"  "+fp.valor
//                totalP += fp.valor
//            }
//        }
//
//        def totalC = 0
//        fps.each { fp ->
//            if (fp.numero =~ "c") {
////                println "sumo "+fp.numero+"  "+fp.valor
//                totalC += fp.valor
//            }
//        }
////        println "totp "+totalP
//        if (totalP.toDouble().round(6) != 1.000) {
//            errores += "<li>La suma de los coeficientes de la formula polinómica (${totalP}) es diferente a 1.000</li>"
//        }
//        if (totalC.toDouble().round(6) != 1.000) {
//            errores += "<li>La suma de los coeficientes de la Cuadrilla tipo (${totalC}) es diferente a 1.000</li>"
//        }
//
//        //tiene q tener al menos 2 documentos: plano y justificativo de cantidad de obra
//        def concurso = Concurso.findByObra(obra)
//        def documentosContrato = DocumentoProceso.findAllByConcurso(concurso)
//
//        def planoContrato = documentosContrato.findAll { it.nombre.toLowerCase().contains("plano") }
//        def justificativoContrato = documentosContrato.findAll { it.nombre.toLowerCase().contains("justificativo") }
//        println "documentos: ${documentosContrato} planos: ${planoContrato}, justificativo: ${justificativoContrato}"
//
//        if (planoContrato.size() == 0) {
//            errores += "<li>Debe cargar un documento a la biblioteca con nombre 'Plano'</li>"
//        }
//        if (justificativoContrato.size() == 0) {
//            errores += "<li>Debe cargar un documento a la biblioteca con nombre 'Justificativo de cantidad de obra'</li>"
//        }
//
//        if (errores == "") { //registra el contrato
//            contrato.estado = "R"
//            if (contrato.save(flush: true)) {
//                render "ok"
//            } else {
//                render "no_" + renderErrors(bean: contrato)
//            }
////            render "no_no todavia"
//        } else {
//            render "no_<h5>No puede registrar el contrato</h5><ul>${errores}</ul>"
//        }
//    }




    def registrarContrato_ajax () {

        def contrato = Contrato.get(params.id)
        def obras = ObraContrato.findAllByContrato(contrato)

        def errores = ""

        //tiene q tener cronograma y formula polinomica
        def detalle = VolumenContrato.findAllByObraContratoInList(obras, [sort: "volumenOrden"])
        def cronos = CronogramaContratoN.findAllByVolumenContratoInList(detalle)

//        println("cronos " + cronos)


        obras.each {ob->
            def cn = dbConnectionService.getConnection()
            def sql = "select sum(vocrsbtt) from vocr where obcr__id=${ob?.id}";
            def res =  cn.firstRow(sql.toString())
            cn.close()
            def vl = res.values().first()
            if(ob?.valor != vl){
                errores += "<li>El valor: ${ob?.valor} de la obra ${ob?.obra?.codigo}, no coindice con los valores de sus volumenes de obra: ${vl}.</li>"
            }
        }


        if (cronos.cronogramaPrecio.sum().round(2) != contrato.monto.round(2)) {
            errores += "<li>No cuadra los totales del cronograma ${cronos.cronogramaPrecio.sum()} con el valor del contrato: ${contrato.monto}</li>"
        }

        if (cronos.size() == 0) {
            errores += "<li>No ha generado el cronograma de contrato.</li>"
        }

        def crono = 0
        detalle.each {
            def tmp = CronogramaContratoN.findAllByVolumenContrato(it)
            tmp.each { tm ->
                crono += tm.cronogramaPorcentaje
            }
            if (!((crono.toDouble().round(2) <= 100.01) || (crono.toDouble().round(2) >= 99.99))) {
                errores += "<li>La suma de porcentajes del volumen de obra: ${it.item.codigo} (${crono.toDouble().round(2)}) en el cronograma contractual es diferente de 100%</li>"
            }
            crono = 0
        }


        //tiene q tener al menos 2 documentos: plano y justificativo de cantidad de obra
        def concurso = contrato.oferta.concurso
        def documentosContrato = DocumentoProceso.findAllByConcurso(concurso)

        def planoContrato = documentosContrato.findAll { it.nombre.toLowerCase().contains("plano") }
        def justificativoContrato = documentosContrato.findAll { it.nombre.toLowerCase().contains("justificativo") }
        println "documentos: ${documentosContrato} planos: ${planoContrato}, justificativo: ${justificativoContrato}"

        if (planoContrato.size() == 0) {
            errores += "<li>Debe cargar un documento a la biblioteca con nombre 'Plano'</li>"
        }
        if (justificativoContrato.size() == 0) {
            errores += "<li>Debe cargar un documento a la biblioteca con nombre 'Justificativo de cantidad de obra'</li>"
        }

        if (errores == "") { //registra el contrato
            contrato.estado = "R"
            if (contrato.save(flush: true)) {
                render "ok"
            } else {
                render "no_" + renderErrors(bean: contrato)
            }
        } else {
            render "no_<h5>No puede registrar el contrato</h5><ul>${errores}</ul>"
        }
    }

    def cambiarEstado() {

        def contrato = Contrato.get(params.id)
        contrato.estado = "N"
        if (contrato.save(flush: true)) {
            render "ok"
        }
        return

    }


    def registroContrato() {
        def contrato
        def planilla  // si hay planillas de inhabilita el desregistrar
        if (params.contrato) {
            contrato = Contrato.get(params.contrato)
            planilla = Planilla.findAllByContrato(contrato)
            def campos = ["codigo": ["Código", "string"], "nombre": ["Nombre", "string"]]

            [campos: campos, contrato: contrato, planilla: planilla]
        } else {
            def campos = ["codigo": ["Código", "string"], "nombre": ["Nombre", "string"]]
            [campos: campos]
        }
    }

    def saveCambiosPolinomica() {
        if (params.valor.class == java.lang.String) {
            params.valor = [params.valor]
        }
        def errores = ""
        def oks = ""
        def nos = ""
        params.valor.each { par ->
            def parts = par.split("_")
            def id = parts[0]
            def val = parts[1]

            def fp = FormulaPolinomicaContractual.get(id.toLong())
            fp.valor = val.toDouble()
            if (!fp.save(flush: true)) {
                println "error al guardar fp contrato id " + id + ":  " + fp.errors
                errores += fp.errors
                if (nos != "") {
                    nos += ","
                }
                nos += "#" + id
            } else {
                if (oks != "") {
                    oks += ","
                }
                oks += "#" + id
            }
        }
        render oks + "_" + nos
    }

    def copiarPolinomica() {
        println " copiarPolinomica: params $params"
        def contrato = Contrato.get(params.id)
        def formulasVarias = FormulaPolinomicaReajuste.findAllByContrato(contrato)

        /** retorna el id  de la obra terminada en OF o la del cuncurso **/
        def obra = contrato.obra


        def fr = FormulaPolinomicaContractual.findAllByContrato(contrato)

        def fpB0

        //copia la formula polinomica a la formula polinomica contractual si esta no existe
        if (fr.size() < 5) {
            //borra la fórmula en caso de haber menos de 5 coeficientes
            fr.each {
                it.delete(flush: true)
            }

            copiaFpDesdeObra(contrato, true)  //true copia FP desde obra

/*
            def fpReajuste = FormulaPolinomicaReajuste.findByContrato(contrato)

            if(fpReajuste == null){
                def fprj = new FormulaPolinomicaReajuste(contrato: contrato,
                        tipoFormulaPolinomica: tipo,
                        descripcion: "Fórmula polinómica del contrato principal")
                if(!fprj.save(flush: true)){
                    println "error al crear la FP del contrato, errores: " + fprj.errors
                } else {
                    println "fprj creada pero sin fprj"
                    fpReajuste =  fprj
                }
            }

            fp.each {
                if (it.valor > 0) ()def frpl = new FormulaPolinomicaContractual()
                    frpl.valor = it.valor
                    frpl.contrato = contrato
                    frpl.indice = it.indice
                    frpl.tipoFormulaPolinomica = tipo
                    frpl.numero = it.numero
                    frpl.reajuste = fpReajuste
                    if (!frpl.save(flush: true)) {
                        println "error frpl" + frpl.errors
                    }
                }
            }

            FormulaPolinomicaContractual.findAllByContrato(contrato).each { f ->
                f.reajuste = fprj
                f.save(flush: true)
            }
            println "fin de actualización de frpl"
            // inserta valores en fpsp: FormulaSubpresupuesto
            def sbpr = VolumenesObra.findAllByObra(obra, [sort: "orden"]).subPresupuesto.unique()
            println "inserta fpsp, sbpr: $sbpr"
            sbpr.each {
                def fpsp = new FormulaSubpresupuesto(reajuste: fpReajuste, subPresupuesto: it)
                fpsp.save(flush: true)
            }
*/

        }

        //return la tabla para editar
//        def ps = FormulaPolinomicaContractual.findAllByContratoAndNumeroIlike(contrato, "p%", [sort: 'numero'])

        def ps = FormulaPolinomicaContractual.withCriteria {
            eq("contrato", contrato)
            ilike("numero", "p%")
            ne("numero", "P0")
            order("numero", "asc")
        }

        def cuadrilla = FormulaPolinomicaContractual.findAllByContratoAndNumeroIlike(contrato, 'c%', [sort: 'numero'])
        return [ps: ps, cuadrilla: cuadrilla, contrato: contrato, formulas: formulasVarias]
    }


    def fpReajuste_ajax() {
        def formulaPolinomicaReajusteInstance = new FormulaPolinomicaReajuste()

        render(view: '../formulaPolinomicaReajuste/_form', model: [formulaPolinomicaReajusteInstance: formulaPolinomicaReajusteInstance,
                                                                   cntr: params.cntr])
    }

    def grabaFprj() {
        println "grabaFprj params: $params"
        def fprj = new FormulaPolinomicaReajuste()
        def fprjDsde = FormulaPolinomicaReajuste.get(params.copiarDe)
        fprj.properties = params
        println "nueva: cntr: ${fprj.contrato} tp: ${fprj.tipoFormulaPolinomica.codigo} " +
                "dscr: ${fprj.descripcion}"

        if(!fprj.save(flush: true)){
            println "error al crear la FP del contrato, errores: " + fprj.errors
        } else {
            println "+++si guarda fprj, $fprj"
        }

        def fp = FormulaPolinomicaContractual.findAllByContratoAndReajuste(fprj.contrato, fprjDsde)
        fp.each {
            if (it.valor > 0) {
                def frpl = new FormulaPolinomicaContractual()
                frpl.valor = it.valor
                frpl.contrato = fprj.contrato
                frpl.indice = it.indice
                frpl.numero = it.numero
                frpl.reajuste = fprj
                if (!frpl.save(flush: true)) {
                    println "error frpl" + frpl.errors
                }
            }
        }

        render ("ok")
    }

    def tablaFormula_ajax () {
//        println "tablaFormula_ajax params: $params"
        def contrato = Contrato.get(params.cntr)
        def fpReajuste
        if(params.id) {
            fpReajuste = FormulaPolinomicaReajuste.get(params.id)
        } else
            fpReajuste = FormulaPolinomicaReajuste.findByContrato(contrato)

        if(fpReajuste == null){
            copiaFpDesdeObra(contrato, false)
            fpReajuste = FormulaPolinomicaReajuste.findByContrato(contrato)
        }

        def ps = FormulaPolinomicaContractual.withCriteria {
            eq("contrato", fpReajuste.contrato)
            eq("reajuste", fpReajuste)
            ilike("numero", "p%")
            ne("numero", "P0")
            order("numero", "asc")
        }

        def cuadrilla = FormulaPolinomicaContractual.withCriteria {
            eq("contrato", fpReajuste.contrato)
            eq("reajuste", fpReajuste)
            ilike("numero", "c%")
            ne("numero", "C0")
            order("numero", "asc")
        }

        return [ps: ps, cuadrilla: cuadrilla]
    }

    def copiarFormula () {

//        def muestra = FormulaPolinomicaContractual.get(params.id)
//        def codigoMuestra = muestra.codigo
//        def contratoMuestra = muestra.contrato
//
//        def formulasVarias = FormulaPolinomicaContractual.findAllByContrato(contratoMuestra)
//
//        def po = []
//        formulasVarias.each {
//            def cont = it.codigo
//            if(cont in po){
//            }else{
//                po += it.codigo
//            }
//        }


        def fpReajuste = FormulaPolinomicaReajuste.get(params.id)

        def ps = FormulaPolinomicaContractual.withCriteria {
            eq("contrato", fpReajuste.contrato)
            eq("reajuste", fpReajuste)
            order("numero", "asc")
        }

//        println("ps " + ps)
//        println("po " + po.max())

        def errorCopiado = 0


        def cont = FormulaPolinomicaContractual.findAllByContrato(fpReajuste.contrato).codigo

//        println("codigos " + cont.max())

        def nuevoReajuste = new FormulaPolinomicaReajuste()

        nuevoReajuste.contrato = fpReajuste.contrato
        nuevoReajuste.tipoFormulaPolinomica = fpReajuste.tipoFormulaPolinomica
        nuevoReajuste.descripcion = "Formula Polinomica " + (cont.max() + 1)
        nuevoReajuste.save(flush: true);

        ps.each {
            def nuevoP = new FormulaPolinomicaContractual()
            nuevoP.codigo = (cont.max() + 1)
            nuevoP.contrato = it.contrato
            nuevoP.indice = it.indice
            nuevoP.numero = it.numero
            nuevoP.tipoFormulaPolinomica = it.tipoFormulaPolinomica
            nuevoP.valor = it.valor
            nuevoP.version = it.version
            nuevoP.reajuste = nuevoReajuste

            if(!nuevoP.save(flush: true)){
                println("error al copiar la formula polinomica")
                errorCopiado = 1
            }
        }

        if(errorCopiado != 0){
            render "no"
        }else{
            render "si"
        }

    }


    def polinomicaContrato() {
        def contrato = Contrato.get(params.id)
//        def ps = FormulaPolinomicaContractual.findAllByContratoAndNumeroIlike(contrato, "p%", [sort: 'numero'])
        def ps = FormulaPolinomicaContractual.withCriteria {
            eq("contrato", contrato)
            ilike("numero", "p%")
            ne("numero", "P0")
            order("numero", "asc")
        }
        def cuadrilla = FormulaPolinomicaContractual.findAllByContratoAndNumeroIlike(contrato, 'c%', [sort: 'numero'])
        return [ps: ps, cuadrilla: cuadrilla, contrato: contrato]
    }

    def buscarContrato() {

        //println "buscar contrato " + params

        def extraObra = ""
        if (params.campos instanceof java.lang.String) {
            if (params.campos == "nombre") {
                def obras = Obra.findAll("from Obra where nombre like '%${params.criterios.toUpperCase()}%'")
                params.criterios = ""
                obras.eachWithIndex { p, i ->
                    // println "obra "+p.nombre
                    def concursos = janus.pac.Concurso.findAllByObraAndEstado(p, "R")
                    concursos.each { co ->
                        // println "--concurso "+co
                        def ofertas = janus.pac.Oferta.findAllByConcurso(co)
                        ofertas.eachWithIndex { o, k ->
                            //println "---oferta "+o.id
                            extraObra += ("" + o.id)
                            // println "---extra it "+extraObra
                            extraObra += ","
                            // println "---extra coma "+extraObra
                        }

                    }

                }
                if (extraObra.size() < 1) {
                    extraObra = "-1"
                } else {
                    extraObra = extraObra.substring(0, extraObra.size() - 1)
                }
                params.campos = ""
                params.operadores = ""
                // println "extra obra nombre "+extraObra
            }
            if (params.campos == "prov") {
                def provs = janus.pac.Proveedor.findAll("from Proveedor where nombre ilike '%${params.criterios.toUpperCase()}%' or nombreContacto ilike '%${params.criterios.toUpperCase()}%' ")
                params.criterios = ""
                provs.eachWithIndex { p, i ->
                    def ofertas = janus.pac.Oferta.findAllByProveedor(p)
                    ofertas.eachWithIndex { o, k ->
                        extraObra += "" + o.id
                        extraObra += ","
                    }
                }
                if (extraObra.size() < 1) {
                    extraObra = "-1"
                } else {
                    extraObra = extraObra.substring(0, extraObra.size() - 1)
                }
                params.campos = ""
                params.operadores = ""
            }
        } else {
            println "else"
            def remove = []
            params.campos.eachWithIndex { p, i ->
                if (p == "nombre") {
                    def obras = Obra.findAll("from Obra where nombre like '%${params.criterios[i].toUpperCase()}%'")

                    obras.eachWithIndex { ob, j ->
                        def concursos = janus.pac.Concurso.findAllByObraAndEstado(ob, "R")
                        concursos.each { co ->
                            def ofertas = janus.pac.Oferta.findAllByConcurso(co)
                            ofertas.eachWithIndex { o, k ->
                                extraObra += "" + o.id
                                extraObra += ","
                                remove.add(i)
                            }

                        }

                    }
                    if (extraObra.size() < 1) {
                        extraObra = "-1"
                    } else {
                        extraObra = extraObra.substring(0, extraObra.size() - 1)
                    }

                }
                if (p == "prov") {
                    def provs = janus.pac.Proveedor.findAll("from Proveedor where nombre ilike '%${params.criterios[i].toUpperCase()}%' or nombreContacto ilike '%${params.criterios[i].toUpperCase()}%' ")
                    params.criterios = ""
                    provs.eachWithIndex { pr, j ->
                        def ofertas = janus.pac.Oferta.findAllByProveedor(pr)
                        ofertas.eachWithIndex { o, k ->
                            extraObra += "" + o.id
                            extraObra += ","
                        }
                    }
                    if (extraObra.size() < 1) {
                        extraObra = "-1"
                    } else {
                        extraObra = extraObra.substring(0, extraObra.size() - 1)
                    }
                }
            }
            remove.each {
                params.criterios[it] = null
                params.campos[it] = null
                params.operadores[it] = null
            }
        }

        //println "extra obra " + extraObra

        def codObra = { contrato ->
            return contrato?.oferta?.concurso?.obra?.codigo
        }
        def provObra = { contrato ->
            return contrato?.oferta?.proveedor?.nombre
        }
        def plazObra = { contrato ->
            return contrato?.oferta?.concurso?.obra?.plazo
        }
        def nombreObra = { contrato ->
            return contrato?.oferta?.concurso?.obra?.nombre
        }

//        def listaTitulos = ["N. Contrato", "Nombre Obra", "Código Obra", "Monto", "% Anticipo", "Anticipo", "Contratista", "Fecha contrato", "Plazo"]
        def listaTitulos = ["N. Contrato", "Nombre Obra", "Código Obra", "Monto", "% Anticipo", "Anticipo", "Contratista", "Fecha contrato", "Plazo"]
        def listaCampos = ["codigo", "obra", "codigoObra", "monto", "porcentajeAnticipo", "anticipo", "proveedorObra", "fechaSubscripcion", "plazo"]

        def funciones = [null, ["closure": [nombreObra, "&"]], ["closure": [codObra, "&"]], null, null, null, ["closure": [provObra, "&"]], ["format": ["dd/MM/yyyy hh:mm"]], null]
        def url = g.createLink(action: "buscarContrato", controller: "contrato")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'registroContrato', controller: 'contrato') + '?contrato="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " "
        if (extraObra.size() > 0) {
            extras += " and oferta in (${extraObra})"
        }
//        println "extras " + extras

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Contrato
                session.funciones = funciones
                def anchos = [10, 20, 10, 10, 5, 10, 20, 10, 5]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Contrato", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Contratos", anchos: anchos, extras: extras, landscape: true])

            } else {
                def lista = buscadorService.buscar(Contrato, "Contrato", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
            }
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Contrato
            session.funciones = funciones
            def anchos = [10, 20, 10, 10, 5, 10, 20, 10, 5] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Contrato", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Contratos", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def buscarContrato2() {

//        println "buscar contrato 2 " + params

        def extraObra = ""
        if (params.campos instanceof java.lang.String) {
            if (params.campos == "nombre") {
                if (params.criterios.trim() != "") {
                    def obras = Obra.findAll("from Obra where nombre like '%${params.criterios.toUpperCase()}%'")
                    params.criterios = ""
                    obras.eachWithIndex { p, i ->
                        def concursos = janus.pac.Concurso.findAllByObraAndEstado(p, "R")
                        concursos.each { co ->
                            def ofertas = janus.pac.Oferta.findAllByConcurso(co)
                            ofertas.eachWithIndex { o, k ->
                                extraObra += "" + o.id
                                if (k < ofertas.size() - 1) {
                                    extraObra += ","
                                }
                            }

                        }

                    }
                    if (extraObra.size() < 1) {
                        extraObra = "-1"
                    }
                    params.campos = ""
                    params.operadores = ""
                }

            }
            if (params.campos == "prov") {
                if (params.criterios.trim() != "") {
                    def provs = janus.pac.Proveedor.findAll("from Proveedor where nombre like '%${params.criterios.toUpperCase()}%' or nombreContacto like '%${params.criterios.toUpperCase()}%'  or apellidoContacto like '%${params.criterios.toUpperCase()}%'")
                    params.criterios = ""
                    provs.eachWithIndex { p, i ->
                        def ofertas = janus.pac.Oferta.findAllByProveedor(p)
                        ofertas.eachWithIndex { o, k ->
                            extraObra += "" + o.id
                            if (k < ofertas.size() - 1) {
                                extraObra += ","
                            }
                        }
                    }
                    if (extraObra.size() < 1) {
                        extraObra = "-1"
                    }
                    params.campos = ""
                    params.operadores = ""
                }
            }
        } else {
            def remove = []
            params.campos.eachWithIndex { p, i ->
                if (p == "nombre" && params.criterios[i].trim() != "") {
                    def obras = Obra.findAll("from Obra where nombre like '%${params.criterios[i].toUpperCase()}%'")

                    obras.eachWithIndex { ob, j ->
                        def concursos = janus.pac.Concurso.findAllByObraAndEstado(ob, "R")
                        concursos.each { co ->
                            def ofertas = janus.pac.Oferta.findAllByConcurso(co)
                            ofertas.eachWithIndex { o, k ->
                                extraObra += "" + o.id
                                if (k < ofertas.size() - 1) {
                                    extraObra += ","
                                }
                                remove.add(i)
                            }

                        }

                    }
                    if (extraObra.size() < 1) {
                        extraObra = "-1"
                    }

                }
                if (p == "prov" && params.criterios[i].trim() != "") {
                    def provs = janus.pac.Proveedor.findAll("from Proveedor where nombre like '%${params.criterios[i].toUpperCase()}%' or nombreContacto like '%${params.criterios[i].toUpperCase()}%' or apellidoContacto like '%${params.criterios[i].toUpperCase()}%' ")
                    params.criterios = ""
                    provs.eachWithIndex { pr, j ->
                        def ofertas = janus.pac.Oferta.findAllByProveedor(pr)
                        ofertas.eachWithIndex { o, k ->
                            extraObra += "" + o.id
                            if (k < ofertas.size() - 1) {
                                extraObra += ","
                            }
                        }
                    }
                    if (extraObra.size() < 1) {
                        extraObra = "-1"
                    }
                }
            }
            remove.each {
                params.criterios[it] = null
                params.campos[it] = null
                params.operadores[it] = null
            }
        }

//        println "extra obra "+extraObra

        def codObra = { contrato ->
            return contrato?.oferta?.concurso?.obra?.codigo
        }
        def provObra = { contrato ->
            return contrato?.oferta?.proveedor?.nombre
        }
        def plazObra = { contrato ->
            return contrato?.oferta?.concurso?.obra?.plazo
        }
        def nombreObra = { contrato ->
            return contrato?.oferta?.concurso?.obra?.nombre
        }

/*
        def listaTitulos = ["N. Contrato", "Nombre Obra", "Código Obra", "Monto", "% Anticipo", "Anticipo", "Contratista", "Fecha contrato", "Plazo"]
        def listaCampos = ["codigo", "obra", "codigoObra", "monto", "porcentajeAnticipo", "anticipo", "proveedorObra", "fechaInicio", "plazo"]
*/

        def listaTitulos = ["N. Contrato", "Nombre Obra", "Código Obra", "Monto", "% Anticipo", "Anticipo", "Contratista", "Administrador", "Fiscalizador"]
        def listaCampos = ["codigo", "obra", "codigoObra", "monto", "porcentajeAnticipo", "anticipo", "proveedorObra", "administrador", "fiscalizador"]

//        def funciones = [null, ["closure": [nombreObra, "&"]], ["closure": [codObra, "&"]], null, null, null, ["closure": [provObra, "&"]], ["format": ["dd/MM/yyyy hh:mm"]], null]
        def funciones = [null, ["closure": [nombreObra, "&"]], ["closure": [codObra, "&"]], null, null, null, ["closure": [provObra, "&"]], null, null]
        def url = g.createLink(action: "buscarContrato", controller: "contrato")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += 'location.href="' + g.createLink(action: 'verContrato', controller: 'contrato') + '?contrato="+$(this).attr("regId");'
        funcionJs += '}'
        def numRegistros = 20
        def extras = " and estado='R' "
        if (extraObra.size() > 0) {
            extras += "and oferta in (${extraObra})"
        }
//        println "extras "+extras

        if (!params.reporte) {
            if (params.excel) {
                session.dominio = Contrato
                session.funciones = funciones
                def anchos = [10, 20, 10, 10, 5, 10, 20, 10, 5]
                /*anchos para el set column view en excel (no son porcentajes)*/
                redirect(controller: "reportes", action: "reporteBuscadorExcel", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Contrato", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Contratos", anchos: anchos, extras: extras, landscape: true])
            } else {
                def lista = buscadorService.buscar(Contrato, "Contrato", "excluyente", params, true, extras)
                /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
                lista.pop()
                render(view: '../tablaBuscadorColDer', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: lista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs])
            }
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Contrato
            session.funciones = funciones
            def anchos = [10, 20, 10, 10, 5, 10, 20, 10, 5] /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Contrato", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Contratos", anchos: anchos, extras: extras, landscape: true])
        }
    }

    def buscarObra() {
        println "buscar obra "+params
        def extras = " "
        def parr = { p ->
            return p.parroquia?.nombre
        }
        def comu = { c ->
            return c.comunidad?.nombre
        }
        def listaTitulos = ["Código", "Nombre", "Descripción", "Fecha Reg.", "M. ingreso", "M. salida", "Sitio", "Plazo", "Parroquia", "Comunidad", "Clase", "Estado Obra"]
        def listaCampos = ["codigo", "nombre", "descripcion", "fechaCreacionObra", "oficioIngreso", "oficioSalida", "sitio", "plazo", "parroquia", "comunidad", "claseObra", "estadoObra"]
        def funciones = [null, null, null, ["format": ["dd/MM/yyyy hh:mm"]], null, null, null, null, ["closure": [parr, "&"]], ["closure": [comu, "&"]], null, null, null, null]
        def url = g.createLink(action: "buscarObra", controller: "contrato")
        def funcionJs = "function(){"
        funcionJs += '$("#modal-busqueda").modal("hide");'
        funcionJs += '$("#obraId").val($(this).attr("regId"));'
        funcionJs += '$("#nombreObra").val($(this).parent().parent().find(".props").attr("prop_nombre"));'
        funcionJs += '$("#obraCodigo").val($(this).parent().parent().find(".props").attr("prop_codigo"));'
        funcionJs += '$("#parr").val($(this).parent().parent().find(".props").attr("prop_parroquia"));'
        funcionJs += '$("#canton").val($(this).parent().parent().find(".props").attr("prop_canton"));'
        funcionJs += '$("#clase").val($(this).parent().parent().find(".props").attr("prop_claseObra"));'

        funcionJs += '$("#contratista").val("");'
        funcionJs += 'cargarCombo();'
        funcionJs += 'cargarCanton();'
        funcionJs += '}'
//        extras+= " and codigo like '%OF'"
        def numRegistros = 20

        def nuevaLista = []

        if (!params.reporte) {
            def lista = buscadorService.buscar(Obra, "Obra", "excluyente", params, true, extras)
            println("listaf " + lista)
            /* Dominio, nombre del dominio , excluyente o incluyente ,params tal cual llegan de la interfaz del buscador, ignore case */
            lista.pop()
            for (int i = lista.size() - 1; i > -1; i--) {
                def concurso = janus.pac.Concurso.findByObra(lista[i])
                if (concurso) {
                    def oferta = janus.pac.Oferta.findAllByConcurso(concurso)
                    if (oferta.size() > 0) {
                        nuevaLista += lista[i]
                    }
                } /*else {
                    lista.remove(i);
                }*/
            }
//            println "lista2 "+lista
            render(view: '../tablaBuscador', model: [listaTitulos: listaTitulos, listaCampos: listaCampos, lista: nuevaLista, funciones: funciones, url: url, controller: "llamada", numRegistros: numRegistros, funcionJs: funcionJs, width: 1800, paginas: 12])
        } else {
//            println "entro reporte"
            /*De esto solo cambiar el dominio, el parametro tabla, el paramtero titulo y el tamaño de las columnas (anchos)*/
            session.dominio = Obra
            session.funciones = funciones
            def anchos = [7, 10, 7, 7, 7, 7, 7, 4, 7, 7, 7, 7, 7, 7]
            /*el ancho de las columnas en porcentajes... solo enteros*/
            redirect(controller: "reportes", action: "reporteBuscador", params: [listaCampos: listaCampos, listaTitulos: listaTitulos, tabla: "Obra", orden: params.orden, ordenado: params.ordenado, criterios: params.criterios, operadores: params.operadores, campos: params.campos, titulo: "Obras", anchos: anchos, extras: extras, landscape: true])
        }

    }

    def cargarOfertas() {
//        println "params " + params
        def obra = Obra.get(params.id)
//        println "obra " + obra
        def concurso = janus.pac.Concurso.findByObraAndEstado(obra, "R")
//        println "concurso " + concurso
        def ofertas = janus.pac.Oferta.findAllByConcurso(concurso)

//        new Date('dd-MM-yyyy', ofertas?.fechaEntrega)
//        println ofertas
//        println ofertas.monto
//        println ofertas.plazo
        return [ofertas: ofertas]
    }


    def cargarCanton() {
        def obra = Obra.get(params.id)
        render obra?.parroquia?.canton?.nombre
    }


    def getFecha() {

        def fechaOferta = Oferta.get(params.id).fechaEntrega?.format('dd-MM-yyyy')

        return [fechaOferta: fechaOferta]

    }

    def getIndice() {

        def fechaOferta = Oferta.get(params.id).fechaEntrega?.format('dd-MM-yyyy')
        def fechaOfertaMenos = (Oferta.get(params.id).fechaEntrega - 30).format("dd-MM-yyyy")
        def fechaOfertaSin = (Oferta.get(params.id).fechaEntrega - 30)
        def idFecha = PeriodoValidez.findByFechaInicioLessThanEqualsAndFechaFinGreaterThanEquals(fechaOfertaSin, fechaOfertaSin)

        return [fechaOferta: fechaOferta, periodoValidez: idFecha]


    }

    def form_ajax() {
        def contratoInstance = new Contrato(params)
        if (params.id) {
            contratoInstance = Contrato.get(params.id)
            if (!contratoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Contrato con id " + params.id
                redirect(action: "registroContrato")
                return
            } //no existe el objeto
        } //es edit
        return [contratoInstance: contratoInstance]
    } //form_ajax

    def save() {
        def contratoInstance
        def oferta
        def obrasConcurso
        def obrasContrato

//        println("-->> save" + params)

        if (params.codigo) {
            params.codigo = params.codigo.toString().toUpperCase()
        }

        if (params.memo) {
            params.memo = params.memo.toString().toUpperCase()
        }

        if (params.fechaSubscripcion) {
            params.fechaSubscripcion = new Date().parse("dd-MM-yyyy", params.fechaSubscripcion)
        }


        println("params con " + params.conReajuste)

        if(params.conReajuste == 'on'){
            params.conReajuste = 1
        }else{
            params.conReajuste = 0
        }


        def indice = PeriodosInec.get(params."periodoValidez.id")

        if (params.id) {
            contratoInstance = Contrato.get(params.id)

            if (!contratoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Contrato con id " + params.id
                redirect(action: 'registroContrato')
                return
            }//no existe el objeto
            contratoInstance.properties = params
            contratoInstance.periodoInec = indice
            contratoInstance.monto = params.monto.toDouble()

        }//es edit
        else {

            if (params.oferta) {
                if (params.oferta.id == '-1') {
                    flash.clase = "alert-error"
                    flash.message = "No se puede grabar el Contrato, elija una oferta válida "
                    redirect(action: 'registroContrato')
                    return
                }
            }

            contratoInstance = new Contrato(params)
            contratoInstance.periodoInec = indice
            contratoInstance.monto = params.monto.replaceAll(",", "").toDouble()
        } //es create


        if(!params.id){
            oferta = Oferta.get(params."oferta.id")
            obrasConcurso = ObraConcurso.findAllByConcurso(oferta.concurso)
        }



        if (!contratoInstance.save(flush: true)) {

            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Contrato " + (contratoInstance.id ? contratoInstance.id : "") + "</h4>"

            str += "<ul>"
            contratoInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex { arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(action: 'registroContrato')
            return
        }else{

            if(!params.id){
                obrasConcurso.each {
                    def obraC = new ObraContrato()
                    obraC.contrato = contratoInstance
                    obraC.obra = it.obra
                    obraC.valor = it.valor

                    obraC.save(flush: true)
                }
            }



            if (params.id) {
                flash.clase = "alert-success"
                flash.message = "Se ha actualizado correctamente Contrato " + contratoInstance.codigo
            } else {
                flash.clase = "alert-success"
                flash.message = "Se ha creado correctamente Contrato " + contratoInstance.id
            }
            redirect(action: 'registroContrato', params: [contrato: contratoInstance.id])


        }


    } //save

    def show_ajax() {
        def contratoInstance = Contrato.get(params.id)
        if (!contratoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Contrato con id " + params.id
            redirect(action: "registroContrato")
            return
        }
        [contratoInstance: contratoInstance]
    } //show

    def delete() {
        def contratoInstance = Contrato.get(params.id)
        if (!contratoInstance) {
            flash.clase = "alert-error"
            flash.message = "No se encontró Contrato con id " + params.id
            redirect(action: "registroContrato")
            return
        }

        try {

            def fpId = FormulaPolinomicaContractual.findAllByContrato(contratoInstance).id
            fpId.each { id ->

                FormulaPolinomicaContractual.get(id).delete(flush: true)
            }

            contratoInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message = "Se ha eliminado correctamente Contrato " + contratoInstance.id
            redirect(action: "registroContrato")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message = "No se pudo eliminar Contrato " + (contratoInstance.id ? contratoInstance.id : "")
            redirect(action: "registroContrato")
        }
    } //delete

    def obraLiquidacion() {
        def contrato = Contrato.get(params.id)
        def cn = dbConnectionService.getConnection()
        def sql = "select * from obra_lq(" + contrato.obra.id + ")"
        def nuevo = cn.execute(sql.toString())
        cn.close()
        render("Se ha generado la obra para la fórmula polinómica de liquidación")
    }

    def planillasSinPago() {

        def planillas = Planilla.list([sort: 'fechaIngreso'])
        [planillas: planillas]

    }


    def asignar () {
//        println("asignar params " + params)
        def contrato = Contrato.get(params.contrato)
        def subPres = VolumenesObra.findAllByObra(contrato.obra).subPresupuesto.unique()
        def formulas = FormulaPolinomicaReajuste.findAllByContrato(contrato)
        def fpsp = FormulaSubpresupuesto.findAllByReajusteInList(formulas, [sort: 'subPresupuesto'])

//        println "formulas: $formulas"

        return [contrato: contrato, subpresupuesto: subPres, formulas: formulas, fpsp: fpsp]
    }

    def saveAsignarFormula () {
//        println("saveAsignarFormula  " + params)
        def cont = 0

        params.each { k, v ->  // 'k' es el valor de sbpr y 'v' el id de fprj
            def partes = k.split("_")
            if(partes.size() == 2) {
//                println "subpresupuesto: ${partes[1].toLong()} con valor de fprj.id = $v"
                def fpsp = FormulaSubpresupuesto.get(partes[1].toLong())
                fpsp.reajuste = FormulaPolinomicaReajuste.get(v)
                if (!fpsp.save(flush: true)) {
                    render(fpsp.errors)
                    cont++
                }
            }
        }
        if(cont > 0){
            render "no"
        }else{
            render "si"
        }
    }

    def saveAsignarFormula2 () {

        println("saveAsignarFormula2 " + params)

        def su = []
        def fxs = []
        def part
        params.each{
            if(it.key.toString().startsWith("sub")){
                su += it.value
            }
            if(it.key.toString().startsWith("fxs")){
                fxs += it.value
            }
        }

        part = params.formu.toString().split("_")

        println "formula: " +part
        println "subpr: " +su
        println "formula x sp: " +fxs

        def cont

        su.eachWithIndex{g, h->

            def formxSub = FormulaSubpresupuesto.get(fxs[h]);

            formxSub.reajuste = FormulaPolinomicaReajuste.get(part[h])
            formxSub.subPresupuesto = SubPresupuesto.get(g)

            if(!formxSub.save(flush: true)){
                println("Error al asignar las formulas polinomicas")
                cont = 1
            }else{
                cont = 0
            }
        }

        if(cont == 1){
            render "no"
        }else{
            render "si"
        }

    }

    // copia true: copia FP de la obra, false, ya existe FP contractual
    def copiaFpDesdeObra(cntr, copia) {
        def fpReajuste = FormulaPolinomicaReajuste.findByContrato(cntr)
        def tipo = TipoFormulaPolinomica.get(1)

        if(fpReajuste == null){
            def fprj = new FormulaPolinomicaReajuste(contrato: cntr,
                    tipoFormulaPolinomica: tipo,
                    descripcion: "Fórmula polinómica del contrato principal")
            if (!fprj.save(flush: true)) {
                println "error al crear la FP del contrato, errores: " + fprj.errors
            } else {
                println "fprj creada pero sin fprj"
                fpReajuste = fprj
            }
        }

        if(copia){
            def fp = FormulaPolinomica.findAllByObra(cntr.obra)
            fp.each {
                if (it.valor > 0) {
                    def frpl = new FormulaPolinomicaContractual()
                    frpl.valor = it.valor
                    frpl.contrato = cntr
                    frpl.indice = it.indice
                    frpl.tipoFormulaPolinomica = tipo
                    frpl.numero = it.numero
                    frpl.reajuste = fpReajuste
                    if (!frpl.save(flush: true)) {
                        println "error frpl" + frpl.errors
                    }
                }
            }
        } else {
            def fp = FormulaPolinomicaContractual.findAllByContrato(cntr)
            fp.each {
                it.reajuste = fpReajuste
                if (!it.save(flush: true)) {
                    println "error frpl" + it.errors
                }
            }

        }

        println "fin de actualización de frpl"
        // inserta valores en fpsp: FormulaSubpresupuesto
        def sbpr = VolumenesObra.findAllByObra(cntr.obra, [sort: "orden"]).subPresupuesto.unique()
        println "inserta fpsp, sbpr: $sbpr"
        sbpr.each {
            def fpsp = new FormulaSubpresupuesto(reajuste: fpReajuste, subPresupuesto: it)
            fpsp.save(flush: true)
        }

    }


    def tablaObras_ajax() {
//        println("params tabla oferta " + params)
        def obras
        def oferta

        if(params.contrato){
            def contrato = Contrato.get(params.contrato)
            obras = ObraContrato.findAllByContrato(contrato, [sort: 'obra', order: 'asc'])
            oferta = contrato.oferta
        }else{
            oferta = Oferta.get(params.oferta)
            def concurso = oferta.concurso
            obras = ObraConcurso.findAllByConcurso(concurso, [sort: 'obra', order: 'asc'])
        }

        println "obras: $obras"
        return [obras: obras, oferta: oferta, contrato: params.contrato]
    }

    def calcularMonto_ajax () {
        def oferta = Oferta.get(params.oferta)
        def concurso = oferta.concurso
        def obras
        def montoTotal = 0


        if(params.contrato){
            def contrato = Contrato.get(params.contrato)
            obras = ObraContrato.findAllByContrato(contrato, [sort: 'obra', order: 'asc'])
            obras.each {
                montoTotal += it.valor
            }
        }else{
            obras = ObraConcurso.findAllByConcurso(concurso)
            obras.each {
                montoTotal += it.valor
            }
        }

        render montoTotal
    }

    def copiarRubros_ajax (){
        println("copiarRubros_ajax: " + params)
        def cn = dbConnectionService.getConnection()
        def obcr = ObraContrato.get(params.obra)

        def sql = "insert into vocr(sbpr__id, item__id, obcr__id, vocrcntd, vocrordn, vocrpcun, vocrsbtt, vocrrtcr, area__id) " +
                "select sbpr__id, item__id, ${params.obra}, vlobcntd, vlobordn, vlobpcun, vlobsbtt, vlobrtcr, area__id " +
                "from vlob where obra__id = ${obcr.obra.id}"
        println "insert de copiarRubros_ajax: $sql"

        cn.execute(sql.toString())
        cn.close()

        params.id = obcr.id
        redirect controller: 'volumenObra', action: 'volObraContrato', params: params
    }

    def revisarRubros_ajax () {
        println "revisarRubros_ajax $params"
        def obraContrato = ObraContrato.get(params.obra)
        def vocr = VolumenContrato.findAllByObraContrato(obraContrato)?.size() > 0

        render vocr? "ok" : "no"
    }

    def actualizarValorObra_ajax () {
        def obraContrato = ObraContrato.get(params.obra)
        def cn = dbConnectionService.getConnection()
        def sql = "select sum(vocrsbtt) from vocr where obcr__id=${obraContrato?.id}";
        def res =  cn.firstRow(sql.toString())
        cn.close()
        def vl = res.values().first()
        obraContrato.valor = vl
        if(obraContrato.save(flush: true)){
            render "ok_${obraContrato?.contrato?.id}"
        }else{
            render "no_"
        }
    }

    def tablaVerObras_ajax () {
        def obras

            def contrato = Contrato.get(params.contrato)
            obras = ObraContrato.findAllByContrato(contrato, [sort: 'obra', order: 'asc'])

        return [obras: obras, contrato: contrato]
    }


} //fin controller
