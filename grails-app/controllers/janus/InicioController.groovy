package janus

import janus.pac.CodigoComprasPublicas
import janus.seguridad.Prfl
import jxl.Cell
import jxl.Sheet
import jxl.Workbook
import jxl.WorkbookSettings
import org.springframework.dao.DataIntegrityViolationException
import groovy.time.TimeCategory


class InicioController extends janus.seguridad.Shield {
    def dbConnectionService
    def oferentesService

    def index() {
        def cn = dbConnectionService.getConnection()
        def prms = []
        def acciones = "'rubroPrincipal', 'registroObra', 'registrarPac', 'verContrato'"
        def tx = "select accnnmbr from prms, accn where prfl__id = " + Prfl.findByNombre(session.perfil.toString()).id +
                " and accn.accn__id = prms.accn__id and accnnmbr in (${acciones})"
        cn.eachRow(tx) { d ->
            prms << d.accnnmbr
        }
        cn.close()
        def empr = Parametros.get(1)

        //println "formula "
        //oferentesService.copiaFormula(1457,1485)
       // println " crono "
        //oferentesService.copiaCrono(1457,1485)
        return [prms: prms, empr: empr]
    }


    def inicio() {
        redirect(action: "index")
    }

    def parametros = {

    }

    def arbol () {

    }

    def manualObras = {

    }

    def variables () {
        def paux = Parametros.get(1);
        def par = Parametros.list()
        return[paux: paux, par: par]
    }

    def formArchivo() {
        return [obra: params.id]
    }


    def cargaArch() {
        println "cargaArch $params"
        def tipo = params.tipo
        def dprt
        def sbgr
        def tpls
        def tpit = TipoItem.findByCodigo('I')
        def lgar
        def contador = 0
        def repetidos = 0
        def cargar
        def lugares = []
        def path = servletContext.getRealPath("/") + "xlsData/"   //web-app/archivos
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }

