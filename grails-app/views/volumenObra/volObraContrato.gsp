<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/12/16
  Time: 13:12
--%>

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

    <script src="${resource(dir: 'js/jquery/plugins/jgrowl', file: 'jquery.jgrowl.js')}"></script>
    <link href="${resource(dir: 'js/jquery/plugins/jgrowl', file: 'jquery.jgrowl.css')}" rel="stylesheet"/>
    <link href="${resource(dir: 'js/jquery/plugins/jgrowl', file: 'jquery.jgrowl.customThemes.css')}" rel="stylesheet"/>

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
    Volúmenes de obra del contrato: ${contrato?.codigo}
    <input type="hidden" id="override" value="0">
</div>

<div class="row" style="display: inline">
    <div class="span5" role="navigation" style="margin-left: 35px; width: 460px">
        <a href="${g.createLink(controller: 'contrato', action: 'registroContrato', params: [contrato: contrato?.id])}"
           class="btn btn-ajax btn-new " id="atras" title="Regresar a la obra">
            <i class="icon-arrow-left"></i>
            Regresar
        </a>
    </div>
</div>

<div id="list-grupo" class="span12" role="main" style="margin-top: 10px;margin-left: 0px">
    <div class="borde_abajo" style="padding-left: 5px;position: relative; height: 60px">
        <div class="span1" style="margin-left: 20px; width: 100px;">
            <b>Código:</b>
            <input type="text" style="width: 60px;;font-size: 12px" id="item_codigo" class="allCaps">
            <input type="hidden" style="width: 60px" id="item_id">
        </div>

        <div class="span8" style="margin-left: -20px;">
            <b>Rubro:</b>
            <input type="text" style="width: 720px;font-size: 12px" id="item_nombre" readonly="true">
        </div>

        <div class="span2" style="margin-left: -30px; width: 80px;">
            <b>Unidad:</b>
            <input type="text" style="width: 60px" id="item_unidad" value="" readonly="true">
        </div>
        <div class="span1" style="margin-left: 0px; width: 100px;">
            <b>Cantidad:</b>
            <input type="text" style="width: 90px;text-align: right" id="item_cantidad" value="">
        </div>

        <div class="span1" style="margin-left: 10px; width: 90px;">
            <b>Orden:</b>
            <input type="text" style="width: 50px;text-align: right" id="item_orden" value="${(volumenes?.size() > 0) ? volumenes.size() + 1 : 1}">
        </div>

        <div class="span1" style="margin-left: 10px;padding-top:0px; width: 25px;">
            <input type="hidden" value="" id="vol_id">

            %{--<g:if test="${obra?.estado != 'R' && duenoObra == 1}">--}%

            <a href="#" class="btn btn-primary" title="agregar" id="item_agregar" style="margin-top: 20px;">
                <i class="icon-plus"></i>
            </a>

            %{--</g:if>--}%
            %{--<g:else>--}%
            %{--<g:if test="${obra.estado != 'R' && obra?.departamento?.id == persona?.departamento?.id}">--}%
            %{--<a href="#" class="btn btn-primary" title="agregar" id="item_agregar" style="margin-top: 20px;">--}%
            %{--<i class="icon-plus"></i>--}%
            %{--</a>--}%
            %{--</g:if>--}%
            %{--</g:else>--}%

        </div>
    </div>
</div>

<div class="span12" style="margin-left: 0px">

    <div class="span-5" style="margin-bottom: 5px">

        <b>Obra:</b>
        <g:select name="obra_name" from="${obraSel}" optionKey="id" optionValue="descripcion"
                  style="width: 300px;font-size: 12px; margin-right: 10px" id="obrasContrato"
                  noSelection="['-1': 'Seleccione..']"/>

        <b>Subpresupuesto:</b>
        %{--<g:select name="subpresupuesto" from="${subPres}" optionKey="id" optionValue="descripcion"--}%
                  %{--style="width: 300px;font-size: 12px; margin-right: 10px" id="subPresContrato"--}%
                  %{--noSelection="['-1': 'Seleccione..']"/>--}%

        %{--<b>Area:</b>--}%
        %{--<span id="div_cmb_area"><g:select name="area" id="areaSp" from="${areas}" optionKey="id" optionValue="descripcion"--}%
        %{--style="font-size: 12px; width: 240px"  value="${areaSel}"/>--}%
        %{--</span>--}%

        %{--<a href="#" class="btn btn-ajax btn-new btn-params" id="botonIr" title="Ir a detalle de volumenes de obra">--}%
        %{--<i class="icon-check"></i> Ir--}%
        %{--</a>--}%
    </div>

    <div class="span-4" style="margin-bottom: 5px" id="divSub">
    </div>

    <div class="span-4" style="margin-bottom: 5px" id="divArea">
    </div>
</div>

