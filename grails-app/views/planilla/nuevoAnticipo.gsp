<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 04/01/17
  Time: 10:22
--%>

<%@ page import="janus.ejecucion.TipoPlanilla; janus.ejecucion.Planilla" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        <g:if test="${planillaInstance?.id}">
            Editar planilla
        </g:if>
        <g:else>
            Nueva Planilla
        </g:else>
    </title>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>

    <style type="text/css">
    .formato {
        font-weight: bolder;
    }

    select.label-important, textarea.label-important {
        background: none !important;
        color: #555 !important;
        text-shadow: none !important;
    }
    </style>
</head>

<body>

%{--<g:if test="${suspensiones.size() != 0}">--}%
%{--<div class="btn-toolbar" style="margin-bottom: 20px;">--}%
%{--<div class="btn-group">--}%
%{--<g:link controller="contrato" action="verContrato" id="${contrato.id}" class="btn">--}%
%{--<i class="icon-arrow-left"></i>--}%
%{--Regresar--}%
%{--</g:link>--}%
%{--</div>--}%
%{--</div>--}%

%{--<div class="alert alert-danger" style="font-size: large; font-weight: bold;">--}%
%{--La ejecucion de la obra está suspendida desde ${ini*.format("dd-MM-yyyy")}, no puede generar planillas.--}%
%{--</div>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<g:set var="planillaAnticipo"--}%
%{--value="${Planilla.findByTipoPlanillaAndContrato(TipoPlanilla.findByCodigo('A'), contrato)}"/>--}%

%{--<g:set var="periodosOk" value="${[]}"/>--}%
%{--<g:if test="${planillaAnticipo}">--}%
%{--<g:set var="periodosOk" value="${janus.ejecucion.Planilla.findAllByTipoPlanilla(TipoPlanilla.findByCodigo('A'))}"/>--}%
%{--</g:if>--}%

%{--<g:if test="${tipos.find { it.codigo == 'A' } || periodosOk.size() > 0}">--}%
<div class="btn-toolbar" style="margin-bottom: 20px;">
    <div class="btn-group">
        %{--<g:link action="list" id="${contrato.id}" class="btn">--}%
        %{--<i class="icon-arrow-left"></i>--}%
        %{--Cancelar--}%
        %{--</g:link>--}%



        <a href="#" id="btnRegresar" class="btn">
            <i class="icon-arrow-left"></i>
            Regresar
        </a>

        %{--<g:if test="${(anticipoPagado && !liquidado) || (planillaInstance?.id && planillaInstance.fechaMemoSalidaPlanilla == null) || (tipos.find{it.codigo == 'A'} && planillaInstance?.fechaMemoSalidaPlanilla == null)}">--}%
        <a href="#" id="btnSave" class="btn btn-success">
            <i class="icon-save"></i>
            Guardar
        </a>
        <a href="#" id="btnPago" class="btn btn-info">
            <i class="icon-save"></i>
            Pedir Pago
        </a>
        %{--</g:if>--}%
    </div>
</div>

<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>

