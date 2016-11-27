<%@ page import="janus.ejecucion.TipoFormulaPolinomica" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'tableHandler.css')}">

    <title>Orden de subpresupuestos</title>
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

<div class="row" style="margin-bottom: 10px;">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="obra" action="registroObra" params="[obra: obra?.id]"
                class="btn btn-ajax btn-new" title="Regresar al obra">
            <i class="icon-double-angle-left"></i>
            Regresar a Obra
        </g:link>
        <a href="#" class="btn btn-success" id="btnSave"><i class="icon-save"></i> Guardar</a>
        <a href="#" class="btn btn-warning" id="btnActualiza"><i class="icon-save"></i> Actualizar distribución de subspresupuestos y areas</a>

    </div>
</div>

<div style="height: 200px;">
    <fieldset class="borde" style="width: 820px; float: left">
        <legend>Orden de los subpresupuestos</legend>
        <div style="max-height: 180px; overflow: auto">
        <table class="table table-bordered table-striped table-hover table-condensed" style="width: 800px !important;">
            <thead>
            <tr>
                <th style="width: 400px; text-align: center">Subpresupuesto</th>
                <th style="width: 80px">Orden</th>
                <th style="width: 130px">Nuevo</th>
                <th style="width: 80px">Cambiar</th>
            </tr>
            </thead>
            <tbody id="bodyPoliContrato">
            <g:set var="tot" value="${0}"/>
            <g:each in="${sbpr}" var="sb">
                <tr>
                    <td>${sb?.sbprdscr}</td>
                    <td style="text-align: center">${sb?.ordnsbpr}</td>
                    <td class="editable" id="val${sb.sbpr__id}" style="text-align: center" data-valor="${sb.ordnsbpr}">
                        ${g.formatNumber(number: sb.ordnsbpr, minFractionDigits: 0, maxFractionDigits: 0)}
                    </td>
                    <td style="text-align: center"><a href="#" class="btn btn-success btn-mini ordnsbpr" data-id="${sb.sbpr__id}" data-original="${sb.ordnsbpr}">
                        <i class="icon-check"></i> Guardar
                    </a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
        </div>
    </fieldset>

</div>

<div id="areas" style="width: 1100px; margin-top: -20px">
    <fieldset class="borde" style="display: block">
        <legend>Orden de áreas dentro de los subpresupuestos</legend>
        <div style="max-height: 480px; overflow: auto">
        <table class="table table-bordered table-striped table-hover table-condensed" id="tablaCuadrilla">
            <thead>
            <tr>
                <th style="width: 300px; text-align: center">Subpresupuesto</th>
                <th style="width: 400px; text-align: center">Área</th>
                <th style="width: 80px">Orden</th>
                <th style="width: 130px">Nuevo</th>
                <th style="width: 80px">Cambiar</th>
            </tr>
            </thead>
            <tbody id="bodyCuadrilla">
            <g:set var="tot" value="${0}"/>
            <g:each in="${orden}" var="i">
                <tr>
                    <td>${i?.sbprdscr}</td>
                    <td>${i?.areadscr}</td>
                    <td style="text-align: center">${i?.ordnordn}</td>
                    <td class="editable" id="or${i.ordn__id}" style="text-align: center" data-valor="${i.ordnordn}">
                        ${g.formatNumber(number: i.ordnordn, minFractionDigits: 0, maxFractionDigits: 0)}
                    </td>
                    <td style="text-align: center"><a href="#" class="btn btn-success btn-mini ordn" data-id="${i.ordn__id}" data-original="${i.ordnordn}">
                        <i class="icon-check"></i> Guardar
                    </a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
        </div>
    </fieldset>
</div>


<script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandlerBody.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandler.js')}"></script>

</div>

<div id="dialog-confirma" title="Crear Fórmula Polinómica" style="display: none">
    <p><span class="ui-icon ui-icon-alert"
             style="float:left; margin:0 7px 70px 0;"></span>

    <p>Crear una fórmula polinómica adicional para este obra.</p>

    <p>Se creará la nueva fórmula en base a una existente.</p>
</p>
</div>


<div id="ajx_frma" style="width:520px;"></div>

<script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandlerBody.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'tableHandler.js')}"></script>

<script type="text/javascript">
    decimales = 0;

//    beforeDoEdit = function (sel, tf) {
//        var tipo = sel.data("tipo");
//        tf.data("tipo", tipo);
//    };

    textFieldBinds = {
        keyup: function () {
            var tipo = $(this).data("tipo");
            var td = $(this).parents("td");
            var val = $(this).val();
            var thTot = $("th." + tipo);
            var tds = $(".editable[data-tipo=" + tipo + "]").not(td);

            var tot = parseInt(val);
            tds.each(function () {
                tot += parseFloat($(this).data("valor"));
            });
            thTot.text(tot);
        }
    };

    $(".editable").first().addClass("selected");

    $(".ordnsbpr").click(function () {
        var id = $(this).data("id");
        console.log('valores', 'id:' + $(this).data("id"), 'or:' + parseInt($(this).data("original")), $('#' + 'val56').data("valor"));

            $.ajax({
                type: "POST",
                url: "${createLink(action: 'cambiaSbpr')}",
                data: "id=" + ${obra.id} + "&sbpr=" + id + "&valor=" +  $('#' + 'val' + id).data("valor"),
                success: function (msg) {
                    var parts = msg.split("_");
                    var ok = parts[0];
                    if(ok == 'ok') {
                        location.reload()
                    }
                }
            });
        return false;
    });

    $(".ordn").click(function () {
        var id = $(this).data("id");
            $.ajax({
                type: "POST",
                url: "${createLink(action: 'cambiaOrdn')}",
                data: "id=" + ${obra.id} + "&ordn=" + id + "&valor=" +  $('#' + 'or' + id).data("valor"),
                success: function (msg) {
                    var parts = msg.split("_");
                    var ok = parts[0];
                    if(ok == 'ok') {
                        location.reload()
                    }
                }
            });
        return false;
    });


    $("#btnSave").click(function () {
            $.ajax({
                type: "POST",
                url: "${createLink(action:'guardarCambiosOrden')}",
                data: "obra=" + ${obra.id},
                success: function (msg) {
                    var parts = msg.split("_");
                    location.reload();
                }
            });
        return false;
    });

    $("#tabs").tabs({
        heightStyle: "fill",
        activate: function (event, ui) {
            ui.newPanel.find(".editable").first().addClass("selected");
        }
    });


</script>

</body>
</html>