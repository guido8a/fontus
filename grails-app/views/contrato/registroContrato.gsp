<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 1/14/13
  Time: 11:49 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="janus.ejecucion.TipoPlanilla" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>

    <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>
    <link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">

    <script src="${resource(dir: 'js/jquery/plugins/jgrowl', file: 'jquery.jgrowl.js')}"></script>
    <link href="${resource(dir: 'js/jquery/plugins/jgrowl', file: 'jquery.jgrowl.css')}" rel="stylesheet"/>
    <link href="${resource(dir: 'js/jquery/plugins/jgrowl', file: 'jquery.jgrowl.customThemes.css')}" rel="stylesheet"/>

    <style type="text/css">

    .formato {
        font-weight : bolder;
    }

    .caps {
        text-transform : uppercase;
    }
    </style>


    <title>Registro de Contratos</title>
</head>

<body>

<g:if test="${flash.message}">
    <div class="span12">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </div>
</g:if>


<div class="row">

    %{--<div class="span12 btn-group" role="navigation" style="margin-left: 0px;width: 100%;height: 35px;">--}%
    <div class="span12 btn-group" role="navigation" style="margin-left: 0px;width: 100%;">
        <button class="btn" id="btn-lista"><i class="icon-book"></i> Lista</button>
        <button class="btn" id="btn-nuevo"><i class="icon-plus"></i> Nuevo</button>
        <g:if test="${contrato?.estado != 'R'}">
            <button class="btn" id="btn-aceptar"><i class="icon-save"></i> Guardar</button>
        </g:if>

        <button class="btn" id="btn-cancelar"><i class="icon-undo"></i> Cancelar</button>
        <g:if test="${contrato?.id}">
            <g:if test="${contrato?.id && contrato?.estado != 'R'}">
                <button class="btn" id="btn-borrar"><i class="icon-remove"></i> Eliminar Contrato</button>
            </g:if>
        </g:if>

        <g:if test="${contrato?.estado == 'R'}">
            <g:if test="${planilla == []}">
                <button class="btn" id="btn-desregistrar"><i class="icon-exclamation"></i> Cambiar Estado
                </button>
            </g:if>
        </g:if>
        <g:if test="${contrato?.id && contrato?.estado != 'R'}">
            <button class="btn" id="btn-registrar"><i class="icon-exclamation"></i> Registrar</button>
        </g:if>
    %{--<g:if test="${contrato}">--}%
    %{--<g:link controller="volumenObra" class="btn btn-info" action="volObraContrato" id="${contrato?.id}">--}%
    %{--<i class="icon-list-alt"></i> Ver Rubros--}%
    %{--</g:link>--}%
    %{--</g:if>--}%

    </div>
</div>