%{--<g:if test="${anticipoPagado || planillaInstance?.id ||(tipos.find{it.codigo == 'A'} && planillaInstance?.fechaMemoSalidaPlanilla == null)}">--}%
%{--<g:if test="${!liquidado}">--}%
%{--<g:form name="frmSave-Planilla" action="save">--}%
<g:form name="frmSave-Planilla" action="saveAnticipo">
    <fieldset>
        %{--<g:hiddenField name="id" value="${planillaInstance?.id}"/>--}%
        <g:hiddenField id="contrato" name="contrato.id" value="${contrato?.id}"/>

        <div class="row">
            <div class='span2 formato'>
                Tipo de Planilla
            </div>

            <div class="span10">
                %{--<g:if test="${planillaInstance?.id}">--}%
                %{--<g:if test="${planillaInstance?.tipoPlanilla.toString() != 'A'}">--}%
                %{--${planillaInstance?.tipoPlanilla?.nombre} <span--}%
                %{--style="margin-left: 290px;">Planillado del: ${planillaInstance?.fechaInicio?.format('dd-MM-yyyy')} Hasta: ${planillaInstance?.fechaFin?.format('dd-MM-yyyy')}</span>--}%
                %{--</g:if>--}%
                %{--<g:else>--}%
                %{--${planillaInstance?.tipoPlanilla?.nombre}--}%
                %{--</g:else>--}%
                %{--</g:if>--}%


                <g:textField name="tipoP" value="${"ANTICIPO"}" style="text-align: center" class="span3" readonly="true"/>


            </div>

            %{--<div class="span4">--}%
            %{--<g:if test="${!planillaInstance?.id}">--}%
            %{--<g:select id="tipoPlanilla" name="tipoPlanilla.id" from="${tipos}" optionKey="id"--}%
            %{--optionValue="nombre"--}%
            %{--class="many-to-one span3 required"--}%
            %{--value="${planillaInstance?.tipoPlanilla?.id}"/>--}%
            %{--<span class="mandatory">*</span>--}%

            %{--<p class="help-block ui-helper-hidden"></p>--}%
            %{--</g:if>--}%
            %{--</div>--}%
            %{--<g:if test="${!planillaInstance?.id && !(tipos.find { it.codigo == 'A' })}">--}%

            %{--<div class="span2 formato periodo hide">--}%
            %{--Periodo--}%
            %{--</div>--}%

            %{--<div class="span4 periodo hide">--}%
            %{--<g:select id="periodoPlanilla" name="periodoPlanilla" from="${periodos}"--}%
            %{--optionKey="key" class="many-to-one span3"--}%
            %{--optionValue="value"/>--}%
            %{--<span class="mandatory">*</span>--}%

            %{--<p class="help-block ui-helper-hidden"></p>--}%
            %{--</div>--}%
            %{--</g:if>--}%
        </div>



        %{--<div class="row">--}%
        %{--<g:if test="${planillaInstance?.id && planillaInstance?.tipoPlanilla?.codigo == "C"}">--}%
        %{--<div class='span2 formato hide planillaAsociada'>--}%
        %{--Planilla Asociada--}%
        %{--</div>--}%
        %{--<div class="span10 hide planillaAsociada">--}%
        %{--<g:select name="asociada" from="${planillas}" optionKey="id" style="width: 600px"--}%
        %{--value="${planillaInstance?.padreCosto?.id}"  noSelection="['null': 'Sin planilla asociada']"/>--}%
        %{--</div>--}%
        %{--</g:if>--}%
        %{--</div>--}%

        <div class="row">

            <div class="span2 formato">
                Número planilla
            </div>

            <div class="span4">
                %{--<g:textField name="numero" maxlength="30" class="span3 required allCaps"--}%
                %{--value="${fieldValue(bean: planillaInstance, field: 'numero')}"/>--}%
                %{--<p class="help-block ui-helper-hidden"></p>--}%
                <g:textField name="numero" maxlength="30" class="span3 required allCaps" value="${planilla?.numero}"/>
                <span class="mandatory">*</span>
                <p class="help-block ui-helper-hidden"></p>
            </div>

            %{--<div class="span2 formato">--}%
            %{--Fiscalizador--}%
            %{--</div>--}%

            %{--<div class="span4">--}%
            %{--${contrato.fiscalizador?.titulo} ${contrato.fiscalizador?.nombre} ${contrato.fiscalizador?.apellido}--}%
            %{--<p class="help-block ui-helper-hidden"></p>--}%
            %{--</div>--}%
        </div>

        <div class="row">
            %{--<div class="span2 formato">--}%
            %{--<g:if test="${tipos.find { it.codigo == 'A' }}">--}%
            %{--Memo de anticipo--}%
            %{--</g:if>--}%
            %{--<g:else>--}%
            %{--Oficio de entrada--}%
            %{--</g:else>--}%
            %{--</div>--}%

            %{--<div class="span4">--}%
            %{--<g:textField name="oficioEntradaPlanilla" class="span3 required allCaps"--}%
            %{--value="${planillaInstance.oficioEntradaPlanilla}" maxlength="20"/>--}%
            %{--<span class="mandatory">*</span>--}%

            %{--<p class="help-block ui-helper-hidden"></p>--}%
            %{--</div>--}%

            <div class="span2 formato">
                Fecha de
                %{--<g:if test="${tipos.find { it.codigo == 'A' }}">--}%
                memo de anticipo
                %{--</g:if>--}%
                %{--<g:else>--}%
                %{--oficio de entrada--}%
                %{--</g:else>--}%
            </div>

            <div class="span4">
                %{--<elm:datepicker name="fechaOficioEntradaPlanilla" class=" span3 required"--}%
                %{--value="${planillaInstance?.fechaOficioEntradaPlanilla}"--}%
                %{--minDate="new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0)"--}%
                %{--maxDate="new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0)"/>--}%

                <elm:datepicker name="fechaOficioEntradaPlanilla" class=" span3 required"
                                value="${fecha2}"
                                minDate="new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0)"
                                maxDate="new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0)"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">

            <div class="span2 formato">
                Fecha Ingreso
            </div>

            <div class="span4">
                %{--<elm:datepicker name="fechaIngreso" class=" span3 required" onSelect="fechas"--}%
                %{--value="${planillaInstance?.fechaIngreso}"--}%
                %{--minDate="new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0)"--}%
                %{--maxDate="new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0)"/>--}%

                <elm:datepicker name="fechaIngreso" class=" span3 required"
                                value="${fecha1}"
                                minDate="new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0)"
                                maxDate="new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0)"/>
                <span class="mandatory">*</span>

                <p class="help-block ui-helper-hidden"></p>
            </div>

            %{--<div class="span2 hide presentacion formato">--}%
            %{--Fecha Presentacion--}%
            %{--</div>--}%

            %{--<div class="span4 hide presentacion">--}%
            %{--<elm:datepicker name="fechaPresentacion" class=" span3 required"--}%
            %{--value="${planillaInstance?.fechaPresentacion}"--}%
            %{--minDate="new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0)"--}%
            %{--maxDate="new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0)"/>--}%
            %{--<span class="mandatory">*</span>--}%

            %{--<p class="help-block ui-helper-hidden"></p>--}%
            %{--</div>--}%
        </div>


        %{--<div class="row">--}%
        %{--<div class="span2 formato">--}%
        %{--Periodo para el reajuste--}%
        %{--</div>--}%

        %{--<div class="span4">--}%
        %{--<g:select name="periodoIndices.id"--}%
        %{--from="${janus.ejecucion.PeriodosInec.list([sort: 'fechaFin', order: 'desc', max: 20])}"--}%
        %{--class="span4" optionKey="id" style="width: 100%" value="${planillaInstance.periodoIndices?.id}"></g:select>--}%
        %{--</div>--}%
        %{--</div>--}%

        %{--<g:if test="${!(esAnticipo || planillaInstance?.tipoPlanilla?.codigo == 'A')}">   --}%%{-- no es anticipo--}%
        %{--<div class="row">--}%
        %{--<div class='span2 formato'>--}%
        %{--Fórmula Polinómica a utilizar--}%
        %{--</div>--}%

        %{--<div class="span6">--}%
        %{--<g:select id="formulaPolinomicaReajuste" name="formulaPolinomicaReajuste.id" from="${formulas}" optionKey="id"--}%
        %{--optionValue="descripcion"--}%
        %{--class="many-to-one span5 required"--}%
        %{--value="${planillaInstance?.formulaPolinomicaReajuste?.id}"/>--}%
        %{--<span class="mandatory">*</span>--}%

        %{--<p class="help-block ui-helper-hidden"></p>--}%
        %{--</div>--}%
        %{--</div>--}%


        %{--<div class="row hide" style="margin-bottom: 10px;" id="divMultaDisp">--}%
        %{--<div class='span2 formato'>--}%
        %{--Multa por no acatar las disposiciones del fiscalizador--}%
        %{--</div>--}%

        %{--<div class="span4">--}%
        %{--<g:field type="number" name="diasMultaDisposiciones"--}%
        %{--class="input-mini required digits"--}%
        %{--value="${planillaInstance.diasMultaDisposiciones}" maxlength="3"/> días--}%
        %{--</div>--}%

        %{--<div class='span2 formato'>--}%
        %{--Avance físico--}%
        %{--</div>--}%

        %{--<div class="span4">--}%
        %{--<g:field type="number" name="avanceFisico" class="input-mini required number"--}%
        %{--value="${planillaInstance.avanceFisico}" max="100"/> %--}%
        %{--<p class="help-block ui-helper-hidden"></p>--}%
        %{--</div>--}%
        %{--</div>--}%
        %{--</g:if>--}%

        %{--<g:if test="${esAnticipo}">--}%
        <div class="row" style="margin-bottom: 10px;">
            <div class='span2 formato'>
                Valor
            </div>

            <div class="span4">
                $<g:formatNumber number="${contrato.anticipo}" minFractionDigits="2"
                                 maxFractionDigits="2" format="##,##0" locale="ec"/>
                (anticipo del <g:formatNumber number="${contrato.porcentajeAnticipo}"
                                              maxFractionDigits="0" minFractionDigits="0"/>%
                de $<g:formatNumber number="${contrato.monto}" minFractionDigits="2"
                                    maxFractionDigits="2" format="##,##0" locale="ec"/>)

            </div>
        </div>
        %{--</g:if>--}%

        <div class="row">
            <div class="span2 formato">
                Descripción
            </div>

            <div class="span10">
                %{--<g:textArea name="descripcion" cols="40" rows="2" maxlength="254" class="span9 required"--}%
                %{--value="${planillaInstance?.descripcion}" style="resize: none;"/>--}%

                <g:textArea name="descripcion" cols="40" rows="2" maxlength="254" class="span9 required"
                            value="${planilla?.descripcion}" style="resize: none;"/>
                <span class="mandatory">*</span>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>
        %{--<g:if test="${!esAnticipo}">--}%
        %{--<div class="row hide" style="margin-bottom: 10px;" id="divMulta">--}%
        %{--<div class='span2 formato'>--}%
        %{--Multa--}%
        %{--</div>--}%

        %{--<div class="span5">--}%
        %{--<input type="text" name="descripcionMulta"--}%
        %{--value="${planillaInstance?.descripcionMulta}" style="width: 100%">--}%
        %{--</div>--}%

        %{--<div class='span1 formato'>--}%
        %{--Monto--}%
        %{--</div>--}%

        %{--<div class="span3">--}%
        %{--<input type="text" name="multaEspecial" value="${planillaInstance?.multaEspecial}">--}%
        %{--</div>--}%
        %{--</div>--}%
        %{--</g:if>--}%


        <div class="row">
            <div class="span2 formato">
                Observaciones
            </div>

            <div class="span10">
                %{--<g:textArea name="observaciones" maxlength="127" class="span9"--}%
                %{--value="${planillaInstance?.observaciones}"/>--}%

                <g:textArea name="observaciones" maxlength="127" class="span9"
                            value="${planilla?.observaciones}"/>

                <p class="help-block ui-helper-hidden"></p>
            </div>

        </div>

        %{--<div class="row" style="margin-bottom: 10px;" id="divNoPago">--}%
        %{--<div class='span2 formato'>--}%
        %{--Nota de descuento--}%
        %{--</div>--}%

        %{--<div class="span6">--}%
        %{--<g:textArea maxlength="255" name="noPago" class="span6"--}%
        %{--value="${planillaInstance?.noPago}"/>--}%
        %{--</div>--}%

        %{--<div class='span1 formato'>--}%
        %{--Valor--}%
        %{--</div>--}%

        %{--<div class="span3">--}%
        %{--<input type="text" name="noPagoValor" value="${planillaInstance?.noPagoValor}">--}%
        %{--</div>--}%
        %{--</div>--}%


    </fieldset>
