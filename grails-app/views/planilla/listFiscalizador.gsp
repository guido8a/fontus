<%@ page import="janus.ejecucion.TipoPlanilla; janus.ejecucion.Planilla" %>
<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Planillas
        </title>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
    </head>

    <body>

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

        <g:set var="cont" value="${1}"/>
        <g:set var="prej" value="${janus.pac.PeriodoEjecucion.findAllByObra(obra, [sort: 'fechaFin', order: 'desc'])}"/>

        <g:set var="anticipo" value="${janus.ejecucion.Planilla.countByContratoAndTipoPlanilla(contrato, TipoPlanilla.findByCodigo('A'))}"/>

        <div class="tituloTree">
            Planillas del contrato de la obra ${obra.descripcion}
        </div>

        <div class="row">
            <div class="span9" role="navigation">
                <div class="btn-group">
                    <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn" title="Regresar al contrato">
                        <i class="icon-arrow-left"></i>
                        Contrato
                    </g:link>
                    <g:if test="${anticipo > 0}">
                        <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                            <g:link action="form" class="btn" params="[contrato: contrato?.id]">
                                <i class="icon-file"></i>
                                Nueva planilla
                            </g:link>
                        </g:if>
                    </g:if>

                </div>
            </div>

            <div class="span3" id="busqueda-Planilla"></div>
        </div>

        <div class="row">
            <div class="span12" role="navigation">
                <g:if test="${liquidacion}">
                    <div class="btn-group">
                        <g:if test="${contrato.fiscalizador.id == session.usuario.id}">
                            <g:link controller="reportesPlanillas" action="reporteDiferencias" class="btn" id="${contrato.id}">
                                <i class="icon-exchange"></i>
                                Reporte de diferencias
                            </g:link>
                            <g:link controller="acta" action="form" class="btn" params="[contrato: contrato.id, tipo: 'P']">
                                <i class="icon-stackexchange"></i>
                                Acta de recepción provisional
                            </g:link>
                            <g:set var="actaProvisional" value="${janus.actas.Acta.findAllByContratoAndTipo(contrato, 'P')}"/>
                            <g:if test="${actaProvisional.size() == 1 && actaProvisional[0].registrada == 1}">
                                <g:link controller="acta" action="form" class="btn" params="[contrato: contrato.id, tipo: 'D']">
                                    <i class="icon-stackexchange"></i>
                                    Acta de recepción definitiva
                                </g:link>
                            </g:if>
                        </g:if>
                    </div>
                </g:if>
                <g:if test="${obra.fechaInicio}">
                    <a href="#" class="btn  " id="imprimir">
                        <i class="icon-print"></i>
                        Imprimir Orden de Inicio de Obra
                    </a>
                </g:if>
            </div>
        </div>

        <g:form action="delete" name="frmDelete-Planilla">
            <g:hiddenField name="id"/>
        </g:form>

        <div id="list-Planilla" role="main" style="margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover">
                <thead>
                    <tr>
                        <g:sortableColumn property="numero" title="#"/>
                        <g:sortableColumn property="tipoPlanilla" title="Tipo"/>
                        %{--<g:sortableColumn property="estadoPlanilla" title="Estado"/>--}%
                        <g:sortableColumn property="fechaPresentacion" title="Fecha presentación"/>
                        <g:sortableColumn property="fechaInicio" title="Fecha inicio"/>
                        <g:sortableColumn property="fechaFin" title="Fecha fin"/>
                        <g:sortableColumn property="descripcion" title="Descripción"/>
                        <g:sortableColumn property="valor" title="Valor"/>
                        <th width="180">Acciones</th>
                        <th width="130">Pagos</th>
                    </tr>
                </thead>
                <tbody class="paginate">
                    <g:each in="${planillaInstanceList}" status="i" var="planillaInstance">
                    %{--<g:set var="periodosOk" value="${janus.ejecucion.PeriodoPlanilla.findAllByPlanilla(planillaInstance)}"/>--}%
                        <g:set var="periodosOk" value="${janus.ejecucion.ReajustePlanilla.findAllByPlanilla(planillaInstance)}"/>
                        <g:set var="eliminable" value="${planillaInstance.fechaMemoSalidaPlanilla == null}"/>

                        <tr style="font-size: 10px">
                            <td>${fieldValue(bean: planillaInstance, field: "numero")}</td>
                            <td>
                                ${planillaInstance.tipoPlanilla.nombre}

                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'P'}">
                                %{--(${cont}/${prej.size()})--}%
                                    <g:if test="${cont == prej.size() && planillaInstance.fechaFin >= prej[0].fechaFin}">
                                        (Liquidación)
                                    </g:if>
                                    <g:set var="cont" value="${cont + 1}"/>
                                </g:if>

                            </td>
                            <td>
                                <g:formatDate date="${planillaInstance.fechaPresentacion}" format="dd-MM-yyyy"/>
                            </td>
                            <td>
                                <g:formatDate date="${planillaInstance.fechaInicio}" format="dd-MM-yyyy"/>
                            </td>
                            <td>
                                <g:formatDate date="${planillaInstance.fechaFin}" format="dd-MM-yyyy"/>
                            </td>
                            <td>${planillaInstance?.id} ${fieldValue(bean: planillaInstance, field: "descripcion")}</td>
                            %{--<td></td>--}%
                            <td class="numero">
                                <g:formatNumber number="${planillaInstance.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,##0" locale="ec"/>
                            </td>
                            <td>

                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">
                                    <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                        <g:if test="${!planillaInstance.fechaMemoPedidoPagoPlanilla}">
                                            <div data-id="${planillaInstance.id}" rel="tooltip" title="Procesar" class="btn btn-small btnProcesaQ">
                                                <i class="icon-gear"></i>
                                            </div>
                                        </g:if>
                                    </g:if>
                                </g:if>

                                <g:if test="${planillaInstance.tipoPlanilla.codigo in ['P', 'Q', 'O', 'C'] && !planillaInstance.fechaMemoSalidaPlanilla && contrato?.fiscalizador?.id == session.usuario.id}">
                                    <g:link controller="planilla" action="form" params="[id: planillaInstance.id, contrato: planillaInstance.contrato.id]"
                                            rel="tooltip" title="Editar" class="btn btn-small">
                                        <i class="icon-pencil"></i>
                                    </g:link>
                                </g:if>
                                <g:if test="${planillaInstance.tipoPlanilla.codigo in ['P', 'Q', 'O']}">
                                    <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                        <g:link action="detalle" id="${planillaInstance.id}" params="[contrato: contrato.id]" rel="tooltip" title="Detalles" class="btn btn-small">
                                            <i class="icon-reorder icon-large"></i>
                                        </g:link>
                                        <g:if test="${!planillaInstance.fechaMemoSalidaPlanilla}">
                                            <div data-id="${planillaInstance.id}" rel="tooltip" title="Procesar" class="btn btn-small btnProcesaQ">
                                                <i class="icon-gear"></i>
                                            </div>
                                        </g:if>
                                    </g:if>
                                </g:if>

                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">
                                    <g:link controller="planilla2" action="resumen" id="${planillaInstance.id}" rel="tooltip" title="Resumen" class="btn btn-small">
                                        <i class="icon-table icon-large"></i>
                                    </g:link>
                                </g:if>
                                <g:elseif test="${planillaInstance.tipoPlanilla.codigo in ['P', 'Q']}">
                                    <g:link controller="planilla2" action="resumen" id="${planillaInstance.id}" fprj="${planillaInstance.formulaPolinomicaReajuste}" rel="tooltip" title="Resumen" class="btn btn-small">
                                        <i class="icon-table icon-large"></i>
                                    </g:link>
                                </g:elseif>
                                <g:elseif test="${planillaInstance.tipoPlanilla.codigo == 'L'}">
                                    <g:link controller="planilla2" action="liquidacion" id="${planillaInstance.id}" rel="tooltip" title="Resumen" class="btn btn-small">
                                        <i class="icon-table icon-large"></i>
                                    </g:link>
                                </g:elseif>

                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'C'}">
                                    <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                        <g:link action="detalleCosto" id="${planillaInstance.id}" params="[contrato: contrato.id]" rel="tooltip" title="Detalles" class="btn btn-small">
                                            <i class="icon-reorder icon-large"></i>
                                        </g:link>
                                    </g:if>
                                </g:if>
                                <g:if test="${janus.ejecucion.ReajustePlanilla.countByPlanilla(planillaInstance) > 0}">
                                    <g:link controller="reportePlanillas3" action="reportePlanilla" id="${planillaInstance.id}"
                                            class="btn btnPrint  btn-small btn-ajax" rel="tooltip" title="Imprimir">
                                        <i class="icon-print"></i>
                                    </g:link>
                                </g:if>

                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'C' && janus.ejecucion.DetallePlanillaCosto.countByPlanilla(planillaInstance) > 0}">
                                    <g:link controller="reportesPlanillas" action="reportePlanillaCosto" id="${planillaInstance.id}" class="btn btnPrint  btn-small btn-ajax" rel="tooltip" title="Imprimir">
                                        <i class="icon-print"></i>
                                    </g:link>
                                </g:if>
                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'L'}">
                                    <g:link controller="reportesPlanillas" action="reportePlanillaLiquidacion" id="${planillaInstance.id}" class="btn btnPrint  btn-small btn-ajax" rel="tooltip" title="Imprimir">
                                        <i class="icon-print"></i>
                                    </g:link>
                                </g:if>
                            </td>

                            <td style="text-align: center;">
                                <g:if test="${periodosOk.size() > 0 || planillaInstance.tipoPlanilla.codigo == 'C' || planillaInstance.tipoPlanilla.codigo == 'L'}">
                                    <g:set var="lblBtn" value="${-1}"/>
                                    <g:if test="${planillaInstance.fechaOficioEntradaPlanilla}">
                                        <g:set var="lblBtn" value="${2}"/>
                                        <g:if test="${planillaInstance.fechaMemoSalidaPlanilla}">
                                            <g:set var="lblBtn" value="${3}"/>
                                            <g:if test="${planillaInstance.fechaMemoPedidoPagoPlanilla}">
                                                <g:set var="lblBtn" value="${4}"/>
                                                <g:if test="${planillaInstance.fechaMemoPagoPlanilla}">
                                                    <g:set var="lblBtn" value="${5}"/>
                                                </g:if>
                                            </g:if>
                                        </g:if>
                                    </g:if>
                                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && planillaInstance.contrato.oferta.concurso.obra.fechaInicio}">
                                        <g:set var="lblBtn" value="${-6}"/>
                                    </g:if>

                                    <g:if test="${lblBtn > 0}">
                                        <g:if test="${lblBtn == 2}">
                                            <g:if test="${planillaInstance.tipoPlanilla.codigo != 'A'}">
                                                <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                                    <a href="#" class="btn btn-pagar pg_${lblBtn}" data-id="${planillaInstance.id}" data-tipo="${lblBtn}">
                                                        Enviar planilla
                                                    </a>
                                                </g:if>
                                            </g:if>
                                        </g:if>
                                        <g:if test="${lblBtn == 3 || (lblBtn == 2 && planillaInstance.tipoPlanilla.codigo == 'A')}">
                                            Pedir pago
                                        </g:if>
                                        <g:if test="${lblBtn == 4}">
                                            Informar pago
                                        </g:if>
                                        <g:if test="${lblBtn == 5}">
                                            <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">
                                                Iniciar Obra
                                            </g:if>
                                            <g:else>
                                                <img src="${resource(dir: 'images', file: 'tick-circle.png')}" alt="Pago completado"/>
                                            </g:else>
                                        </g:if>
                                    </g:if>
                                    <g:elseif test="${lblBtn == -6}">
                                        <img src="${resource(dir: 'images', file: 'tick-circle.png')}" alt="Pago completado"/>
                                    </g:elseif>

                                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && Math.abs(lblBtn) > 3}">
                                        <a href="#" class="btn btn-small btnPedidoPagoAnticipo" title="Imprimir memo de pedido de pago" data-id="${planillaInstance.id}">
                                            <i class="icon-print"></i>
                                        </a>
                                    </g:if>
                                    <g:if test="${(planillaInstance.tipoPlanilla.codigo in ['P', 'Q']) && Math.abs(lblBtn) > 3}">
                                        <a href="#" class="btn btn-small btnPedidoPago" title="Imprimir memo de pedido de pago" data-id="${planillaInstance.id}">
                                            <i class="icon-print"></i>
                                        </a>

                                    </g:if>
                                </g:if>
                                <g:else>
                                </g:else>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>

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


        <div id="errorImpresion">
            <fieldset>
                <div class="spa3" style="margin-top: 30px; margin-left: 10px">

                    Debe ingresar un número de Oficio!

                </div>
            </fieldset>
        </div>


        <script type="text/javascript">
            var url = "${resource(dir:'images', file:'spinner_24.gif')}";
            var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

            function submitForm(btn) {
                if ($("#frmSave-Planilla").valid()) {
                    btn.replaceWith(spinner);
                }
                $("#frmSave-Planilla").submit();
            }

            $(function () {
                $('[rel=tooltip]').tooltip();

                $(".paginate").paginate({
                    maxRows        : 10,
                    searchPosition : $("#busqueda-Planilla"),
                    float          : "right"
                });

                $(".btnPedidoPagoAnticipo").click(function () {
                    location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPagoAnticipo')}/" + $(this).data("id");
                    return false;
                });

                $(".btnPedidoPago").click(function () {
                    location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPago')}/" + $(this).data("id");
                    return false;
                });

                $(".btn-pagar").click(function () {
                    var $btn = $(this);
                    var tipo = $btn.data("tipo").toString();
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'pago_ajax')}",
                        data    : {
                            id   : $btn.data("id"),
                            tipo : tipo
                        },
                        success : function (msg) {
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
                }); //click btn new

                $(".btn-new").click(function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle").html("Crear Planilla");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                            $("#modal-Planilla").modal("show");
                        }
                    });
                    return false;
                }); //click btn new

                $(".btn-edit").click(function () {
                    var id = $(this).data("id");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'form_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                            $("#modalTitle").html("Editar Planilla");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                            $("#modal-Planilla").modal("show");
                        }
                    });
                    return false;
                }); //click btn edit

                $(".btn-show").click(function () {
                    var id = $(this).data("id");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'show_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");
                            $("#modalTitle").html("Ver Planilla");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk);
                            $("#modal-Planilla").modal("show");
                        }
                    });
                    return false;
                }); //click btn show

                $(".btnProcesa").click(function () {
                    var id = $(this).data("id");
//                    console.log("id:" + id)
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'procesar')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            location.reload();
                        }
                    });
                    return false;
                }); //click btn show

                $(".btnProcesaQ").click(function () {
                    var id = $(this).data("id");
//                    console.log("id:" + id)
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'procesarLq')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            if (msg == 'fechas') {
                                location.href = "${g.createLink(controller: 'contrato', action: 'fechasPedidoRecepcion' )}?id=" +
                                ${contrato?.id}
                            } else {
                                location.reload();
                            }
                        }
                    });
                    return false;
                }); //click btn show

                $(".btn-delete").click(function () {
                    var id = $(this).data("id");
                    $("#id").val(id);
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

                    btnDelete.click(function () {
                        btnDelete.replaceWith(spinner);
                        $("#frmDelete-Planilla").submit();
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
                    $("#modalTitle").html("Eliminar Planilla");
                    $("#modalBody").html("<p>¿Está seguro de querer eliminar esta Planilla?</p>");
                    $("#modalFooter").html("").append(btnOk).append(btnDelete);
                    $("#modal-Planilla").modal("show");
                    return false;
                });

                $("#imprimir").click(function () {
                    location.href = "${g.createLink(controller: 'reportesPlanillas', action: 'reporteContrato', id: obra?.id)}?oficio=" +
                                    $("#oficio").val() + "&firma=" + $("#firma").val();
//                    $("#imprimirDialog").dialog("open");

                });

                $("#errorImpresion").dialog({
                    autoOpen  : false,
                    resizable : false,
                    modal     : true,
                    draggable : false,
                    width     : 320,
                    height    : 200,
                    position  : 'center',
                    title     : 'Error',
                    buttons   : {
                        "Aceptar" : function () {
                            $("#errorImpresion").dialog("close")
                        }
                    }
                });
            });

        </script>

    </body>
</html>
