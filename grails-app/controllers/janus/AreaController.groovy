package janus

import org.springframework.dao.DataIntegrityViolationException

class AreaController extends janus.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [areaInstanceList: Area.list(params), params: params]
    } //list


    def form_ajax() {
        def AreaInstance = new Area(params)
        if(params.id) {
            AreaInstance = Area.get(params.id)
            if(!AreaInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Area con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
//        render "ok_se ha creado el área"
        return [AreaInstance: AreaInstance]
    } //form_ajax

    def save() {
        def AreaInstance
        def mensaje = ""
        if(params.id) {
            AreaInstance = Area.get(params.id)
            if(!AreaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Area con id " + params.id
                redirect(action: '')
                return
            }//no existe el objeto
            AreaInstance.properties = params
            AreaInstance.descripcion = params.descripcion.toUpperCase()
        }//es edit
        else {
            AreaInstance = new Area(params)
            AreaInstance.descripcion = params.descripcion.toUpperCase()
        } //es create
        if (!AreaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Area " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"

            str += "<ul>"
            AreaInstance.errors.allErrors.each { err ->
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
            flash.message = "Se ha actualizado correctamente Area " + AreaInstance.id
            mensaje = "Se ha actualizado correctamente Area " + AreaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Area " + AreaInstance.id
            mensaje = "Se ha creado correctamente Area " + AreaInstance.id
        }
        render "ok_" + mensaje
//        redirect(action: 'list')
    } //save


    def saveTextoFijo() {

        def AreaInstance
        if(params.id) {
            AreaInstance = Area.get(params.id)
            if(!AreaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Area con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            AreaInstance.properties = params
        }//es edit
        else {
            AreaInstance = new Area(params)
        } //es create
        if (!AreaInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Area " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el texto en Textos Fijos " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"

            str += "<ul>"
            AreaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Area " + AreaInstance.id
            flash.message = "Se ha actualizado correctamente el texto en Textos Fijos "
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Area " + AreaInstance.id
            flash.message = "Se ha creado correctamente el texto en Textos Fijos "
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //saveTextoFijo


    def saveMemoPresu() {
//        println(params)
        def AreaInstance
        if(params.id) {
            AreaInstance = Area.get(params.id)
            if(!AreaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Area con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            AreaInstance.properties = params
        }//es edit
        else {
            AreaInstance = new Area(params)
        } //es create
        if (!AreaInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Area " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el texto en Adm. Directa " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"

            str += "<ul>"
            AreaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Area " + AreaInstance.id
            flash.message = "Se ha actualizado correctamente el texto en Adm. Directa"
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Area " + AreaInstance.id
            flash.message = "Se ha creado correctamente el texto en Adm. Directa"
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //save


    def saveMemoAdj() {

        println("params adj:" + params)

        def AreaInstance
        if(params.id) {
            AreaInstance = Area.get(params.id)
            if(!AreaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Area con id " + params.id
                redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
                return
            }//no existe el objeto
            AreaInstance.properties = params
        }//es edit
        else {
            AreaInstance = new Area(params)
        } //es create
        if (!AreaInstance.save(flush: true)) {
            flash.clase = "alert-error"
//            def str = "<h4>No se pudo guardar Area " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"
            def str = "<h4>No se pudo guardar el adjunto en Adm. Directa " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"

            str += "<ul>"
            AreaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
//            flash.message = "Se ha actualizado correctamente Area " + AreaInstance.id
            flash.message = "Se ha actualizado el texto adjunto en Adm. Directa "
        } else {
            flash.clase = "alert-success"
//            flash.message = "Se ha creado correctamente Area " + AreaInstance.id
            flash.message = "Se ha creado el texto adjunto en Adm. Directa "
        }
        redirect(controller: 'documentosObra', action: 'documentosObra', id: params.obra)
    } //save




    def saveText() {
        def AreaInstance
        if(params.id) {
            AreaInstance = Area.get(params.id)
            if(!AreaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Area con id " + params.id
                redirect(controller: 'Area', action: 'textosFijos')
                return
            }//no existe el objeto
            AreaInstance.properties = params
        }//es edit
        else {
            AreaInstance = new Area(params)
        } //es create
        if (!AreaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Area " + (AreaInstance.id ? AreaInstance.id : "") + "</h4>"

            str += "<ul>"
            AreaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
            redirect(controller: 'Area', action: 'textosFijos')
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente Area " + AreaInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Area " + AreaInstance.id
        }
        redirect(controller: 'Area', action: 'textosFijos')
    } //save




    def show_ajax() {
        def AreaInstance = Area.get(params.id)
        if (!AreaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Area con id " + params.id
            redirect(action: "list")
            return
        }
        [AreaInstance: AreaInstance]
    } //show

    def delete() {
        def AreaInstance = Area.get(params.id)
        if (!AreaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Area con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            AreaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message =  "Se ha eliminado correctamente Area " + AreaInstance.id
//            redirect(action: "list")
            render "ok_Se ha borrado el área de subpresupuesto"
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message =  "No se pudo eliminar Area " + (AreaInstance.id ? AreaInstance.id : "")
            redirect(action: "list")
            render "ok_No se pudo borrar el área de subpresupuesto del sistema, debe estar usada en una obra"
        }
    } //delete
} //fin controller
