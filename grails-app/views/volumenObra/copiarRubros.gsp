<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Copiar Rubros
    </title>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>
    <link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">
    <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.ui.position.js')}"
            type="text/javascript"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.js')}"
            type="text/javascript"></script>
    <link href="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.css')}"
          rel="stylesheet" type="text/css"/>

    <style type="text/css">

    .colorOrigen {
        color: #3768ff;
    }

    .colorDestino {
        color: #3f8825;
    }

    </style>
</head>

<body>

<g:if test="${flash.message}">
    <div class="span12" style="height: 35px;margin-bottom: 10px;">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </div>
</g:if>

<div class="span12" style="margin-bottom: 10px">
    <a href="#" class="btn" id="regresar" title="Regresar a Volúmnes de Obra">
        <i class="icon-arrow-left"></i>
        Regresar
    </a>

    <a href="#" class="btn  btn-edit" id="copiar_todos">
        <i class="icon-copy"></i>
        Copiar <b>todos</b> los rubros
    </a>
    <a href="#" class="btn btn-info" id="copiar_sel">
        <i class="icon-check"></i>
        Copiar rubros <b>seleccionados</b>
    </a>

</div>

%{--
<div class="span10" style="margin-bottom: 10px; text-align: center">
    <a href="#" class="btn  btn-edit" id="copiar_todos">
        <i class="icon-copy"></i>
        Copiar <b>todos</b> los rubros
    </a>
    <a href="#" class="btn btn-info" id="copiar_sel">
        <i class="icon-check"></i>
        Copiar rubros <b>seleccionados</b>
    </a>
</div>
--}%


<div class="row-fluid span-12">
    <div class="span4">
        <b class="colorOrigen"><label>Obra Origen:</label></b>
        <g:select name="obra" from="${janus.Obra.list()}" optionKey="id" optionValue="nombre"
                  noSelection="['-1': 'Seleccione una obra...']" style="width: 400px;font-size: 10px;" id="obraSel"
                  value="${obra?.id}"/>
    </div>

    <div class="span4">
        <b class="colorOrigen"><label>Subpresupuesto Origen:</label></b>

        <div id="divOrigen">
        </div>
    </div>

    <div class="span4" style="margin-left: -20px">
        <b class="colorOrigen"><label>Área Origen:</label></b>

        <div id="divAreaOrigen">
        </div>
    </div>
</div>

<div class="row-fluid span-12">
    <div class="span4">
        <b class="colorDestino"><label>Obra Destino:</label></b>
        <g:select name="obra_destino" from="${janus.Obra.list()}" optionKey="id" optionValue="nombre"
                  noSelection="['-1': 'Seleccione una obra...']" style="width: 400px;font-size: 10px;" id="obraDes"
                  value="${obra?.id}"/>
    </div>

    <div class="span4">
        <b class="colorDestino"><label>Subpresupuesto Destino:</label></b>

        <div id="divDestino">

        </div>
    </div>
    %{--
        <div class="span4" style="margin-left: -20px">
            <b class="colorDestino"><label>Área Destino:</label></b>
            <div id="divAreaDestino">
            </div>
        </div>
    --}%
</div>




<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width: 10px;">
            *
        </th>
        <th style="width: 20px;">
            #
        </th>
        <th style="width: 200px;">
            Subpresupuesto
        </th>
        <th style="width: 80px;">
            Código
        </th>
        <th style="width: 400px;">
            Rubro
        </th>
        <th style="width: 60px" class="col_unidad">
            Unidad
        </th>
        <th style="width: 80px">
            Cantidad
        </th>
        <th class="col_precio" style="display: none;">Unitario</th>
        <th class="col_total" style="display: none;">C.Total</th>
    </tr>
    </thead>
</table>


<div style="width: 99.7%;height: 600px;overflow-y: auto;float: right;" id="detalle"></div>


<div id="faltaOrigenDialog">
    <fieldset>
        <div class="span3">
            Para continuar seleccione un subpresupuesto de origen y uno de destino, con sus respectivas áreas.
        </div>
    </fieldset>
</div>

<div id="obrasIguales">
    <fieldset>
        <div class="span3">
            Seleccione una obra de destino distinta a la de origen.
        </div>
    </fieldset>
</div>

<div id="marcados">
    <fieldset>
        <div class="span3">
            Por favor seleccione almenos un rubro a copiar.
        </div>
    </fieldset>
</div>

<div id="confirmarDlg">
    <fieldset>
        <div class="span3">
            Confirme la orden de copiar los rubros del área seleccionada a la obra de destino.
        </div>
    </fieldset>
</div>