            if (ext == "xls") {
//                fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")

                fileName = "xlsComposicion_" + new Date().format("yyyyMMdd_HHmmss")

                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path

                //procesar excel
                def htmlInfo = "", errores = "", doneHtml = ""
                def file = new File(pathFile)
                WorkbookSettings ws = new WorkbookSettings();
                ws.setEncoding("Cp1252");
                Workbook workbook = Workbook.getWorkbook(file, ws)
                workbook.getNumberOfSheets().times { sheet ->

                    /** ------------------- carga equipos ----------------- **/
                    if (sheet == 0) {  // primera hoja Equipo -- no tiene categoria
                        Sheet s = workbook.getSheet(sheet)
                        if (!s.getSettings().isHidden()) {
                            println "hoja: ${s.getName()} sheet: $sheet, registros: ${s.getRows()}"
                            htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                            Cell[] row = null

                            dprt = DepartamentoItem.findByCodigo(params.sbgr)
                            lgar = Lugar.findByCodigo(100)
                            tpls = TipoLista.get(6)
//                            sbgr = SubgrupoItems.findByCodigo(params.sbgr)
                            sbgr = SubgrupoItems.findByCodigoAndGrupo(params.sbgr, Grupo.get(3))

                            s.getRows().times { j ->
                                row = s.getRow(j)
                                println row*.getContents()
//                                println row.length

                                if (row.length >= 6) {
                                    def cod =    row[0].getContents().toUpperCase()
                                    def nombre = row[1].getContents()
                                    def unidad = Unidad.findByCodigo(row[2].getContents())
                                    def costo  = row[3].getContents()
                                    def cpc    = row[4].getContents()
                                    def vae   = row[5].getContents()

                                    if (cod != "CODIGO") {  // no es el título
                                        //cargaItem(itemcdgo, tipo, nombre, unidad, categoria, sbgr, costo, cpc, tpit, dprt,
                                        // lgar, vae, costos, lugares, tpls)
                                        cargar = cargaItem(cod, tipo, nombre, unidad, null, null, costo, cpc, tpit, dprt,
                                                lgar, vae, null, null, tpls)
                                        if(cargar.contador) contador++ else repetidos++
                                    }
                                } //row ! empty
                            } //rows.each
                        } //sheet ! hidden
                        htmlInfo += "<p>Se han cargado $contador registros<p><br>Registros repetidos: $repetidos"
                    }// sheet 0

                    /** ------------------- Mano de Obra ----------------- **/
                    if (sheet == 1) {
                        Sheet s = workbook.getSheet(sheet)
                        def unidad = Unidad.findByCodigo('h')
                        dprt = DepartamentoItem.findByCodigo('006')
                        println "departamento: --- $dprt, unidad: ${unidad.descripcion}"
                        lgar = Lugar.findByCodigo(100)
                        sbgr = SubgrupoItems.get(21)
                        tpls = TipoLista.get(6)

                        if (!s.getSettings().isHidden()) {
                            println "hoja: ${s.getName()} sheet: $sheet, registros: ${s.getRows()}"
                            htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                            Cell[] row = null
                            s.getRows().times { j ->
                                row = s.getRow(j)
                                println row*.getContents()
//                                println row.length

                                if (row.length >= 5) {
                                    def cod        = row[0].getContents().toUpperCase()
                                    def nombre     = row[1].getContents()
                                    def categoria  = row[2].getContents()
                                    def costo      = row[3].getContents()
                                    def cpc        = row[4].getContents()
                                    def vae        = row[5].getContents()

                                    if (cod != "CODIGO") {  // no es el título
                                        //cargaItem(itemcdgo, tipo, nombre, unidad, categoria, sbgr, costo, cpc, tpit,
                                        // dprt, lgar, vae, costos, lugares, tpls)
                                        cargar = cargaItem(cod, tipo, nombre, unidad, categoria, sbgr, costo, cpc, tpit,
                                                dprt, lgar, vae, null, null, tpls)
                                        if(cargar.contador) contador++ else repetidos++
                                    }
                                } //row ! empty
                            } //rows.each
                        } //sheet ! hidden
                        htmlInfo += "<p>Se han cargado $contador registros<p><br>Registros repetidos: $repetidos"
                    }// sheet 1

                    /** ------------------- Materiales ----------------- **/
                    if (sheet == 2) {
                        Sheet s = workbook.getSheet(sheet)
                        dprt = DepartamentoItem.findByCodigo('001')
                        sbgr = SubgrupoItems.findByCodigoAndGrupo(params.sbgr_mt, Grupo.get(1))
                        tpls = TipoLista.get(1)

                        if (!s.getSettings().isHidden()) {
                            println "hoja: ${s.getName()} sheet: $sheet, registros: ${s.getRows()}"
                            htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                            Cell[] row = null
                            s.getRows().times { j ->
//                            (3700..s.getRows()).each { j ->
                                row = s.getRow(j)
                                println "cargando: ${row*.getContents()}"
//                                println row.length

                                if (row.length >= 10) {
                                    def cod =    row[0].getContents().toUpperCase()
                                    def nombre = row[1].getContents()
                                    def unidad = Unidad.findByCodigo(row[2].getContents())
                                    def categoria  = row[3].getContents()
                                    def cpc    = row[4].getContents().replaceAll(~/\./, "")
                                    def vae   = row[5].getContents()
                                    if (cod != "CODIGO" && cod) {  // no es el título
                                        def costos = []
                                        lugares = []
                                        (0..11).each {
//                                            println "pone lugares y costos con it: $it"
                                            lugares.add(it+1)
//                                            costos.add(row[it+6].getContents())
                                            costos.add(Math.round(row[it+6].getValue()*100000)/100000)
                                        }
//                                        println "lugares y precios: $lugares\n$costos"
                                        //cargaItem(itemcdgo, tipo, nombre, unidad, categoria, sbgr, costo, cpc, tpit, dprt,
                                        // lgar, vae, costos, lugares, tpls)
                                        cargar = cargaItem(cod, tipo, nombre, unidad, categoria, sbgr, null, cpc, tpit, dprt,
                                                lgar, vae, costos, lugares, tpls)
                                        if(cargar.contador) contador++ else repetidos++
                                    }
                                } //row ! empty
                            } //rows.each
                        } //sheet ! hidden
                        htmlInfo += "<p>Se han cargado $contador registros<p><br>Registros repetidos: $repetidos"
                    }//solo sheet 0

                } //sheets.each
                if (contador > 0) {
                    doneHtml = "<div class='alert alert-success'>Se han ingresado correctamente $contador registros</div>"
                }

                def str = doneHtml
                str += htmlInfo
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }
                str += doneHtml

                flash.message = str

                println "DONE!! --> $str"
                redirect(action: 'mensajeUpload')
            } else {
                flash.message = "Seleccione un archivo Excel xls para procesar (archivos xlsx deben ser convertidos a xls primero)"
                redirect(action: 'formArchivo')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'formArchivo')
