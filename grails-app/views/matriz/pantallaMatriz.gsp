<%@ page import="janus.Obra" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        ${titulo}
    </title>
    <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.onscreen.js')}"></script>
    <script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>
    <link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">
    <script src="${resource(dir: 'js/jquery/plugins/jQuery-contextMenu-gh-pages/src', file: 'jquery.ui.position.js')}"
            type="text/javascript"></script>
    <style type="text/css">
    .gr {
        background-color: #ececec;
    }

    .a1 {
        background-color: rgba(255, 172, 55, 0.8);
        font-weight: bold;
    }

    .bl {
        background-color: transparent;
    }

    .estaticas {
        background: linear-gradient(to bottom, #FFFFFF, #E6E6E6);
        font-weight: bold;
    }

    tr {
        cursor: pointer !important;
    }

    th {
        padding-left: 0px;
        padding-right: 0px;
    }

    td {
        line-height: 12px !important;
        padding: 3px !important;
        font-size: 10px !important;
        text-align: right !important;
    }

    .lb {
        text-align: left !important;
    }

    .sc {
        background-color: rgba(120, 220, 249, 0.4);
        font-weight: bold;
    }

    .mano {
        background-color: rgba(244, 198, 162, 0.5);
    }

    .saldo {
        background-color: #ffcfd6;
    }

    .totalCol {
        background-color: #85d0c9;
    }
    .hh {
        display: none;
    }
    </style>

    <script type="text/javascript">
        $("#dlgLoad").dialog("open");
    </script>
</head>

<body>
<div class="span12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </g:if>
</div>

<div class="span10 btn-group" role="navigation" style="margin-left: 0px;">
    <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra])}"
       class="btn btn-ajax btn-new" id="atras" title="Regresar a la obra">
        <i class="icon-arrow-left"></i>
        Regresar
    </a>
    <g:link controller="formulaPolinomica" action="insertarVolumenesItem" class="btn btn-ajax btn-new btnFormula"
            params="[obra: obra, sbpr: params.sbpr]" title="Coeficientes">
        <i class="icon-table"></i>
        Fórmula polinómica
    </g:link>

    <button style="border: none; margin-left: 20px;">Buscar Columna:</button>
    <input type="text" style="width: 100px;margin-top: 9px;" class="ui-corner-all" id="texto_busqueda">
    <a href="#" class="btn btn-ajax btn-new" id="buscar" title="Buscar">
        <i class="icon-search"></i>
        Buscar
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="reset" title="Resetear">
        <i class="icon-refresh"></i>
        Limpiar selección
    </a>
    %{--<a href="${g.createLink(controller: 'reportes5', action: 'reporteMatriz', id: "${obra}")}" class="btn btn-ajax btn-new"--}%
       %{--id="reset" title="Resetear">--}%
        %{--<i class="icon-print"></i>--}%
        %{--Excel--}%
    %{--</a>--}%

    <a href="#" class="btn btn-success" id="imprimir_matriz"><i class="icon-print"></i> Excel</a>
    <a href="${g.createLink(controller: 'reportes2', action: 'reporteDesgloseEquipos', id: "${obra}")}"
       class="btn btn-ajax btn-new" id="desglose" title="Desglose Equipos">
        <i class="icon-print"></i>
        Imprimir Desglose
    </a>
</div>

<div class="span2 btn-group" role="navigation" style="float: right; margin-top: 8px">
    <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: 0, sbpr: 0])}"
       class="btn btn-ajax btn-new btn-info" id="inicio" title="Inicio de la tabla">
        <i class="icon-caret-left"></i>
    </a>
    <g:if test="${cont != 0}">
        <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: (cont - 30), sbpr: 0])}"
           class="btn btn-ajax btn-new btn-success" id="anterior" title="Anterior">
            <i class="icon-arrow-left"></i> # ${cont}
        </a>
    </g:if>

    <g:if test="${offset < cont2}">
        <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: (offset - 1), sbpr: 0])}"
           class="btn btn-ajax btn-new btn-success" id="siguiente" title="Siguiente">
            <i class="icon-arrow-right"></i> # ${offset}
        </a>
    </g:if>


    <a href="${g.createLink(controller: 'matriz', action: 'pantallaMatriz', id: "${obra}", params: [offset: cont2 - 6, sbpr: 0])}"
       class="btn btn-ajax btn-new btn-info" id="fin" title="Fin de la tabla">
        <i class="icon-caret-right"></i>
    </a>
