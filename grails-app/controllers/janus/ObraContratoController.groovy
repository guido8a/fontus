package janus

import org.springframework.dao.DataIntegrityViolationException

class ObraContratoController extends janus.seguridad.Shield {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        [obraContratoInstanceList: ObraContrato.list(params), params: params]
    } //list

    def form_ajax() {
        def obraContratoInstance = new ObraContrato(params)
        if(params.id) {
            obraContratoInstance = ObraContrato.get(params.id)
            if(!obraContratoInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Obra Contrato con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [obraContratoInstance: obraContratoInstance]
    } //form_ajax

    def save() {
        def obraContratoInstance
        if(params.id) {
            obraContratoInstance = ObraContrato.get(params.id)
            if(!obraContratoInstance) {
                flash.clase = "alert-error"
                flash.message = "No se encontró Obra Contrato con id " + params.id
                redirect(action: 'list')
                return
            }//no existe el objeto
            obraContratoInstance.properties = params
        }//es edit
        else {
            obraContratoInstance = new ObraContrato(params)
        } //es create
        if (!obraContratoInstance.save(flush: true)) {
            flash.clase = "alert-error"
            def str = "<h4>No se pudo guardar Obra Contrato " + (obraContratoInstance.id ? obraContratoInstance.id : "") + "</h4>"

            str += "<ul>"
            obraContratoInstance.errors.allErrors.each { err ->
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
            flash.message = "Se ha actualizado correctamente Obra Contrato " + obraContratoInstance.id
        } else {
            flash.clase = "alert-success"
            flash.message = "Se ha creado correctamente Obra Contrato " + obraContratoInstance.id
        }
        redirect(action: 'list')
    } //save

    def show_ajax() {
        def obraContratoInstance = ObraContrato.get(params.id)
        if (!obraContratoInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Obra Contrato con id " + params.id
            redirect(action: "list")
            return
        }
        [obraContratoInstance: obraContratoInstance]
    } //show

    def delete() {
        def obraContratoInstance = ObraContrato.get(params.id)
        if (!obraContratoInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Obra Contrato con id " + params.id
            redirect(action: "list")
            return
        }

        try {
            obraContratoInstance.delete(flush: true)
            flash.clase = "alert-success"
            flash.message =  "Se ha eliminado correctamente Obra Contrato " + obraContratoInstance.id
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.clase = "alert-error"
            flash.message =  "No se pudo eliminar Obra Contrato " + (obraContratoInstance.id ? obraContratoInstance.id : "")
            redirect(action: "list")
        }
    } //delete
} //fin controller
