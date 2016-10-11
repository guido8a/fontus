package janus

import org.springframework.dao.DataIntegrityViolationException

class ProvinciaController extends janus.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [provinciaInstanceList: Provincia.list(params), provinciaInstanceTotal: Provincia.count(), params: params]
    } //list

    def form_ajax() {
        def provinciaInstance = new Provincia(params)
        if(params.id) {
            provinciaInstance = Provincia.get(params.id)
            if(!provinciaInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Provincia con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [provinciaInstance: provinciaInstance]
    } //form_ajax

    def save() {
        def provinciaInstance
        if(params.id) {
            provinciaInstance = Provincia.get(params.id)
            if(!provinciaInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró la Provincia " + params.id
//                redirect(action: 'list')
                redirect(controller: 'canton' , action: 'arbol')
                return
            }//no existe el objeto
            provinciaInstance.properties = params
        }//es edit
        else {
            provinciaInstance = new Provincia(params)
            provinciaInstance.nombre = params.nombre.toUpperCase()
        } //es create
        if (!provinciaInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar la Provincia " + (provinciaInstance.id ? provinciaInstance.nombre : "") + "</h4>"

            str += "<ul>"
            provinciaInstance.errors.allErrors.each { err ->
                def msg = err.defaultMessage
                err.arguments.eachWithIndex {  arg, i ->
                    msg = msg.replaceAll("\\{" + i + "}", arg.toString())
                }
                str += "<li>" + msg + "</li>"
            }
            str += "</ul>"

            flash.message = str
//            redirect(action: 'list')
            redirect(controller: 'canton' , action: 'arbol')
            return
        }

        if(params.id) {
            flash.clase = "alert-success"
            flash.message = "Se ha actualizado correctamente la Provincia " + provinciaInstance.nombre
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente la Provincia " + provinciaInstance.nombre
        }
        redirect(controller: 'canton' , action: 'arbol')
    } //save

    def show_ajax() {
        def provinciaInstance = Provincia.get(params.id)
        if (!provinciaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Provincia con id " + params.id
            redirect(action: "list")
            return
        }
        [provinciaInstance: provinciaInstance]
    } //show

    def delete() {
        def provinciaInstance = Provincia.get(params.id)
        if (!provinciaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró la Provincia "
            redirect(controller: 'canton', action: "arbol")
            return
        }

        try {
            provinciaInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message =  "Se ha eliminado correctamente la Provincia "
            redirect(controller: 'canton', action: "arbol")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message =  "No se pudo eliminar la Provincia " + (provinciaInstance.id ? provinciaInstance.nombre : "")
            redirect(controller: 'canton', action: "arbol")
        }
    } //delete
} //fin controller