<g:form class="registroContrato" name="frm-registroContrato" action="save">

    <g:hiddenField name="id" value="${contrato?.id}"/>


    <g:if test="${contrato?.estado == 'R'}">
        <g:if test="${planilla != []}">
            <div id="alertaEstado" title="Obra en ejecución">
                <p>Este contrato ya posee planillas y se halla en ejecución</p>
            </div>
        </g:if>
    </g:if>

    <fieldset class="" style="position: relative; border-bottom: 1px solid black;">
        <div class="span12" style="margin-top: 20px; margin-left: 40px;">
            <div class="span1 formato">Contrato N°</div>
            <div class="span3"><g:textField name="codigo" maxlength="20" class="codigo required caps" value="${contrato?.codigo}"/></div>
            <div class="span2 formato">Memo de Distribución</div>
            <div class="span3"><g:textField name="memo" class="memo caps allCaps" value="${contrato?.memo}" maxlength="20"/></div>
        </div> <!--DSAFSD-->
    </fieldset>


    <fieldset class="" style="position: relative; padding: 10px;border-bottom: 1px solid black;">

        <p class="css-vertical-text">Contratación</p>
        <div class="linea" style="height: 85%;"></div>
        <div class="span5" style="margin-top: 5px">
            <div class="span1 formato">Oferta</div>
            <div class="span3" id="div_ofertas">
                <elm:select name="oferta.id" id="ofertas" from="${janus.pac.Oferta.list([sort: 'descripcion', order: 'asc'])}" optionKey="id"
                            optionValue="descripcion" noSelection="['-1': 'Seleccione']"
                            class="required" style="width: 300px"
                            optionClass="${{ it.monto + "_" + it.plazo + "_" + it.proveedor.nombre + "_" + it?.fechaEntrega?.format('dd-MM-yyyy')}}" value="${contrato?.oferta?.id}"
                            disabled="${contrato ? 'true' : 'false'}"/>

            </div>
        </div>



        <div class="" style="float: right; width: 700px" align="center">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                <tr>
                    <th style="width: 60px;">
                        Código
                    </th>
                    <th style="width: 330px;">
                        Nombre
                    </th>
                    <th style="width: 80px;">
                        Valor
                    </th>
                    <th style="width: 120px;">
                        Provincia
                    </th>
                    <g:if test="${contrato}">
                        <th style="width: 110px;">
                            Acciones
                        </th>
                    </g:if>
                </tr>
                </thead>
            </table>
            <div style="width: 99.7%;height: 150px;overflow-y: auto;float: right;" id="obras_oferta"></div>
        </div>

        <div class="span5" style="margin-top: 20px" align="center">
            <div class="span1 formato">Contratista</div>

            <div class="span3" style="margin-left: 5px;">
                <g:textField name="contratista" class="contratista" id="contratista" disabled="true" value="${contrato?.oferta?.proveedor}"
                             style="width: 280px; margin-left: 25px;"/>
            </div>
        </div>

        <div class="span5" style="margin-top: 20px" align="center">
            <div class="span3 formato" style="margin-left: -15px">Fecha presentación de la Oferta</div>

            <div class="span2"><g:textField name="fechaPresentacion_name" id="fechaPresentacion" value="${contrato?.oferta?.fechaEntrega?.format('dd-MM-yyyy')}"
                                            disabled="true" style="width: 100px; margin-left: -180px"/></div>
        </div>



        %{--<div class="span5" style="margin-top: 20px" align="center">--}%
        %{--<g:if test="${contrato}">--}%
        %{--<g:link controller="volumenObra" class="btn btn-info" action="volObraContrato" id="${contrato?.id}">--}%
        %{--<i class="icon-list-alt"></i> Ver Rubros--}%
        %{--</g:link>--}%
        %{--</g:if>--}%
        %{--</div>--}%

        <div class="span12" style="margin-top: 5px" align="center">

        </div>

    </fieldset>

    <fieldset class="" style="position: relative; height: 150px; border-bottom: 1px solid black;padding: 10px;">

        <div class="span12" style="margin-top: 10px">

            <div class="span2 formato">Tipo de contrato</div>
            <div class="span4" style="margin-left:-20px"><g:select from="${janus.pac.TipoContrato.list()}" name="tipoContrato.id" class="tipoContrato activo" value="${contrato?.tipoContratoId}" optionKey="id" optionValue="descripcion"/></div>
            <div class="span2 formato" style="margin-left:-20px">Fecha de Suscripción</div>
            <div class="span3"><elm:datepicker name="fechaSubscripcion" class="fechaSuscripcion datepicker required input-small activo" value="${contrato?.fechaSubscripcion}"/></div>

        </div>

        <div class="span12" style="margin-top: 5px">

            <div class="span2 formato">Objeto del Contrato</div>
            <div class="span9" style="margin-left: -20px"><g:textArea name="objeto" class="activo" rows="5" cols="5" style="height: 79px; width: 900px; resize: none" value="${contrato?.objeto}"/></div>

        </div>

    </fieldset>

    <fieldset class="" style="position: relative; padding: 10px;border-bottom: 1px solid black;">

        <div class="span12" style="margin-top: 10px">

            <div class="span2 formato">Multa por retraso de obra</div>

            <div class="span3">
                <g:textField name="multaRetraso" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaRetraso, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/> x 1000
            </div>


            <div class="span2 formato">Multa por no presentación de planilla</div>

            <div class="span3">
                <g:textField name="multaPlanilla" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaPlanilla, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/> x 1000
            </div>

        </div>

        <div class="span12" style="margin-top: 10px">

            <div class="span2 formato">Multa por incumplimiento del cronograma</div>

            <div class="span3">
                <g:textField name="multaIncumplimiento" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaIncumplimiento, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/> x 1000
            </div>

            <div class="span2 formato">Multa por no acatar disposiciones del fiscalizador</div>

            <div class="span3">
                <g:textField name="multaDisposiciones" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaDisposiciones, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/> x 1000
            </div>

        </div>

        <div class="span12" style="margin-top: 10px">

            <div class="span2 formato">Monto del contrato</div>

            <div class="span3"><g:textField name="monto" class="monto activo"
                                            value="${g.formatNumber(number: contrato?.monto, maxFractionDigits: 2, minFractionDigits: 2, locale: 'ec')}"/></div>

            <div class="span2 formato">Plazo</div>

            <div class="span3"><g:textField name="plazo" class="plazo activo" style="width: 50px" maxlength="4"
                                            value="${g.formatNumber(number: contrato?.plazo, maxFractionDigits: 0, minFractionDigits: 0, locale: 'ec')}"/> Días</div>

        </div>

        <div class="span12" style="margin-top: 10px">

            <div class="span2 formato">Anticipo sin reajuste</div>

            <div class="span1">
                <g:textField name="porcentajeAnticipo" class="anticipo activo"
                             value="${g.formatNumber(number: contrato?.porcentajeAnticipo, maxFractionDigits: 0, minFractionDigits: 0, locale: 'ec')}"
                             style="width: 30px; text-align: right"/> %
            </div>

            <div class="span2">
                <g:textField name="anticipo" class="anticipoValor activo" style="width: 105px; text-align: right"
                             value="${g.formatNumber(number: contrato?.anticipo, maxFractionDigits: 2, minFractionDigits: 2, locale: 'ec')}"/>
            </div>


            <g:if test="${contrato?.codigo != null}">
                <div class="span2 formato">Indices 30 días antes de la presentación de la oferta</div>
                <div class="span3"><g:select name="periodoValidez.id" from="${janus.pac.PeriodoValidez.list([sort: 'fechaFin'])}" class="indiceOferta activo" value="${contrato?.periodoInec?.id}" optionValue="descripcion" optionKey="id"/></div>
            </g:if>
            <g:else>
                <div class="span6" id="filaIndice">
                </div>
            </g:else>

        </div>

        <div class="span12" style="margin-top: 10px">

            <div class="span2 formato">Dirección Administradora</div>

            <div class="span3">
                <g:select name="depAdministrador.id" from="${janus.Departamento.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                          value="${contrato?.depAdministradorId}" class="required"/>
            </div>

            <div class="span2 formato">Indirectos</div>

            <div class="span1">
                <g:textField name="indirectos" class="anticipo activo"
                             value="${g.formatNumber(number: contrato?.indirectos, maxFractionDigits: 0, minFractionDigits: 0, locale: 'ec')}"
                             style="width: 30px; text-align: right"/> %
            </div>

            %{--
                        <div class="span 3" style="border-color: #888; border-style: solid; border-width: thin">
                            <div class="span2 formato">La multa por retraso de obra incluye el valor del reajuste</div>

                            <div class="span1">
                                <g:checkBox name="conReajuste" checked="${contrato?.conReajuste == 1 ? 'true' : ''}"/>
                            </div>
                        </div>
            --}%


        </div>

    </fieldset>

