<%@ page import="janus.SubPresupuesto; janus.Area" %>

<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Volúmenes de obra
        </title>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>
        <script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>
        <link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">
        <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.ui.position.js')}" type="text/javascript"></script>
        <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.js')}" type="text/javascript"></script>
        <link href="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.css')}" rel="stylesheet" type="text/css"/>

        <style type="text/css">
            .boton {
                padding: 2px 2px;
                margin-top: -10px
            }
        </style>

    </head>

    <body>
        <div class="span12" id="mensaje">
            <g:if test="${flash.message}">
                <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                    <a class="close" data-dismiss="alert" href="#">×</a>
                    ${flash.message}
                </div>
            </g:if>
        </div>

        <div class="tituloTree">
            Volúmenes de la obra contratada: ${obra.nombre + " (" + obra.codigo + ")"}
            <input type="hidden" id="override" value="0">
        </div>

        <div class="row" style="display: inline">
            <div class="span5" role="navigation" style="margin-left: 35px; width: 460px">
                <a href="${g.createLink(controller: 'contrato', action: 'registroContrato', params: [contrato: contrato?.id])}"
                   class="btn btn-ajax btn-new " id="atras" title="Regresar al contrato">
                    <i class="icon-arrow-left"></i>
                    Regresar
                </a>
                    <a href="#" class="btn btn-ajax btn-new btn-params" id="calcular" title="Calcular precios">
                        <i class="icon-table"></i>
                        Calcular
                    </a>
            </div>

        <div class="row-fluid" style="margin-left: 0px">
            <div class="span3" style="width: 380px; margin-top: -20px;">
                <b>Subpresupuesto:</b><g:select name="sbpr" id="sbpr" from="${janus.SubPresupuesto.findAllByIdGreaterThan(0, [sort: 'descripcion'])}"
                        optionKey="id" optionValue="descripcion" style="margin-left: 0px; width: 300px; font-size: 13px; font-weight: bold"/>
                    <a href="#" class="btn boton" id="btnCrearSP" title="Crear subpresupuesto">
                        <i class="icon-plus"></i>
                    </a>
                    <a href="#" class="btn boton" id="btnBorrarSP" title="Borrar subpresupuesto">
                        <i class="icon-minus"></i>
                    </a>
                    <a href="#" class="btn boton" id="btnEditarSP" title="Editar subpresupuesto">
                        <i class="icon-edit"></i>
                    </a>
            </div>



            <div class="" style="margin-left: 0px">
                <div class="span4" style="width: 320px; margin-top: -20px;">
                    <b>Área del Subpresupuesto / Ingresar Rubros:</b>
                    <span id="sp">
                        <span id="div_cmb_sub"><g:select name="area" id="area" from="${janus.Area.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                             style="font-size: 12px; width: 240px" /></span>
                    </span>
                    <g:if test="${duenoObra == 1}">
                        <a href="#" class="btn boton" id="btnCrearArea" title="Crear area de subpresupuesto">
                            <i class="icon-plus"></i>
                        </a>
                        <a href="#" class="btn boton" id="btnBorrarArea" title="Borrar area de subpresupuesto">
                            <i class="icon-minus"></i>
                        </a>
                        <a href="#" class="btn boton" id="btnEditarArea" title="Editar area de subpresupuesto">
                            <i class="icon-edit"></i>
                        </a>

                    </g:if>
                </div>
            </div>
        </div>

        <div id="list-grupo" class="span12" role="main" style="margin-top: 10px;margin-left: 0px">
            <div class="borde_abajo" style="padding-left: 5px;position: relative; height: 60px">
                    %{--Inicia registro de vocr--}%
                    <div class="span1" style="margin-left: 20px; width: 100px;">
                        <b>Código:</b>
                        <input type="text" style="width: 60px;;font-size: 12px" id="item_codigo" class="allCaps">
                        <input type="hidden" style="width: 60px" id="item_id">
                        <input type="hidden" style="width: 60px" id="editar">
                    </div>

                    <div class="span7" style="margin-left: -20px;">
                        <b>Rubro:</b>
                        <input type="text" style="width: 620px;font-size: 12px" id="item_nombre" readonly="true">
                    </div>

                    <div class="span2" style="margin-left: -30px; width: 80px;">
                        <b>Unidad:</b>
                        <input type="text" style="width: 50px" id="item_unidad" value="" readonly="true">
                    </div>
                    <div class="span1" style="margin-left: 0px; width: 100px;">
                        <b>Cantidad:</b>
                        <input type="text" style="width: 80px;text-align: right" id="item_cantidad" value="">
                    </div>
                    <div class="span1" style="margin-left: 0px; width: 100px;">
                        <b>P. Unitario</b>
                        <input type="text" style="width: 80px;text-align: right" id="item_pcun" value="">
                    </div>

                    <div class="span1" style="margin-left: 10px; width: 90px;">
                        <b>Orden:</b>
                        <input type="text" style="width: 50px;text-align: right" id="item_orden" value="${(volumenes?.size() > 0) ? volumenes.size() + 1 : 1}">
                    </div>

                    <div class="span1" style="margin-left: 10px;padding-top:0px; width: 25px;">
                        <input type="hidden" value="" id="vol_id">

                        <g:if test="${contrato?.estado != 'R'}">
                            <a href="#" class="btn btn-primary" title="Agregar" id="item_agregar" style="margin-top: 20px;">
                                <i class="icon-plus"></i>
                            </a>
                        </g:if>
                    </div>
                </div>
            </div>

            <div class="borde_abajo" style="position: relative;float: left;width: 95%;padding-left: 45px">
                <p class="css-vertical-text">Composición</p>
                <div class="linea" style="height: 98%;"></div>

                <div style="width: 99.7%;height: 600px;overflow-y: auto;float: right;" id="detalle">
                    %{--detale de volúmenes de obra--}%
                </div>

                <div style="width: 99.7%;height: 30px;overflow-y: auto;float: right;text-align: right" id="total">
                    <b>VALOR TOTAL DE LA OBRA:</b>
                    <div id="divTotal" style="width: 150px;float: right;height: 30px;font-weight: bold;font-size: 12px;margin-right: 20px"></div>
                </div>
            </div>
        </div>

        <div class="modal grande hide fade" id="modal-rubro" style="overflow: hidden;">
            <div class="modal-header btn-info">
                <button type="button" class="close" data-dismiss="modal">×</button>
                <h3 id="modalTitle"></h3>
            </div>
            <div class="modal-body" id="modalBody">
                <bsc:buscador name="rubro.buscador.id" value="" accion="buscaRubro" controlador="volumenObra" campos="${campos}" label="Rubro" tipo="lista"/>
            </div>
            <div class="modal-footer" id="modalFooter">
            </div>
        </div>

        <div class="modal hide fade" id="modal-SubPresupuesto">
            <div class="modal-header" id="modalHeader">
                <button type="button" class="close darker" data-dismiss="modal">
                    <i class="icon-remove-circle"></i>
                </button>
                <h3 id="modalTitle-sp"></h3>
            </div>

            <div class="modal-body" id="modalBody-sp">
            </div>

            <div class="modal-footer" id="modalFooter-sp">
            </div>
        </div>

        <div id="borrarSPDialog">
            <fieldset>
                <div class="span3">
                    Está seguro que desea borrar el subpresupuesto?
                </div>
            </fieldset>
        </div>

        <div id="borrarAreaDialog">
            <fieldset>
                <div class="span3">
                    Está seguro que desea borrar el área de subpresupuesto?
                </div>
            </fieldset>
        </div>



        <script type="text/javascript">
            var aviso = false;  //aviso de TR...

            function loading(div) {
                y = 0;
                $("#" + div).html("<div class='tituloChevere' id='loading'>Cargando, Espere por favor</div>")
                var interval = setInterval(function () {
                    if (y == 30) {
                        $("#detalle").html("<div class='tituloChevere' id='loading'>Cargando, Espere por favor</div>")
                        y = 0
                    }
                    $("#loading").append(".");
                    y++
                }, 500);
                return interval
            }

            function cargarTabla() {
                var interval = loading("detalle")
                var datos = ""
                if ($("#subPres_desc").val() * 1 > 0) {
                    datos = "obra=${obcr}&sub=" + $("#subPres_desc").val() + "&ord=" + 1 + "&cntr=" + ${contrato.id}
                } else {
                    datos = "obra=${obcr}&ord=" + 1 + "&cntr=" + ${contrato.id}
                }
                $.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra', action:'tablaCntr')}",
                %{--$.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra', action:'tabla')}",--}%
                    data     : datos,
                    success  : function (msg) {
                        clearInterval(interval)
                        $("#detalle").html(msg);
                        $("#reporteGrupos").show()
                    }
                });
            }
            $(function () {
                %{--$("#detalle").html("<img src='${resource(dir: 'images',file: 'loadingText.gif')}' width='300px' height='45px'>")--}%
//                var total = 0

                $("#grupos").change(function () {
                    $.ajax({
                        type    : "POST", url : "${g.createLink(controller: 'volumenObra',action:'cargarSubpres')}",
                        data    : "grupo=" + $("#grupos").val(),
                        success : function (msg) {
                            $("#div_cmb_sub").html(msg)
                        }
                    });
                });

                cargarTabla();
                $("#vol_id").val("")
                $("#calcular").click(function () {
/*
                    if ($(this).hasClass("active")) {
                        $(this).removeClass("active")
                        $(".col_delete").show()
                        $(".col_precio").hide()
                        $(".col_total").hide()
                        $("#divTotal").html("")
                    } else {
                        $(this).addClass("active")
                        $(".col_delete").hide()
                        $(".col_precio").show()
                        $(".col_total").show()
*/
                        var total = 0

                        $(".total").each(function () {
                            total += parseFloat(str_replace(",", "", $(this).html()))
                        })
                        $("#divTotal").html(number_format(total, 2, ".", ","))
//                    }
                });

                $("#item_codigo").dblclick(function () {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                    $("#modalTitle").html("Lista de rubros");
                    $("#modalFooter").html("").append(btnOk);
                    $("#modal-rubro").modal("show");
                    $("#buscarDialog").unbind("click")
                    $("#buscarDialog").bind("click", enviar)
                });

                $("#reporteGrupos").click(function () {

                    location.href = "${g.createLink(controller: 'reportes',action: 'reporteSubgrupos',id: obra?.id)}"
                });

                $("#item_codigo").blur(function () {
                    if ($("#item_id").val() == "" && $("#item_codigo").val() != "") {
                console.log($("#item_id").val())
                        $.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra',action:'buscarRubroCodigo')}",
                            data     : "codigo=" + $("#item_codigo").val(),
                            success  : function (msg) {
//                        console.log("msg "+msg)
                                if (msg != "-1") {
                                    var parts = msg.split("&&")
                                    $("#item_id").val(parts[0])
                                    $("#item_nombre").val(parts[2])
                                    $("#item_unidad").val(parts[3])
                                } else {
                                    $("#item_id").val("")
                                    $("#item_nombre").val("")
                                    $("#item_unidad").val("")
                                }
                            }
                        });
                    }
                });

                $("#item_codigo").keydown(function (ev) {

                    if (ev.keyCode * 1 != 9 && (ev.keyCode * 1 < 37 || ev.keyCode * 1 > 40)) {

                        $("#item_id").val("")
                        $("#item_nombre").val("")
                        $("#item_unidad").val("")

                    } else {
//                ////console.log("no reset")
                    }
                });

                $("#btnCrearSP").click(function () {
                    var $btnOrig = $(this).clone(true);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:"subPresupuesto", action:'form_ajax')}?obra=" + ${obra?.id},
                        success : function (msg) {
                            $("#modalBody-sp").html(msg);
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');
                            var $frm = $("#frmSave-SubPresupuesto");
                            btnSave.click(function () {
                                spinner.replaceWith($btnOrig);
                                if ($frm.valid()) {
                                    btnSave.replaceWith(spinner);
                                }
                                var data = $frm.serialize();

                                $.ajax({
                                    type    : "POST",
                                    url     : $frm.attr("action"),
                                    data    : data,
                                    success : function (msg) {
                                        var p = msg.split("_");
                                        var alerta;
                                        if (msg != "NO") {
                                            alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                            $("#modal-SubPresupuesto").modal("hide");
                                            $("#div_cmb_sub").html(p[2])
                                        }
                                        else {
                                            alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                        }
                                        $("#mensaje").html(alerta)
                                        setTimeout(function () {
                                            location.reload()
                                        }, 500);
                                    }
                                });
                                return false;
                            });
                            btnOk.click(function () {
                                spinner.replaceWith($btnOrig);
                            });

                            $("#modalHeader-sp").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-sp").html("Crear Subpresupuesto");
                            $("#modalFooter-sp").html("").append(btnOk).append(btnSave);
                            $("#modal-SubPresupuesto").modal("show");
                            $("#volob").val("1");
                        }
                    });
                    return false;
                });

                $("#btnBorrarSP").click(function () {
                    $("#borrarSPDialog").dialog("open")
                });

                $("#aviso").click(function () {
                    $("#aviso").hide()
                });

                $("#btnEditarSP").click(function () {
                    var $btnOrig = $(this).clone(true);
                    var idSp = $("#sbpr").val();
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:"subPresupuesto", action:'form_ajax')}",
                        data    : {
                            id : idSp
                        },
                        success : function (msg) {
                            $("#modalBody-sp").html(msg);
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');
                            var $frm = $("#frmSave-SubPresupuesto");
                            btnSave.click(function () {
                                spinner.replaceWith($btnOrig);
                                if ($frm.valid()) {
                                    btnSave.replaceWith(spinner);
                                }
                                var data = $frm.serialize();
                                $.ajax({
                                    type    : "POST",
                                    url     : $frm.attr("action"),
                                    data    : data,
                                    success : function (msg) {
                                        var p = msg.split("_");
                                        var alerta;
                                        if (msg != "NO") {
                                            $("#modal-SubPresupuesto").modal("hide");
                                            alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                            $("#modal-SubPresupuesto").modal("hide");
                                            $("#div_cmb_sub").html(p[2])
                                        } else {
                                            alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                        }
                                        $("#mensaje").html(alerta);
                                        setTimeout(function () {
                                            location.reload()
                                        }, 500);
                                    }
                                });
                                return false;
                            });

                            btnOk.click(function () {
                                spinner.replaceWith($btnOrig);
                            });

                            $("#modalHeader-sp").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-sp").html("Editar Subpresupuesto");
                            $("#modalFooter-sp").html("").append(btnOk).append(btnSave);
                            $("#modal-SubPresupuesto").modal("show");
                            $("#volob").val("1");
                        }
                    });
                    return false;
                });


                $("#btnCrearArea").click(function () {
                    var $btnOrig = $(this).clone(true);
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:"area", action:'form_ajax')}?obra=" + ${obra?.id},
                        success : function (msg) {
                            $("#modalBody-sp").html(msg);
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');
                            var $frm = $("#frmSave-Area");
                            btnSave.click(function () {
                                spinner.replaceWith($btnOrig);
                                if ($frm.valid()) {
                                    btnSave.replaceWith(spinner);
                                }
                                var data = $frm.serialize();

                                $.ajax({
                                    type    : "POST",
                                    url     : $frm.attr("action"),
                                    data    : data,
                                    success : function (msg) {
                                        var p = msg.split("_");
                                        var alerta;
                                        if (msg != "NO") {
                                            alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                            $("#modal-SubPresupuesto").modal("hide");
                                            $("#div_cmb_sub").html(p[2])
                                        }
                                        else {
                                            alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                        }
                                        $("#mensaje").html(alerta)
                                        setTimeout(function () {
                                            location.reload()
                                        }, 500);
                                    }
                                });
                                return false;
                            });
                            btnOk.click(function () {
                                spinner.replaceWith($btnOrig);
                            });

                            $("#modalHeader-sp").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-sp").html("Crear Area de subpresupuesto");
                            $("#modalFooter-sp").html("").append(btnOk).append(btnSave);
                            $("#modal-SubPresupuesto").modal("show");
                            $("#volob").val("1");
                        }
                    });
                    return false;
                });

                $("#btnEditarArea").click(function () {
                    var $btnOrig = $(this).clone(true);
                    var idSp = $("#area").val();
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:"area", action:'form_ajax')}",
                        data    : {
                            id : idSp
                        },
                        success : function (msg) {
                            $("#modalBody-sp").html(msg);
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');
                            var $frm = $("#frmSave-Area");
                            btnSave.click(function () {
                                spinner.replaceWith($btnOrig);
                                if ($frm.valid()) {
                                    btnSave.replaceWith(spinner);
                                }
                                var data = $frm.serialize();
                                $.ajax({
                                    type    : "POST",
                                    url     : $frm.attr("action"),
                                    data    : data,
                                    success : function (msg) {
                                        var p = msg.split("_");
                                        var alerta;
                                        if (msg != "NO") {
                                            $("#modal-SubPresupuesto").modal("hide");
                                            alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                            $("#modal-SubPresupuesto").modal("hide");
                                            $("#div_cmb_sub").html(p[2])
                                        } else {
                                            alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                            alerta += p[1];
                                            alerta += '</div>';
                                        }
                                        $("#mensaje").html(alerta);
                                        setTimeout(function () {
                                            location.reload()
                                        }, 500);
                                    }
                                });
                                return false;
                            });

                            btnOk.click(function () {
                                spinner.replaceWith($btnOrig);
                            });

                            $("#modalHeader-sp").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle-sp").html("Editar Subpresupuesto");
                            $("#modalFooter-sp").html("").append(btnOk).append(btnSave);
                            $("#modal-SubPresupuesto").modal("show");
                            $("#volob").val("1");
                        }
                    });
                    return false;
                });

                $("#btnBorrarArea").click(function () {
                    $("#borrarAreaDialog").dialog("open")
                });


                $("#borrarSPDialog").dialog({
                    autoOpen  : false,
                    resizable : false,
                    modal     : true,
                    draggable : false,
                    width     : 350,
                    height    : 180,
                    position  : 'center',
                    title     : 'Borrar Subpresupuesto',
                    buttons   : {
                        "Aceptar"  : function () {
                            var id = $("#sbpr").val();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(controller:"subPresupuesto", action:'delete2')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    var p = msg.split("_");
                                    var alerta;
                                    if (msg != "NO") {
                                        alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                        alerta += p[1];
                                        alerta += '</div>';
                                        $("#div_cmb_sub").html(p[2])
                                    } else {
                                        alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                        alerta += p[1];
                                        alerta += '</div>';
                                    }
                                    $("#mensaje").html(alerta);
                                    setTimeout(function () {
                                        location.reload()
                                    }, 500);
                                }
                            });
                            $("#borrarSPDialog").dialog("close");
                        },
                        "Cancelar" : function () {
                            $("#borrarSPDialog").dialog("close");
                        }
                    }
                });

                $("#borrarAreaDialog").dialog({
                    autoOpen  : false,
                    resizable : false,
                    modal     : true,
                    draggable : false,
                    width     : 350,
                    height    : 180,
                    position  : 'center',
                    title     : 'Borrar el área de Subpresupuesto',
                    buttons   : {
                        "Aceptar"  : function () {
                            var id = $("#area").val();
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(controller:"area", action:'delete')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    var p = msg.split("_");
                                    var alerta;
                                    if (msg != "NO") {
                                        alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                        alerta += p[1];
                                        alerta += '</div>';
                                        $("#div_cmb_sub").html(p[2])
                                    } else {
                                        alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                        alerta += p[1];
                                        alerta += '</div>';
                                    }
                                    $("#mensaje").html(alerta);
                                    setTimeout(function () {
                                        location.reload()
                                    }, 500);
                                }
                            });
                            $("#borrarSPDialog").dialog("close");
                        },
                        "Cancelar" : function () {
                            $("#borrarAreaDialog").dialog("close");
                        }
                    }
                });

                $("#item_agregar").click(function () {
                    $("#item_agregar").hide(600);
                    $("#calcular").removeClass("active")
                    $(".col_delete").show()
                    $(".col_precio").hide()
                    $(".col_total").hide()
                    $("#divTotal").html("")

                    var cantidad = $("#item_cantidad").val()
                    cantidad = str_replace(",", "", cantidad)
                    var orden = $("#item_orden").val()
                    var rubro = $("#item_id").val()
                    var cod = $("#item_codigo").val()
                    var sub = $("#sbpr").val()
                    var pcun = $("#item_pcun").val()
//                    var dscr = $("#item_descripcion").val()
                    var area = $("#area").val()

                    var ord = 1

                    console.log('rubro', rubro)

                    if($("#ordenarDesc").hasClass('active')){
                        ord = 2
                    } else {
                        ord = 1
                    }
                    if (isNaN(cantidad))
                        cantidad = 0
                    if (isNaN(orden))
                        orden = 0
                    var msn = ""
                    if (cantidad * 1 < 0.00001 || orden * 1 < 1) {
                        msn = "La cantidad  y el orden deben ser números positivos mayores a 0"
                    }
                    if (rubro * 1 < 1)
                        msn = "seleccione un rubro"

                    if (msn.length == 0) {
                        var datos = "rubro=" + rubro + "&cantidad=" + cantidad + "&orden=" + orden + "&sub=" + sub +
                                "&obra=${obcr}" + "&cod=" + cod + "&ord=" + ord + '&override=' + $("#override").val() +
                                "&area=" + area + "&pcun=" + pcun + "&editar=" + $("#editar").val()
//                        //console.log(datos)
                        if ($("#vol_id").val() * 1 > 0)
                            datos += "&id=" + $("#vol_id").val()
//                        //console.log(datos)

                        $.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra', action:'addItemCntr')}",
                            data     : datos,
                            success  : function (msg) {
                                if (msg != "error") {
                                    $("#detalle").html(msg)
                                    $("#vol_id").val("")
                                    $("#item_codigo").val("")
                                    $("#item_id").val("")
                                    $("#item_nombre").val("")
                                    $("#item_cantidad").val("")
//                                    $("#item_descripcion").val("")
                                    $("#item_orden").val($("#item_orden").val() * 1 + 1)
                                    $("#override").val("0")
                                } else {
                                    if (confirm("El item ya existe dentro del volumen de obra. Desea incrementar la cantidad?")) {
                                        $("#override").val("1")
                                        $("#item_agregar").click()
                                    } else {
                                        $("#vol_id").val("")
                                        $("#item_codigo").val("")
                                        $("#item_id").val("")
                                        $("#item_nombre").val("")
                                        $("#item_cantidad").val("")
                                        $("#item_unidad").val("")
                                        $("#item_orden").val($("#item_orden").val() * 1 + 1)
                                    }
                                }
                                $("#item_agregar").show(500);
                                $("#editar").val("0")
                            }
                        });
                    } else {
                        $.box({
                            imageClass : "box_info",
                            text       : msn,
                            title      : "Alerta",
                            iconClose  : false,
                            dialog     : {
                                resizable : false,
                                draggable : false,
                                buttons   : {
                                    "Aceptar" : function () {
                                    }
                                },
                                width     : 500
                            }
                        });
                        $("#item_agregar").show(500);
                    }
                });

                $(document).ready(function () {
                    $("#grupos").trigger("change");
                });

                function alerta(titl, mnsj)
                {
                    $("<div></div>").html(mnsj).dialog({
                        title: titl,
                        resizable: false,
                        modal: true,
                        buttons: {
                            "Aceptar": function()
                            {
                                $( this ).dialog( "close" );
                            }
                        }
                    });
                }

                $("#item_cantidad").focus(function () {
                    if (($("#item_nombre").val()) && ($("#item_codigo").val().substr(0, 2) == 'TR') && !aviso) {
                        aviso = true;
                        alerta("Rubro para transporte", "Debe registrar la distancia de desalojo en Variables de " +
                           "la obra, en la sección Transporte Especial");
                    }
                });

            });
        </script>
    </body>
</html>