</g:form>
%{--</g:if>--}%
%{--<g:else>--}%
%{--<div class="alert alert-warning">--}%
%{--<h4>Alerta</h4>--}%

%{--<p style="margin-top: 10px;">--}%
%{--<i class="icon-warning-sign icon-2x pull-left"></i>--}%
%{--Ya se ha efectuado la planilla de liquidación del reajuste, no puede crear nuevas planillas.--}%
%{--</p>--}%
%{--</div>--}%
%{--</g:else>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<div class="alert alert-warning">--}%
%{--<h4>Alerta</h4>--}%

%{--<p style="margin-top: 10px;">--}%
%{--<i class="icon-warning-sign icon-2x pull-left"></i>--}%
%{--La planilla de anticipo no ha sido pagada. Por favor páguela para continuar.--}%
%{--</p>--}%
%{--</div>--}%
%{--</g:else>--}%
%{--</g:if>--}%
%{--<g:else>--}%
%{--<div class="alert alert-danger">--}%
%{--<h3>Alerta: ha ocurrido un error</h3>--}%

%{--<p>--}%
%{--El contrato no posee los períodos necesarios para crear planillas. <br/>--}%
%{--Posiblemente al generar la planilla de anticipo no se encontraron valores de índice para algunos rubros.<br/>--}%
%{--Por favor revise y corrija esto para intentar nuevamente.<br/>--}%
%{--</p>--}%
%{--<g:link action="list" id="${contrato.id}" class="btn btn-danger">Regresar</g:link>--}%
%{--</div>--}%
%{--</g:else>--}%