<div class="span12" style="margin-left: 30px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 20px;">
                #
            </th>
            <th style="width: 120px;">
                Subpresupuesto
            </th>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 300px;">
                Rubro
            </th>
            <th style="width: 40px" class="col_unidad">
                Unidad
            </th>
            <th style="width: 40px">
                Cantidad
            </th>
            <th style="width: 40px">
                Precio
            </th>
            <th style="width: 40px">
                Borrar
            </th>
            %{--<th class="col_precio" style="display: none;">Unitario</th>--}%
            %{--<th class="col_total" style="display: none;">C.Total</th>--}%
            %{--<g:if test="${obra.estado!='R' && duenoObra == 1}">--}%
            %{--<th style="width: 40px" class="col_delete"></th>--}%
            %{--</g:if>--}%
        </tr>
        </thead>
    </table>
</div>




<div class="borde_abajo" style="position: relative;float: left;width: 95%;padding-left: 45px">
    <p class="css-vertical-text">Composición</p>

    <div class="linea" style="height: 98%;"></div>

    <div style="width: 99.7%;height: 500px;overflow-y: auto;float: right;" id="detalle"></div>

    %{--<g:if test="${session.perfil.codigo == 'CSTO'}">--}%
    %{--<div style="width: 99.7%;height: 30px;overflow-y: auto;float: right;text-align: right" id="total">--}%
    %{--<b>TOTAL:</b>--}%

    %{--<div id="divTotal" style="width: 150px;float: right;height: 30px;font-weight: bold;font-size: 12px;margin-right: 20px"></div>--}%
    %{--</div>--}%
    %{--</g:if>--}%
</div>
%{--</div>--}%



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



<script type="text/javascript">

    $("#obrasContrato").change(function () {
        var ob = $(this).val()
        if(ob != '-1'){
            $.ajax({
                type: 'POST',
                url: "${createLink(controller: 'volumenObra', action: 'subpresupuesto_ajax')}",
                data:{
                    obra: ob
                },
                success: function (msg) {
                    $("#detalle").html('')
                    $("#divSub").html(msg)
                }
            }) ;
        }else{
            $("#detalle").html('');
            $("#divSub").html('')
            $("#divArea").html('')
        }

    });

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


//    $("#subPresContrato").change(function () {
//        var sb = $(this).val();
//        cargarTabla(sb)
//    });

    function cargarTabla(sub, area) {
        var interval = loading("detalle");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'volumenObra', action: 'tablaRubrosContrato_ajax')}',
            data:{
                contrato: '${contrato?.id}',
                sub: sub,
                area: area
            },
            success: function (msg) {
                clearInterval(interval);
                $("#detalle").html(msg)
            }
        });
    }

    $("#item_codigo").dblclick(function () {
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        $("#modalTitle").html("Lista de rubros");
        $("#modalFooter").html("").append(btnOk);
        $("#modal-rubro").modal("show");
        $("#buscarDialog").unbind("click");
        $("#buscarDialog").bind("click", enviar)
    });


    $("#item_codigo").blur(function () {
        if ($("#item_id").val() == "" && $("#item_codigo").val() != "") {
            console.log($("#item_id").val())
            $.ajax({
                type : "POST",
                url : "${g.createLink(controller: 'volumenObra',action:'buscarRubroCodigo')}",
                data     : "codigo=" + $("#item_codigo").val(),
                success  : function (msg) {
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
        }
    });


    $("#item_agregar").click(function () {
//        $("#item_agregar").hide(600);

        $("#divTotal").html("")

        var cantidad = $("#item_cantidad").val()
        cantidad = str_replace(",", "", cantidad)
        var orden = $("#item_orden").val()
        var rubro = $("#item_id").val()
        var cod = $("#item_codigo").val()
        var sub = $("#subPresContrato").val()
        var dscr = $("#item_descripcion").val()
        var area = $("#area").val()

        var ord = 1

        if (isNaN(cantidad))
            cantidad = 0
        if (isNaN(orden))
            orden = 0
        var msn = ""

        if (cantidad * 1 < 0.00001 || orden * 1 < 1) {
            msn = "La cantidad  y el orden deben ser números positivos mayores a 0"
        }
        if (rubro * 1 < 1){
            msn = "seleccione un rubro"
        }


        if (msn.length == 0) {
            var datos = "rubro=" + rubro + "&cantidad=" + cantidad + "&orden=" + orden + "&sub=" + sub +
                    "&obra=${''}" + "&cod=" + cod + "&ord=" + ord + '&override=' + $("#override").val() +
                    "&dscr=" + dscr + "&area=" + area
            if ($("#vol_id").val() * 1 > 0)
                datos += "&id=" + $("#vol_id").val()

            $.ajax({
                type : "POST",
                url : "${g.createLink(controller: 'volumenObra', action:'agregarItemContrato_ajax')}",
                data     : datos,
                success  : function (msg) {
                    if (msg != "error") {
                        $("#detalle").html(msg)
                        $("#vol_id").val("")
                        $("#item_codigo").val("")
                        $("#item_id").val("")
                        $("#item_nombre").val("")
                        $("#item_cantidad").val("")
                        $("#item_descripcion").val("")
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
//                    $("#item_agregar").show(500);
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
//            $("#item_agregar").show(500);
        }
    });

</script>
</body>
</html>