<div id="seleccionadosDlg">
    <fieldset>
        <div class="span3">
            Confirme la orden de copiar los rubros seleccionados a la obra de destino, se pasarán al área seleccionada en la obra de origen.
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    cargarComboOrigen($("#obraSel").val());

    function cargarComboOrigen(obra) {
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'volumenObra',action:'origen_ajax')}",
            data: {
                obra: obra
            },
            success: function (msg) {
                $("#divOrigen").html(msg)
            }
        });
    }

    $("#obraSel").change(function () {
        var obra = $("#obraSel").val()
        $("#detalle").html('')
        cargarComboOrigen(obra)
    });


    cargarComboDestino($("#obraDes").val());

    function cargarComboDestino(obra) {
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'volumenObra',action:'cargarSubDestino_ajax')}",
            data: {
                obra: obra
            },
            success: function (msg) {
                $("#divDestino").html(msg)
            }
        });
    }

    $("#obraDes").change(function () {
        var obra = $("#obraDes").val()
//        $("#detalle").html('')
        cargarComboDestino(obra)
    });


    function loading(div) {
        y = 0;
        $("#" + div).html("<div class='tituloChevere' id='loading'>Sistema Fontus - Cargando, Espere por favor</div>")
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
        var obra = $("#obraSel").val();
        var sub = $("#subPresOrigen").val()
        var area = $("#areaCopiar").val()
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'volumenObra',action:'tablaCopiarRubro')}",
            data: {
                obra: obra,
                sub: sub,
                area: area
            },
            success: function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    }

    //        cargarTabla();


    $("#copiar_todos").click(function () {
        var subPresDest = $("#subPres_destino").val()
        var subPre = $("#subPresOrigen").val()
        var areaOrigen = $("#areaCopiar").val()
        var obraDestino = $("#obraDes").val()
        var obraOrigen = $("#obraSel").val()

        if (areaOrigen == "-1" || subPresDest == "-1") {
            $("#faltaOrigenDialog").dialog("open")
        } else if (obraOrigen == obraDestino) {
            console.log('iguales')
            $("#obrasIguales").dialog("open")
        } else {
            console.log('todos')
            $("#confirmarDlg").dialog("open")
        }
    });


    $("#copiar_sel").click(function () {
        var subPresDest = $("#subPres_destino").val()
        var subPre = $("#subPresOrigen").val()
        var areaOrigen = $("#areaCopiar").val()
        var obraDestino = $("#obraDes").val()
        var obraOrigen = $("#obraSel").val()

        if (areaOrigen == "-1" || subPresDest == "-1") {
            $("#faltaOrigenDialog").dialog("open")
        } else if (obraOrigen == obraDestino) {
            console.log('iguales')
            $("#obrasIguales").dialog("open")
        } else if ($('.chec:checkbox:checked').size() == 0){
            console.log('no hay marcados')
            $("#marcados").dialog("open")
        } else {
            $("#seleccionadosDlg").dialog("open")
        }
//        var marcados = $('.chec:checkbox:checked').size();
    });

    $("#faltaOrigenDialog").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 200,
        position: 'center',
        title: 'Elegir subpresupuestos!',
        buttons: {
            "Aceptar": function () {
                $("#faltaOrigenDialog").dialog("close");
            }
        }
    });

    $("#obrasIguales").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 200,
        position: 'center',
        title: 'La obra de destino es igual a la de origen',
        buttons: {
            "Aceptar": function () {
                $("#obrasIguales").dialog("close");
            }
        }
    });

    $("#marcados").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 200,
        position: 'center',
        title: 'No ha seleccionado ningún rubro',
        buttons: {
            "Aceptar": function () {
                $("#marcados").dialog("close");
            }
        }
    });

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'volumenObra', action: 'volObra', id: obra?.id)}"
    });

    $("#confirmarDlg").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 160,
        position: 'center',
        title: 'Copiar rubros a la obra de destino',
        buttons: {
            "Aceptar": function () {
                var tbody = $("#tabla_material");
                var datos
                var subPresDest = $("#subPres_destino").val()
                var subPre = $("#subPresOrigen").val()
                var areaOrigen = $("#areaCopiar").val()
                var obraDestino = $("#obraDes").val()
                tbody.children("tr").each(function () {
                    var trId = $(this).attr("id");
                    datos = "rubro=" + trId + "&subDest=" + subPresDest + "&obra=" + ${obra.id} +"&sub=" + subPre +
                            "&areaOrigen=" + areaOrigen + "&obraDestino=" + obraDestino;
                    $.ajax({
                        type: "POST",
                        url: "${g.createLink(controller: 'volumenObra',action:'copiarItem')}",
                        data: datos,
                        success: function (msg) {
                            $("#detalle").html(msg)
                        }
                    });
                });
                $("#confirmarDlg").dialog("close");
            },
            "Cancelar": function () {
                $("#confirmarDlg").dialog("close");
            }
        }
    });

    $("#seleccionadosDlg").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 200,
        position: 'center',
        title: 'Copiar rubros seleccionados a la obra de destino',
        buttons: {
            "Aceptar": function () {
                var tbody = $("#tabla_material");
                var datos
                var subPresDest = $("#subPres_destino").val()
                var subPre = $("#subPresOrigen").val()
                var areaOrigen = $("#areaCopiar").val()
                var obraDestino = $("#obraDes").val()
                tbody.children("tr").each(function () {
                    if (($(this).children("td").children().get(1).checked) == true) {
                        var selec = []
                        var trId = $(this).attr("id")
                        var ord = $(this).attr("ord")
                        var canti = $(this).attr("cant")
                        datos = "&rubro=" + trId + "&subDest=" + subPresDest + "&obra=" + ${obra.id} +"&sub=" + subPre + "&orden=" + ord +
                                "&canti=" + canti + "&areaOrigen=" + areaOrigen + "&obraDestino=" + obraDestino;
                        $.ajax({
                            type: "POST",
                            async: false,
                            url: "${g.createLink(controller: 'volumenObra',action:'copiarItem')}",
                            data: datos,
                            success: function (msg) {
                                $("#detalle").html(msg)
                            }
                        });
                    }
                });
                $("#seleccionadosDlg").dialog("close");
            },
            "Cancelar": function () {
                $("#seleccionadosDlg").dialog("close");
            }
        }
    });



</script>
</body>
</html>