//            println "NO FILE"
        }
    }

    def mensajeUpload() {

    }

    def cargaItem(itemcdgo, tipo, nombre, unidad, categoria, sbgr, costo, cpc, tpit, dprt, lgar, vae, costos, lugares, tpls) {
        def inicio = new Date()
        def cn = dbConnectionService.getConnection()
        def existe = Item.findByNombreIlike(nombre)
        def fin = new Date()
        println "halla item: ${TimeCategory.minus(fin, inicio)}"
        def tx = ""
        def item
        def rbpc
        def cpac
        def itva
        def fcha = new Date()
        def vvae = 100
        def contador = 0
        def errores = ""

        if(vae == 'EP') {
            vvae = 100
        } else if(vae == 'ND') {
            vvae = 40
        } else {
            vvae = 0
        }


        if (!existe) {
            cpac = CodigoComprasPublicas.findByNumero(cpc)
            fin = new Date()
            println "halla cpac: ${TimeCategory.minus(fin, inicio)}"
            item = new Item()
            item.codigo = tipo + itemcdgo
            item.nombre = nombre
            item.unidad = unidad
            item.tipoItem = tpit
            item.tipoLista = tpls
            if(categoria){
                tx = "select coalesce(max(cast(dprtcdgo as integer)), 0) maximo from dprt where sbgr__id = ${sbgr.id}"
                def ctgr = DepartamentoItem.findByDescripcion(categoria)
                if(!ctgr){
//                    println "sql: $tx"
                    def nmro = cn.rows(tx.toString())[0].maximo + 1
                    cn.close()
//                    println "numero: $nmro, codigo: ${tipo + nmro}"
                    ctgr = new DepartamentoItem()
                    ctgr.codigo = nmro
                    ctgr.descripcion = categoria
                    ctgr.subgrupo = sbgr
                    ctgr.save(flush: true)
                    ctgr.refresh()
                    item.departamento = ctgr
                } else {
                    item.departamento = ctgr
                }
            } else {
                item.departamento = dprt
            }
            item.codigoComprasPublicas = cpac?:null
            try {
                item.save(flush: true)
//                println "........ ${item.codigo}, ${item.nombre}, ${item.unidad.id}, ${item.tipoItem}, ${item.departamento}"
            } catch (DataIntegrityViolationException e) {
                println "ERROR: $e"
            }

            item.refresh()
            fin = new Date()
            println "crea item: ${TimeCategory.minus(fin, inicio)}"

//            println "pasa item.."

            if(!costos) {
                rbpc = new PrecioRubrosItems()
                rbpc.lugar = lgar
                rbpc.item = item
                rbpc.fecha = fcha
                rbpc.fechaIngreso = fcha
                rbpc.precioUnitario = costo.toDouble()
                rbpc.registrado = 'N'
                rbpc.save(flush: true)
//            println "pasa rbpc.."
            } else {
                (0..11).each {
                    if(costos[it].toDouble() > 0) {
                        tx = "insert into rbpc(item__id, lgar__id, rbpcfcha, rbpcpcun, rbpcfcin, rbpcrgst) " +
                                "values(${item.id}, ${lugares[it]}, '${fcha.format('yyyy-MM-dd')}', " +
                                "${costos[it].toDouble()}, '${fcha.format('yyyy-MM-dd')}', 'N')"
//                        println "sql: $tx"
                        cn.execute(tx.toString())
/*
                        rbpc = new PrecioRubrosItems()
                        rbpc.lugar = Lugar.get(lugares[it])
                        rbpc.item = item
                        rbpc.fecha = fcha
                        rbpc.fechaIngreso = fcha
                        rbpc.precioUnitario = costos[it].toDouble()
                        rbpc.registrado = 'N'
                        rbpc.save(flush: true)
*/
                    }
                }
//            println "pasa rbpc.."
            }

            fin = new Date()
            println "crea precios: ${TimeCategory.minus(fin, inicio)}"

            itva = new VaeItems()
            itva.item = item
            itva.fecha = fcha
            itva.fechaIngreso = fcha
            itva.registrado = 'N'
            itva.porcentaje = vvae
            itva.save(flush: true)
//            println "pasa itva.."

//            println " se ha grabado el item: $item"
            contador++
            fin = new Date()
            println "fin: ${TimeCategory.minus(fin, inicio)}"

        } else {
            errores += "<li>Ya existe el item con código ${itemcdgo}</li>"
            println "Ya existe el item con código ${itemcdgo}"
        }
        return [errores: errores, contador: contador]
    }

}