</g:form>

<g:if test="${contrato}">
    <div class="navbar navbar-inverse" style="margin-top: 20px;padding-left: 5px;">

        <div class="navbar-inner">
            <div class="botones">

                <ul class="nav">
                    %{--<li>--}%
                    %{--<g:link controller="garantia" action="garantiasContrato" id="">--}%
                    %{--<i class="icon-pencil"></i>Garantías--}%
                    %{--</g:link>--}%
                    %{--<a href="#"><i class="icon-pencil"></i> Garantías</a>--}%
                    %{--<g:link controller="garantia" action="garantiasContrato" id="${contrato?.id}">--}%
                    %{--<i class="icon-pencil"></i> Garantías--}%
                    %{--</g:link>--}%

                    %{--</li>--}%
                    %{--<li><a href="${g.createLink(controller: 'volumenObra', action: 'volObra', id: obra?.id)}"><i class="icon-list-alt"></i>Vol. Obra--}%
                    %{--</a></li>--}%
                    <li>
                    %{--<a href="#" id="btnCronograma">--}%
                        <g:link controller="cronogramaContrato" action="index" id="${contrato?.id}">
                            <i class="icon-th"></i> Cronograma contrato
                        </g:link>
                    %{--</a>--}%
                    </li>
                    %{--<g:if test="${janus.ejecucion.Planilla.countByContratoAndTipoPlanilla(contrato, TipoPlanilla.findByCodigo('A')) > 0 && contrato.oferta.concurso.obra.fechaInicio}">--}%
                    %{--<li>--}%
                    %{--<g:link controller="cronogramaEjecucion" action="index" id="${contrato?.id}">--}%
                    %{--<i class="icon-th"></i>Cronograma ejecucion--}%
                    %{--</g:link>--}%
                    %{--</li>--}%
                    %{--</g:if>--}%
                    %{--<li>--}%
                    %{--<g:link controller="formulaPolinomica" action="coeficientes" id="${obra?.id}">--}%
                    %{--Fórmula Pol.--}%
                    %{--</g:link>--}%
                    %{--</li>--}%
                    %{--<li><a href="#" id="btnFormula"><i class="icon-file"></i>F. Polinómica</a></li>--}%
                    <li>
                        %{--<a href="${g.createLink(controller: 'contrato', action: 'polinomicaContrato', id: contrato?.id)}">--}%
                        %{--<i class="icon-calendar"></i> F. Polinómica--}%
                        %{--</a>--}%
                        <g:link action="copiarPolinomica" id="${contrato?.id}"><i class="icon-superscript"></i> F. polinómica</g:link>
                    </li>

                    <li>
                        <g:link controller="documentoProceso" action="list" id="${contrato?.oferta?.concursoId}" params="[contrato: contrato?.id, show: 1]">
                            <i class="icon-book"></i> Biblioteca
                        </g:link>
                    </li>

                    <li>
                        <g:link controller="contrato" action="asignar" id="${contrato?.oferta?.concursoId}" params="[contrato: contrato?.id, show: 1]">
                            <i class="icon-plus"></i> Asignar F. Polinómica
                        </g:link>
                    </li>

                    %{--<li>--}%
                    %{--<g:link controller="planilla" action="list" id="${contrato?.id}">--}%
                    %{--<i class=" icon-file-alt"></i>Planillas--}%
                    %{--</g:link>--}%
                    %{--</li>--}%

                    %{--<li>--}%
                    %{--<g:link action="fechasPedidoRecepcion" id="${contrato?.id}">--}%
                    %{--<i class=" icon-calendar-empty"></i>Fechas de pedido de recepción--}%
                    %{--</g:link>--}%
                    %{--</li>--}%

                </ul>

            </div>
        </div>

    </div>
