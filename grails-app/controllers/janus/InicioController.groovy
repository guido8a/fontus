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

    def uploadFile() {
        def obra = Obra.get(params.id)
        def path = servletContext.getRealPath("/") + "xlsComposicion/"   //web-app/archivos
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
                    if (sheet == 0) {
                        Sheet s = workbook.getSheet(sheet)
                        if (!s.getSettings().isHidden()) {
//                            println s.getName() + "  " + sheet
                            htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                            Cell[] row = null
                            s.getRows().times { j ->
                                def ok = true
//                                if (j > 19) {
//                                println ">>>>>>>>>>>>>>>" + (j + 1)
                                row = s.getRow(j)
//                                println row*.getContents()
//                                println row.length
                                if (row.length >= 5) {
                                    def cod = row[0].getContents()
                                    def nombre = row[1].getContents()
                                    def cant = row[3].getContents()
                                    def nuevaCant = row[4].getContents()

//                                    println "\t\tcod:" + cod + "\tnombre:" + nombre + "\tcant:" + cant + "\tnCant:" + nuevaCant

                                    if (cod != "CODIGO") {
//                                        println "\t\t**"
                                        def item = Item.findAllByCodigo(cod)
//                                        println "\t\t???" + item
                                        if (item.size() == 1) {
                                            //ok
                                            item = item[0]
                                        } else if (item.size() == 0) {
                                            errores += "<li>No se encontró item con código ${cod} (l. ${j + 1})</li>"
                                            println "No se encontró item con código ${cod}"
                                            ok = false
                                        } else {
                                            println "Se encontraron ${item.size()} items con código ${cod}!! ${item.id}"
                                            errores += "<li>Se encontraron ${item.size()} items con código ${cod}!! (l. ${j + 1})</li>"
                                            ok = false
                                        }
                                        if (ok) {
                                            def comp = Composicion.withCriteria {
                                                eq("item", item)
                                                eq("obra", obra)
                                            }
                                            if (comp.size() == 1) {
                                                comp = comp[0]
                                                comp.cantidad = nuevaCant.toDouble()

                                                if (comp.save(flush: true)) {
                                                    done++
//                                                    println "Modificado comp: ${comp.id}"
                                                    doneHtml += "<li>Se ha modificado la cantidad para el item ${nombre}</li>"
                                                } else {
                                                    println "No se pudo guardar comp ${comp.id}: " + comp.errors
                                                    errores += "<li>Ha ocurrido un error al guardar la cantidad para el item ${nombre} (l. ${j + 1})</li>"
                                                }
//                                            println comp
//                                            /** **/
//                                            row.length.times { k ->
//                                                if (!row[k].isHidden()) {
//                                                    println "k:" + k + "      " + row[k].getContents()
//                                                }// row ! hidden
//                                            } //row.legth.each
                                            } else if (comp.size() == 0) {
                                                println "No se encontró composición para el item ${nombre}"
                                                errores += "<li>No se encontró composición para el item ${nombre} (l. ${j + 1})</li>"
                                            } else {
                                                println "Se encontraron ${comp.size()} composiciones para el item ${nombre}: ${comp.id}"
                                                errores += "<li>Se encontraron ${comp.size()} composiciones para el item ${nombre} (l. ${j + 1})</li>"
                                            }
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

}
