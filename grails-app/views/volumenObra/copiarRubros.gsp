
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
    <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.ui.position.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.js')}" type="text/javascript"></script>
    <link href="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.contextMenu.css')}" rel="stylesheet" type="text/css"/>
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

<div class="span2" style="margin-bottom: 10px">
    <a href="#" class="btn" id="regresar" title="Regresar a Volúmnes de Obra">
        <i class="icon-arrow-left"></i>
        Regresar
    </a>
</div>

<div class="row-fluid span-12">
    <div class="span5">
        <b>Obra:</b>
        <g:select name="obra" from="${janus.Obra.list()}" optionKey="id" optionValue="descripcion"
                  noSelection="['-1' : 'Seleccione una obra...' ]" style="width: 300px;font-size: 10px; margin-left: 50px" id="obraSel" value="${obra?.id}"></g:select>
    </div>
    <div class="span6" >
        <b class="span4">Subpresupuesto de origen:</b>
        <div class="span4" id="divOrigen">
        </div>
    </div>
</div>

<div class="row-fluid span-12">
    <div class="span5">
    </div>
    <div class="span6">
        <b class="span4">Subpresupuesto de destino:</b>
        <div class="span4">
            <g:select name="subpresupuestoDes" from="${subPres}" optionKey="id" optionValue="descripcion" style="width: 300px;font-size: 10px;" id="subPres_destino"
                      noSelection="['-1' : 'Seleccione un subpresupuesto...']" title="${"Obra: " + obra?.descripcion}"></g:select>
        </div>
    </div>
</div>

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
            Para continuar seleccione un presupuesto de origen y uno de destino.
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    cargarComboOrigen($("#obraSel").val());

    function cargarComboOrigen(obra) {
        $.ajax({type : "POST",
            url : "${g.createLink(controller: 'volumenObra',action:'origen_ajax')}",
            data     : {
                obra: obra
            },
            success  : function (msg) {
                $("#divOrigen").html(msg)
            }
        });
    }

    $("#obraSel").change(function(){
        var obra = $("#obraSel").val()
        $("#detalle").html('')
        cargarComboOrigen(obra)

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
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObra',action:'tablaCopiarRubro')}",
            data : {
                obra: obra,
                sub: sub
            },
            success  : function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    }

    //        cargarTabla();



    $("#copiar_todos").click(function () {

        var tbody = $("#tabla_material");
        var datos
        var subPresDest = $("#subPres_destino").val()
        var subPre = $("#subPresOrigen").val()

        if(subPre == "-1" || subPresDest == "-1"){
            $("#faltaOrigenDialog").dialog("open")
        } else {
            tbody.children("tr").each(function () {
                var trId = $(this).attr("id")
                datos ="rubro=" + trId + "&subDest=" + subPresDest + "&obra=" + ${obra.id} + "&sub=" + subPre
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'volumenObra',action:'copiarItem')}",
                    data     : datos,
                    success  : function (msg) {
                        $("#detalle").html(msg)
                    }
                });
            });
        }
    });


    $("#copiar_sel").click(function () {

        var tbody = $("#tabla_material");
        var datos
        var subPresDest = $("#subPres_destino").val()
        var subPre = $("#subPresOrigen").val()
        var rbros = []

        tbody.children("tr").each(function () {

            if(($(this).children("td").children().get(1).checked) == true){
                var selec = []
                var trId = $(this).attr("id")
                var ord = $(this).attr("ord")
                var canti = $(this).attr("cant")

                datos ="&rubro=" + trId + "&subDest=" + subPresDest + "&obra=" + ${obra.id} + "&sub=" + subPre + "&orden=" + ord + "&canti=" + canti

                $.ajax({
                    type : "POST",
                    async : false,
                    url : "${g.createLink(controller: 'volumenObra',action:'copiarItem')}",
                    data     : datos,
                    success  : function (msg) {
                        $("#detalle").html(msg)
                    }
                });

            } else {
            }

        });
    });

    $("#faltaOrigenDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 150,
        position  : 'center',
        title     : 'Elegir subpresupuestos!',
        buttons   : {
            "Aceptar" : function () {
                $("#faltaOrigenDialog").dialog("close");
            }
        }
    });



</script>
</body>
</html>