</g:if>


%{--<g:if test="${contrato}">--}%
%{--<div class="navbar navbar-inverse" style="margin-top: 20px;padding-left: 5px;" align="center">--}%

%{--<div class="navbar-inner">--}%
%{--<div class="botones">--}%

%{--<ul class="nav">--}%
%{--<li>--}%
%{--<g:link controller="garantia" action="garantiasContrato" id="">--}%
%{--<i class="icon-pencil"></i>Garantías--}%
%{--</g:link>--}%
%{--<a href="#"><i class="icon-pencil"></i> Garantías</a>--}%
%{--<g:link controller="garantia" action="garantiasContrato" id="${contrato?.id}">--}%
%{--<i class="icon-pencil"></i> Garantías--}%
%{--</g:link>--}%

%{--</li>--}%
%{--<li><a href="${g.createLink(controller: 'volumenObra', action: 'volObra', id: obra?.id)}"><i class="icon-list-alt"></i>Vol. Obra--}%
%{--</a></li>--}%
%{--<li>--}%
%{--<a href="#" id="btnCronograma">--}%
%{--<g:link controller="cronogramaContrato" action="index" id="${contrato?.id}">--}%
%{--<i class="icon-th"></i>Cronograma contrato--}%
%{--</g:link>--}%
%{--</a>--}%
%{--</li>--}%
%{--<g:if test="${janus.ejecucion.Planilla.countByContratoAndTipoPlanilla(contrato, TipoPlanilla.findByCodigo('A')) > 0 && contrato.oferta.concurso.obra.fechaInicio}">--}%
%{--<li>--}%
%{--<g:link controller="cronogramaEjecucion" action="index" id="${contrato?.id}">--}%
%{--<i class="icon-th"></i>Cronograma ejecucion--}%
%{--</g:link>--}%
%{--</li>--}%
%{--</g:if>--}%
%{--<li>--}%
%{--<g:link controller="formulaPolinomica" action="coeficientes" id="${obra?.id}">--}%
%{--Fórmula Pol.--}%
%{--</g:link>--}%
%{--</li>--}%
%{--<li><a href="#" id="btnFormula"><i class="icon-file"></i>F. Polinómica</a></li>--}%
%{--<li>--}%
%{--<a href="${g.createLink(controller: 'contrato', action: 'polinomicaContrato', id: contrato?.id)}">--}%
%{--<i class="icon-calendar"></i> F. Polinómica--}%
%{--</a>--}%
%{--</li>--}%