</div>

<div id="list-grupo" role="main" style="margin-top: 10px;margin-left: 0;width: 110%;max-width: 110%;overflow-x: auto">
    <div style="width: 140px; float: left">
    <table class="table table-bordered table-condensed" id="tablaHeaders" style="width:140px;max-width:140px;">
        <thead style="height: 120px">
        <tr style="font-size: 10px !important;" id="ht">
            <th style="width: 20px;max-width: 30px;font-size: 12px !important" class="h_0">#</th>
            <th style="width: 60px;font-size: 12px !important" class="h_1">Código</th>
            <th style="width: 60px;font-size: 12px !important;" class="h_1 hh">Código</th>
        </tr>
        </thead>
        ${filasF}
    </tbody>
    </table>
    </div>
    <div style="width: 1100px;overflow-x: auto;" class="scroll-pane">


        <table class="table table-bordered table-condensed" id ="matriz" style="width: ${cols.size() * 120 - 90}px; max-width: ${cols.size() * 120 - 90}px;float:left">
        %{--<table class="table table-bordered table-condensed">--}%
            <thead style="height: 120px">
            <tr style="font-size: 10px !important;">
                %{--<th style="width: 20px;max-width: 30px;font-size: 12px !important" class="h_0">#</th>--}%
                %{--<th style="width: 60px;;font-size: 12px !important" class="h_1">Código</th>--}%
                <th style="width: 320px !important;;font-size: 12px !important">Rubro</th>
                <th style="width: 30px;;font-size: 12px !important">Unidad</th>
                <th style="width: 60px;;font-size: 12px !important">Cantidad</th>
                <g:each in="${cols}" var="c" status="k">
                    <g:if test="${c[2] != 'R'}">
                        <th style="width: 120px;font-size: 12px !important" class="c_${k}" c="${k}">${c[1]}</th>
                    </g:if>
                </g:each>
            </tr>
            </thead>
            <tbody id="tableBody" class="scroll-content">
            ${filas}
            </tbody>
            <tfoot>
            <tr id="bandera">
            </tr>
            </tfoot>
        </table>
    </div>
</div>

<div class="modal hide fade" id="modal-imprimir" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modal_title_impresion">
        </h3>
    </div>

    <div class="modal-body" id="modal_body_impresion">
        <div id="msg_impr">

            <span style="margin-left: 0px;">Rango de columnas de la Matriz a exportar: </span>
            <g:select name="seccion_matriz" from="${listaImpresion}" optionKey="key" optionValue="value"
                      style="margin-right: 20px; width: 240px" id="seleccionadoImpresion"/>

            <div style="float: right">
                <a href="#" class="btn btn-success" id="imprimirSeleccionado"><i class="icon-print"></i> Generar Excel</a>
                <a href="#" class="btn btn-primary" id="cancelarImpresion">Cancelar</a>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">


    $("#cancelarImpresion").click(function () {
        $("#modal-imprimir").modal("hide")
    });

    $("#imprimirSeleccionado").click(function () {
        var seleccionado = $("#seleccionadoImpresion").val()
        location.href = "${g.createLink(controller: 'reportes5',action: 'nuevoReporteMatriz',id: obra)}?sel=" + seleccionado;
    });

    $("#imprimir_matriz").click(function () {
        if(${existeRubros.toInteger() != 0}){
            $("#modal_title_impresion").html("Exportar Matriz a Excel");
            $("#msg_impr").show();
            $("#modal-imprimir").modal("show")
        }else{
            alert("No existen datos para exportar!")
        }
    });


    %{--$("#siguiente").click(function () {--}%
        %{--$.ajax({--}%
            %{--type: 'POST',--}%
            %{--url: '${createLink(controller: 'matriz', action: 'pantallaMatriz')}',--}%
            %{--data:{--}%
                %{--id: ${obra},--}%
                %{--offset: 20--}%
            %{--}--}%
        %{--})--}%
    %{--});--}%



    var ban = 0

    $(function () {
//        $("#dlgLoad").dialog("open");
        var inicio = 0
//        cargarDatosAsinc(inicio, "interval", 50)
        inicio = 2
        var fin = false
        var ultimo = 1
        var ctrl = 0


        $("body").keydown(function (ev) {
            if (ev.keyCode == 17)
                ctrl = 600
            if (ev.keyCode == 16)
                ctrl = 60000
        });

        var interval = setInterval(function () {
            if ($("#bandera:onScreen").attr("id")) {
                if (!fin) {
//                    if (inicio > ultimo) {
//                        $("#dlgLoad").dialog("open");
//                        fin = cargarDatosAsinc(inicio, "interval", 20)
//                        ultimo = inicio
//                        if (!fin)
//                            inicio++
//                        $(document).scrollTop($(document).scrollTop() - 300)
//                    }
                } else {
                    clearInterval(interval)
                }
            }
        }, 2000);


        $(".rb").bind("click", function () {
            if (ban == 0) {
                if ($(this).hasClass("a1")) {
                    $("." + $(this).attr("f")).addClass($(".a1").attr("color")).removeClass("a1")
//                    $(this).removeClass("a1")
                } else {
                    $(this).addClass("a1")
                    $("." + $(this).attr("f")).addClass("a1")
                    $("." + $(this).attr("f")).removeClass("gr")
                    $("." + $(this).attr("f")).removeClass("bl")
                }
            }
        });

        $("th").click(function () {
            var clase = "c_" + $(this).attr("c")
            if ($(this).hasClass("sc")) {
                $("." + clase).removeClass("sc")
            } else {
                $("." + clase).addClass("sc")
            }
        });

        $("body").keyup(function (ev) {
            if (ev.keyCode == 17)
                ctrl = 0
            if (ev.keyCode == 16)
                ctrl = 0
            if (ev.keyCode == 37) {
                var leftPos = $('.scroll-pane').scrollLeft();
                $(".scroll-pane").animate({scrollLeft: leftPos - (300 + ctrl)}, 800);

            }
            if (ev.keyCode == 39) {
                var leftPos = $('.scroll-pane').scrollLeft();
                $(".scroll-pane").animate({scrollLeft: leftPos + 300 + ctrl}, 800);
            }
        });

        $("#buscar").click(function () {
            var par = $("#texto_busqueda").val()
            var primero = null
            if (par.length > 0) {
                var mayus = par.toUpperCase()
                $("th").each(function () {
                    if ($(this).html().toUpperCase().match(mayus)) {
                        if (!$(this).hasClass("sc"))
                            $(this).click();
                        if (!primero)
                            primero = $(this)
                    }
                });
                if (primero) {
                    var leftPos = $('.scroll-pane').scrollLeft() + 500;
                    var pos = primero.position().left - 500
                    $(".scroll-pane").animate({scrollLeft: leftPos + pos - 500}, 800);
                }
            }
        });

        $("#reset").click(function () {
            $(".a1").addClass($(".a1").attr("color")).removeClass("a1")
            $(".sc").removeClass("sc")
        });

        function fp(url) {
            $("#dlgLoad").dialog("open");
            $.ajax({
                async: false,
                type: "POST",
                url: url,
                success: function (msg2) {
                    console.log(msg2)
                    var arr = msg2.split("_")
                    var msg_ok = arr[0]
                    var sbpr = arr[1]
                    if (msg_ok == "ok" || msg_ok == "OK") {
                        location.href = "${createLink(controller: 'formulaPolinomica', action: 'coeficientes', id:obra)}?sbpr=" + sbpr;
                    }
                }
            });
        }

        $(".btnFormula").click(function () {
            var url = $(this).attr("href");
            $.ajax({
                type: "POST",
                async: false,
                url: "${createLink(controller: 'obra', action: 'existeFP')}",
                data: {
                    obra: "${obra}"
                },
                success: function (msg) {
                    if (msg == "true" || msg == true) {
                        //ya hay la fp
                        fp(url);
                    } else {
                        //no hay la fp
                        $.box({
                            imageClass: "box_info",
                            text: "Asegúrese de que ya ha ingresado todos los rubros para generar la fórmula polinómica.",
                            title: "Confirmación",
                            iconClose: false,
                            dialog: {
                                resizable: false,
                                draggable: false,
                                closeOnEscape: false,
                                buttons: {
                                    "Continuar": function () {
                                        fp(url);
                                    },
                                    "Cancelar": function () {
                                    }
                                }
                            }
                        });
                    }
                }
            });
            return false;
        });


        $( document ).ready(function() {
            var rowCount = $('#matriz tr').length;
            var ht = 0;
            var contador = ${cont + 1}

//            console.log( "ready!" + contador);
            for (i = 0; i < rowCount; i++) {
                ht = $("#r" + (i + contador)).innerHeight()
                $("#rf" + (i + contador)).css({"height": ht})
            }
        });

    });

</script>

</body>
</html>