<div class="modal hide fade mediumModal" id="modal-Planilla">
    <div class="modal-header" id="modalHeader">
        <button type="button" class="close darker" data-dismiss="modal">
            <i class="icon-remove-circle"></i>
        </button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>


<script type="text/javascript">

    $("#btnRegresar").click(function () {
        location.href="${createLink(controller: 'contrato', action: 'verContrato')}?contrato=" + '${contrato?.id}'
    });

    $("#btnPago").click(function () {
            var $btn = $(this);
//            var tipo = $btn.data("tipo").toString();
            $.ajax({
                type: "POST",
                url: "${createLink(action:'pagoAnticipo_ajax')}",
                data: {
//                    id: $btn.data("id"),
//                    tipo: tipo
                    contrato: '${contrato?.id}'
                },
                success: function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });
                    $("#modalTitle").html($btn.text());

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");

                    if (msg == "NO") {
                        $("#modalBody").html("Ha ocurrido un error: No se encontró un administrador activo para el contrato.<br/>Por favor asigne uno desde la página del contrato en la opción Administrador.");
                        btnOk.text("Aceptar");
                        $("#modalFooter").html("").append(btnOk);
                    } else {
                        $("#modalBody").html(msg);
                        if (msg.startsWith("No")) {
                            btnOk.text("Aceptar");
                            $("#modalFooter").html("").append(btnOk);
                        } else {
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                        }
                    }

                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
    });

    %{--function validarNum(ev) {--}%
    %{--/*--}%
    %{--48-57      -> numeros--}%
    %{--96-105     -> teclado numerico--}%
    %{--188        -> , (coma)--}%
    %{--190        -> . (punto) teclado--}%
    %{--110        -> . (punto) teclado numerico--}%
    %{--8          -> backspace--}%
    %{--46         -> delete--}%
    %{--9          -> tab--}%
    %{--37         -> flecha izq--}%
    %{--39         -> flecha der--}%
    %{--*/--}%
    %{--return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||--}%
    %{--(ev.keyCode >= 96 && ev.keyCode <= 105) ||--}%
    %{--ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||--}%
    %{--ev.keyCode == 37 || ev.keyCode == 39);--}%
    %{--}--}%

    %{--$("#avanceFisico").keydown(function (ev) {--}%

    %{--return validarNum(ev);--}%

    %{--}).keyup(function () {--}%
    %{--var enteros = $(this).val();--}%

    %{--if (parseFloat(enteros) > 100) {--}%
    %{--$(this).val(100)--}%
    %{--}--}%
    %{--if (parseFloat(enteros) <= 0) {--}%
    %{--$(this).val(0)--}%
    %{--}--}%
    %{--});--}%

    %{--$("#diasMultaDisposiciones").keydown(function (ev) {--}%
    %{--return validarNum(ev);--}%
    %{--}).keyup(function () {--}%
    %{--var enteros = $(this).val();--}%

    %{--if (parseFloat(enteros) > 1000) {--}%
    %{--$(this).val(999)--}%
    %{--}--}%
    %{--if (parseFloat(enteros) <= 0) {--}%
    %{--$(this).val(0)--}%
    %{--}--}%
    %{--});--}%

    %{--function checkPeriodo() {--}%
    %{--var tppl = $("#tipoPlanilla").val()--}%
    %{--var tp = "${planillaInstance?.tipoPlanilla?.id}"--}%
    %{--if(isNaN(tp)) {--}%
    %{--tp = 0--}%
    %{--}--}%

    %{--if (tppl == "3" || tppl == "9" || (tp == "3" || tp == "9")) { //avance--}%
    %{--$(".periodo,.presentacion,#divMultaDisp, #divMulta").show();--}%
    %{--} else {--}%
    %{--$("#divMultaDisp").hide();--}%
    %{--$("#divMulta").hide();--}%
    %{--if (tppl == "1" || tppl == "2") {--}%
    %{--$(".periodo").hide();--}%
    %{--$(".presentacion").hide();--}%
    %{--} else if (tppl == "5" || tppl == "6") {--}%
    %{--$(".periodo").hide();--}%
    %{--$(".presentacion").show();--}%
    %{--}--}%
    %{--}--}%



    %{--}--}%

    %{--function cargarAsociada () {--}%

    %{--var tppl = $("#tipoPlanilla").val();--}%

    %{--if(${planillaInstance?.id && planillaInstance?.tipoPlanilla?.codigo == 'C'}){--}%
    %{--$(".planillaAsociada").show();--}%
    %{--}else{--}%
    %{--if(tppl == '5'){--}%
    %{--$(".planillaAsociada").show();--}%
    %{--}else{--}%
    %{--$(".planillaAsociada").hide();--}%
    %{--}--}%
    %{--}--}%




    %{--}--}%

    %{--function fechas() {--}%
    %{--if ($.trim($("#fechaPresentacion").val()) == "") {--}%
    %{--$("#fechaPresentacion").val($("#fechaIngreso").val());--}%
    %{--}--}%
    %{--}--}%

    %{--$(function () {--}%
    %{--checkPeriodo();--}%
    %{--cargarAsociada();--}%

    %{--$("#frmSave-Planilla").validate({--}%
    %{--errorPlacement: function (error, element) {--}%
    %{--element.parent().find(".help-block").html(error).show();--}%
    %{--},--}%
    %{--errorClass: "label label-important"--}%
    %{--});--}%

    $("#btnSave").click(function () {
        if ($("#frmSave-Planilla").valid()) {
            $(this).replaceWith(spinner);
            $("#frmSave-Planilla").submit();
        }
    });

    %{--$("#tipoPlanilla").change(function () {--}%
    %{--checkPeriodo();--}%
    %{--cargarAsociada();--}%
    %{--});--}%
    %{--});--}%

</script>
%{--</g:else>--}%
</body>
</html>