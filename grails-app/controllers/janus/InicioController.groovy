package janus

import janus.seguridad.Prfl
import jxl.Cell
import jxl.Sheet
import jxl.Workbook


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
        def lgar
        def rbpc
        def itva
        def fcha = new Date()
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
                def htmlInfo = "", errores = "", doneHtml = "", done = 0
                def file = new File(pathFile)
                Workbook workbook = Workbook.getWorkbook(file)

                workbook.getNumberOfSheets().times { sheet ->
                    if (sheet == 0) {  // primera hoja Equipo
                        Sheet s = workbook.getSheet(sheet)
                        if (!s.getSettings().isHidden()) {
                            println "hoja: ${s.getName()} sheet: $sheet, registros: ${s.getRows()}"
                            htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                            Cell[] row = null
                            s.getRows().times { j ->
                                def ok = true
                                row = s.getRow(j)
                                println row*.getContents()
//                                println row.length

                                if (row.length >= 5) {
                                    def cod =    row[0].getContents()
                                    def nombre = row[1].getContents()
                                    def unidad = row[2].getContents()
                                    def costo  = row[3].getContents()
                                    def cpc    = row[4].getContents()
                                    def vae   = row[5].getContents()
                                    if(vae == 'EP') {
                                        vae = '100'
                                    } else if(vae == 'ND') {
                                        vae = '40'
                                    } else {
                                        vae = '0'
                                    }

                                    if (cod != "CODIGO") {  // no es el título
                                        def item = Item.findAllByCodigo(cod)
                                        if (item.size() == 0) {
                                            //ok
                                            item = new Item()
                                            item.codigo = tipo + cod
                                            item.nombre = nombre
                                            item.unidad = Unidad.findByCodigo(unidad)
                                            try {
                                                item.save(flush: true)
                                            } catch (e) {
                                                println e
                                            }

                                            item.refresh()
                                            println "pasa item.."

                                            lgar = Lugar.findByCodigo(10)
                                            rbpc = new PrecioRubrosItems()
                                            rbpc.lugar = lgar
                                            rbpc.item = item
                                            rbpc.fecha = fcha
                                            rbpc.fechaIngreso = fcha
                                            rbpc.precioUnitario = costo.toDouble()
                                            rbpc.registrado = 'N'
                                            rbpc.save(flush: true)
                                            println "pasa rbpc.."

                                            itva = new VaeItems()
                                            itva.item = item
                                            itva.fecha = fcha
                                            itva.fechaIngreso = fcha
                                            itva.registrado = 'N'
                                            itva.porcentaje = vae.toInteger()
                                            itva.save(flush: true)
                                            println "pasa itva.."

                                            println " se ha grabado el item: $item"

                                        } else if (item.size() == 1) {
                                            errores += "<li>Ya existe el item con código ${cod} (l. ${j + 1})</li>"
                                            println "Ya existe el item con código ${cod}"
                                            ok = false
                                        }

                                    }
                                } //row ! empty
//                                }//row > 7 (fila 9 + )
                            } //rows.each
                        } //sheet ! hidden
                    }//solo sheet 0
                } //sheets.each
                if (done > 0) {
                    doneHtml = "<div class='alert alert-success'>Se han ingresado correctamente " + done + " registros</div>"
                }

                def str = doneHtml
                str += htmlInfo
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }
                str += doneHtml

                flash.message = str

                println "DONE!!"
                redirect(action: "mensajeUpload", id: params.id)
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
        return [obra: params.id]
    }



}