%{--<li>--}%
%{--<g:link controller="documentoProceso" action="list" id="${contrato?.oferta?.concursoId}" params="[contrato: contrato?.id]">--}%
%{--<i class="icon-book"></i>Biblioteca--}%
%{--</g:link>--}%
%{--</li>--}%

%{--<li>--}%
%{--<g:link controller="planilla" action="list" id="${contrato?.id}">--}%
%{--<i class=" icon-file-alt"></i>Planillas--}%
%{--</g:link>--}%
%{--</li>--}%

%{--</ul>--}%

%{--</div>--}%
%{--</div>--}%

%{--</div>--}%
%{--</g:if>--}%


<div class="modal hide fade mediumModal" id="modal-var" style="overflow: hidden">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">x</button>

        <h3 id="modal_tittle_var">

        </h3>

    </div>

    <div class="modal-body" id="modal_body_var">

    </div>

    <div class="modal-footer" id="modal_footer_var">

    </div>

</div>

<div class="modal grandote hide fade" id="modal-busqueda" style="overflow: hidden">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">x</button>
        <h3 id="modalTitle_busqueda"></h3>
    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="contratos" value="" accion="buscarContrato" controlador="contrato" campos="${campos}" label="Contrato" tipo="lista"/>
    </div>
    <div class="modal-footer" id="modalFooter_busqueda">
    </div>

</div>



%{--</div>--}%


<div id="borrarContrato">

    <fieldset>
        <div class="span3">
            Está seguro de que desea borrar el contrato: <div style="font-weight: bold;">${contrato?.codigo} ?</div>

        </div>
    </fieldset>
</div>

<script type="text/javascript">



    if('${contrato}'){
        cargarTablaObras(${contrato?.id})
    }


    function cargarTablaObras (contrato) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'contrato', action: 'tablaObras_ajax')}",
            data:{
                oferta: '${contrato?.oferta?.id}',
                contrato: contrato
            },
            success: function (msg){
                $("#obras_oferta").html(msg)
            }
        });
    }

    function updateAnticipo() {
        var porcentaje = $("#porcentajeAnticipo").val();
        var monto = $("#monto").val().replace(",", "");
        var anticipoValor = (porcentaje * (monto)) / 100;
//                $("#anticipo").val(number_format(anticipoValor, 2, ".", ","));
//                $("#monto").val(number_format(monto, 2, ".", ","));
    }

    $("#frm-registroContrato").validate();

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
        ev.keyCode == 190 || ev.keyCode == 110 ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39);
    }
    function validarInt(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39);
    }

    $(".number").keydown(function (ev) {
        return validarInt(ev);
    });

    $("#plazo").keydown(function (ev) {

        return validarInt(ev);

    }).keyup(function () {

        var enteros = $(this).val();

    });

    $("#monto").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();

    });

    $("#porcentajeAnticipo").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();

        if (parseFloat(enteros) > 100) {

            $(this).val(100)

        }
        updateAnticipo();

    });


    $("#indirectos").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();

        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
    });


    $("#anticipo").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();
        updateAnticipo();
//                        var porcentaje = $("#porcentajeAnticipo").val();
//
//                        var monto = $("#monto").val();
//
//                        var anticipoValor = (porcentaje * (monto)) / 100;
//
//                        $("#anticipo").val(number_format(anticipoValor, 2, ".", ""));

    }).click(function () {
        updateAnticipo();
//                        var porcentaje = $("#porcentajeAnticipo").val();
//
//                        var monto = $("#monto").val();
//
//                        var anticipoValor = (porcentaje * (monto)) / 100;
//
//                        $("#anticipo").val(number_format(anticipoValor, 2, ".", ","));

    });

    $("#financiamiento").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();

    });


    function enviarObra() {
        var data = "";
        $("#buscarDialog").hide();
        $("#spinner").show();
        $(".crit").each(function () {
            data += "&campos=" + $(this).attr("campo");
            data += "&operadores=" + $(this).attr("operador");
            data += "&criterios=" + $(this).attr("criterio");
        });
        if (data.length < 2) {
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({type : "POST", url : "${g.createLink(controller: 'contrato',action:'buscarObra')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });

    }

    function cargarCombo() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST", url : "${g.createLink(controller: 'contrato',action:'cargarOfertas')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#div_ofertas").html(msg)
                }
            });

        }

    }

    function cargarCanton() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST", url : "${g.createLink(controller: 'contrato',action:'cargarCanton')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#canton").val(msg)
                }
            });

        }
    }

    $("#obraCodigo").dblclick(function () {
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        $("#modalTitle_busqueda").html("Lista de obras");
        $("#modalFooter_busqueda").html("").append(btnOk);
        $("#modal-busqueda").modal("show");
        $("#contenidoBuscador").html("")
        $("#buscarDialog").unbind("click")
        $("#buscarDialog").bind("click", enviarObra)

    });

    $("#btn-lista").click(function () {

        $("#btn-cancelar").attr("disabled", true);
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        $("#modalTitle_busqueda").html("Lista de Contratos");
        $("#modalFooter_busqueda").html("").append(btnOk);
        $("#buscarDialog").unbind("click")
        $("#buscarDialog").bind("click", enviar)
        $("#contenidoBuscador").html("")
        $("#modal-busqueda").modal("show");

    });

    $("#btn-nuevo").click(function () {

        location.href = "${createLink(action: 'registroContrato')}"
    });

    $("#obraCodigo").focus(function () {

        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        $("#modalTitle_busquedaOferta").html("Lista de Obras");
        $("#modalFooter_busquedaOferta").html("").append(btnOk);
        $("#modal-busquedaOferta").modal("show");

    });

    $("#btn-salir").click(function () {
        location.href = "${g.createLink(action: 'index', controller: "inicio")}";
    });

    $("#btn-aceptar").click(function () {

        if($(".indiceOferta").val()){
            $("#frm-registroContrato").submit();
        }else{
            alert("No ha seleccionado un indice!")
        }
    });

    $("#btn-registrar").click(function () {
        var $btn = $(this).clone(true);
        $(this).replaceWith(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'saveRegistrar')}",
            data    : "id=${contrato?.id}",
            success : function (msg) {
                var parts = msg.split("_");
                if (parts[0] == "ok") {
                    alert("Contrato registrado");
                    location.href = "${g.createLink(controller: 'contrato', action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
                } else {
                    spinner.replaceWith($btn);
                    $.box({
                        imageClass : "box_info",
                        title      : "Alerta",
                        text       : parts[1],
                        iconClose  : false,
                        dialog     : {
                            width         : 400,
                            resizable     : false,
                            draggable     : false,
                            closeOnEscape : false,
                            buttons       : {
                                "Aceptar" : function () {
                                }
                            }
                        }
                    });
                }
            }
        });
//

    });

    $("#btn-desregistrar").click(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'cambiarEstado')}",
            data    : "id=${contrato?.id}",
            success : function (msg) {
                location.href = "${g.createLink(controller: 'contrato', action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
            }
        });
    });

    $("#btn-cancelar").click(function () {
        if (${contrato?.id == null}) {
            location.href = "${g.createLink(action: 'registroContrato')}";
        } else {
            location.href = "${g.createLink(action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
        }
    });

    $("#btn-borrar").click(function () {
        if (${contrato?.codigo != null}) {
            $("#borrarContrato").dialog("open")
        }
    });

    $("#borrarContrato").dialog({

        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 220,
        position  : 'center',
        title     : 'Eliminar Contrato',
        buttons   : {
            "Aceptar"  : function () {

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action: 'delete')}",
                    data    : "id=${contrato?.id}",
                    success : function (msg) {

                        $("#borrarContrato").dialog("close");
                        location.href = "${g.createLink(action: 'registroContrato')}";
                    }
                });
//

//
            },
            "Cancelar" : function () {
                $("#borrarContrato").dialog("close");
            }
        }

    });

    /* muestra la X en el botón de cerrar */
    $(function() {
        if(${contrato?.estado == 'R'}) {
            $("#alertaEstado").dialog({
                modal: true,
                open: function() {
                    $(this).closest(".ui-dialog")
                            .find(".ui-dialog-titlebar-close")
                            .removeClass("ui-dialog-titlebar-close")
                            .html("x");
                }
            });
        }
    });

    //            $("#anticipo").val(number_format(anticipoValor, 2, ".", ","));
    //            var monto = $("#monto").val().replace(",", "");
    //            var anticipo = $("#anticipo").val().replace(",", "");
    //            $("#monto").val(number_format(monto, 2, ".", ","));
    //            $("#anticipo").val(number_format(anticipo, 2, ".", ","));





    $("#ofertas").change(function () {
        if ($(this).val() != "-1") {
            var $selected = $("#ofertas option:selected");
            var idOferta = $selected.val()
            var cla = $selected.attr("class");
            var parte = cla.split("_");
            var pro = parte[2];
            var fecha = parte[3];
//                    console.log($selected.val())
//            $("#contratista").val($selected.text());
            $("#contratista").val(pro);
            $("#fechaPresentacion").val(fecha)
            %{--$.ajax({--}%
            %{--type    : "POST",--}%
            %{--url     : "${g.createLink(action:'getFecha')}",--}%
            %{--data    : {id : idOferta--}%
            %{--},--}%
            %{--success : function (msg) {--}%
            %{--$("#filaFecha").html(msg);--}%

            %{--}--}%
            %{--});--}%

            $.ajax({
                type    : "POST",
                url     : "${g.createLink(action:'getIndice')}",
                data    : {id : idOferta
                },
                success : function (msg) {
                    $("#filaIndice").html(msg);
                }
            });

            $.ajax({
                type: 'POST',
                url: "${createLink(controller: 'contrato', action: 'tablaObras_ajax')}",
                data:{
                    oferta: idOferta,
                    band: 1
                },
                success: function (msg){
                    $("#obras_oferta").html(msg)
                }
            });

            $.ajax({
                type: 'POST',
                url: "${createLink(controller: 'contrato', action: 'calcularMonto_ajax')}",
                data:{
                    oferta: idOferta
                },
                success: function (msg){
//                    console.log("msg " + msg)
                    $("#monto").val(number_format(msg, 2,"."));
                }
            });


            var cl = $selected.attr("class");
            var parts = cl.split("_");
            var m = parts[0];
            var p = parts[1];
//            $("#monto").val(number_format(m, 2,"."));
            $("#plazo").val(p);
        }
        else {
            $("#contratista").val("");
            $("#fechaPresentacion").val('');
            $("#obras_oferta").html('')
        }
    });


</script>

</body>
</html>