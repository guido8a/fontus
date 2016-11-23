<style>
.desalojo { color: #4d2868; }
</style>

<div class="row-fluid" style="margin-left: 0px">
    <g:if test="${msg}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status" style="width: 80%">${msg}</div>
    </g:if>
    <div class="span-6" style="margin-bottom: 5px">
        <b>Subpresupuesto:</b>
        <g:select name="subpresupuesto" from="${subPres}" optionKey="id" optionValue="descripcion"
                  style="width: 500px;font-size: 12px; margin-right: 10px" id="subPres_desc" value="${subPre}"
                  noSelection="['-1': 'Seleccione..']"/>

        <a href="#" class="btn btn-ajax btn-new ${params.ord == '1'? 'active': ''}" id="ordenarAsc" title="Ordenar Ascendentemente">
            <i class="icon-arrow-up"></i>
        </a>
        <a href="#" class="btn btn-ajax btn-new ${params.ord == '2'? 'active': ''}" id="ordenarDesc" title="Ordenar Descendentemente">
            <i class="icon-arrow-down"></i>
        </a>


        <a href="#" class="btn  " id="copiar_rubros">
            <i class="icon-copy"></i>
            Copiar Rubros
        </a>

        <a href="#" class="btn  " id="imprimirSub">
            <i class="icon-print"></i>Imprimir
        </a>

        %{--<a href="#" class="btn  " id="imprimir_sub">--}%
        %{--<i class="icon-print"></i>--}%
        %{--Impr. Subpre.--}%
        %{--</a>--}%
        %{--<a href="#" class="btn  " id="imprimir_excel" style="margin-left:-7px">--}%
        %{--<i class="icon-table"></i>--}%
        %{--Excel--}%
        %{--</a>--}%

        %{--<a href="#" class="btn  " id="imprimir_sub_vae">--}%
        %{--<i class="icon-print"></i>--}%
        %{--Subpre. VAE--}%
        %{--</a>--}%
        %{--<a href="#" class="btn  " id="imprimir_vae_excel">--}%
        %{--<i class="icon-table"></i>--}%
        %{--VAE Excel--}%
        %{--</a>--}%
    </div>
</div>
<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width: 20px;">
            #
        </th>
        <th style="width: 120px;">
            Subpresupuesto
        </th>
        <th style="width: 100px;">
            Área
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
        <th style="width: 80px">
            Cantidad
        </th>
        <th class="col_precio" style="display: none;">Unitario</th>
        <th class="col_total" style="display: none;">C.Total</th>
        <g:if test="${obra.estado!='R' && duenoObra == 1}">
            <th style="width: 40px" class="col_delete"></th>
        </g:if>
    </tr>
    </thead>
    <tbody id="tabla_material">

    <g:each in="${valores}" var="val" status="j">
    %{--<tr class="item_row" id="${val.item__id}" item="${val}" sub="${val.sbpr__id}">--}%
        <tr class="item_row ${val.rbrocdgo[0..1] == 'TR'? 'desalojo':''}" id="${val.vlob__id}" item="${val}"
            dscr="${val.vlobdscr}" sub="${val.sbpr__id}" cdgo="${val.item__id}" title="${val.vlobdscr}" area="${val.area__id}">

            <td style="width: 20px" class="orden">${val.vlobordn}</td>
            <td style="width: 200px" class="sub">${val.sbprdscr.trim()}</td>
            <td class="cdes">${val.area?.trim()}</td>
            <td class="cdgo">${val.rbrocdgo.trim()}</td>
            <td class="nombre">${val.rbronmbr.trim()}</td>
            <td style="width: 60px !important;text-align: center" class="col_unidad">${val.unddcdgo.trim()}</td>
            <td style="text-align: right" class="cant">
                <g:formatNumber number="${val.vlobcntd}" format="##,##0" minFractionDigits="2" maxFractionDigits="2"
                                locale="ec"/>
            </td>
            <td class="col_precio" style="display: none;text-align: right" id="i_${val.item__id}"><g:formatNumber
                    number="${val.pcun}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td class="col_total total" style="display: none;text-align: right">
                <g:formatNumber number="${val.totl}" format="##,##0" minFractionDigits="2"  maxFractionDigits="2"  locale="ec"/>
            </td>
            <g:if test="${obra.estado!='R' && duenoObra == 1}">
                <td style="width: 40px;text-align: center" class="col_delete">
                    <a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar"
                       iden="${val.vlob__id}">
                        <i class="icon-trash"></i></a>
                </td>
            </g:if>
        </tr>
    </g:each>

    </tbody>
</table>


<div id="borrarDialog">
    <fieldset>
        <div class="span3">
            Está seguro que desea borrar este rubro?
        </div>
    </fieldset>
</div>


<div id="imprimirSubpresupuesto" style="height: 150px !important;">
    <fieldset>
        <div class="span3" style="margin-top: 5px;">
            <g:checkBox name="todos_name" class="todosSub" /> Imprimir todos los subpresupuestos.
        </div>
        <g:if test="${session.perfil.codigo == 'CSTO'}">
            <div class="span3" style="margin-top: 5px;">
                <g:checkBox name="vae_name" class="vaeSub" /> VAE
            </div>
        </g:if>
    </fieldset>
</div>



<script type="text/javascript">

    var todosCheck
    var vaeCheck

    $(".todosSub").click(function () {
        todosCheck = $(this).prop("checked")
    });

    $(".vaeSub").click(function () {
        vaeCheck = $(this).prop("checked")
    });

    $("#imprimirSub").click(function () {

        if ($("#subPres_desc").val() != '' && $("#subPres_desc").val() != -1 ) {
            $("#imprimirSubpresupuesto").dialog("open");
        }else{
            alert("Para imprimir primero debe seleccionar un subpresupuesto!")
        }
    });

    $("#imprimirSubpresupuesto").dialog({

        autoOpen  : false,
        resizable : false,
        modal     : true,
        dragable  : false,
        width     : 350,
        height    : 220,
        position  : 'center',
        title     : 'Imprimir Subpresupuesto',

        buttons   : {
            'PDF' : function () {

                var sub
                if(todosCheck == true){
                    sub = -1
                }else{
                    sub = $("#subPres_desc").val()
                }
                var perf = 0

                if(${session.perfil.codigo == 'CSTO'}){
                    perf = 1
                }

                if (vaeCheck != true){
                    var dsps =
                    ${obra.distanciaPeso}
                    var dsvs =
                    ${obra.distanciaVolumen}

                    var datos = "?obra=${obra.id}Wsub=" + sub + "Wperf=" + perf
                    var url = "${g.createLink(controller: 'reportes3',action: 'imprimirTablaSub')}" + datos
                    location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
                }else{
                    var dsps =
                    ${obra.distanciaPeso}
                    var dsvs =
                    ${obra.distanciaVolumen}
                    var datos = "?obra=${obra.id}Wsub=" + sub
                    var url = "${g.createLink(controller: 'reportes3',action: 'imprimirTablaSubVae')}" + datos
                    console.log(url)
                    location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
                }
                $("#imprimirSubpresupuesto").dialog("close");
            },
            "Excel" : function () {
                var subExcel
                if(todosCheck == true){
                    subExcel = -1
                }else{
                    subExcel = $("#subPres_desc").val()
                }

                if (vaeCheck != true){
                    location.href = "${g.createLink(controller: 'reportes',action: 'reporteExcelVolObra',id: obra?.id)}?sub=" + subExcel + "Wperf=" + perf;
                }else{
                    location.href = "${g.createLink(controller: 'reportes5',action: 'reporteVaeExcel',id: obra?.id)}?sub=" + subExcel;
                }
                $("#imprimirSubpresupuesto").dialog("close");
            },
            "Cancelar" :  function () {
                $("#imprimirSubpresupuesto").dialog("close");
            }
        }
    });




    $.contextMenu({
        selector: '.item_row',
        callback: function (key, options) {
            var m = "clicked: " + $(this).attr("id");
            if (key == "print") {

            }

            if (key == "foto") {
                %{--var child = window.open('${createLink(controller:"rubro",action:"showFoto")}/'+$(this).attr("item"), 'Mies', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');--}%
                var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("cdgo") +
                        '?tipo=il', 'GADPP', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
                if (child.opener == null)
                    child.opener = self;
                window.toolbar.visible = false;
                window.menubar.visible = false;
            }

            if (key == "espc") {
                %{--var child = window.open('${createLink(controller:"rubro", action:"showFoto")}/' + $(this).attr("cdgo") +--}%
                %{--'?tipo=dt', 'GADPP', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');--}%
                %{--if (child.opener == null)--}%
                %{--child.opener = self;--}%
                %{--window.toolbar.visible = false;--}%
                %{--window.menubar.visible = false;--}%

                var rubro = $(this).attr("id");
                var url = "${g.createLink(controller: 'reportes5',action: 'reporteEspecificaciones')}?rub=" + rubro + "Wpar=" + 1
                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url

            }

            if (key == 'print-key1') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                %{--var volqueta = ${precioVol}--}%
                %{--var chofer = ${precioChof}--}%
                var clickImprimir = $(this).attr("id");

//                console.log("c" + clickImprimir)

                var fechaSalida1 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}'

                %{--var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid="+$(".item_row").attr("id") +"Wobra=${obra.id}"--}%
                var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid=" + clickImprimir + "Wobra=${obra.id}" + "WfechaSalida=" + fechaSalida1
                var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubroVolObra')}" + datos
                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
            }

            if (key == 'print-key2') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                %{--var volqueta = ${precioVol}--}%
                %{--var chofer = ${precioChof}--}%
                var clickImprimir = $(this).attr("id");
                var fechaSalida2 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}'

                %{--var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid="+$(".item_row").attr("id") +"Wobra=${obra.id}" + "Wdesglose=${1}"--}%
                var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid=" + clickImprimir + "Wobra=${obra.id}" + "Wdesglose=${1}" + "WfechaSalida=" + fechaSalida2

                var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubroVolObra')}" + datos
                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
            }

            if (key == 'print-key3') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                %{--var volqueta = ${precioVol}--}%
                %{--var chofer = ${precioChof}--}%
                var clickImprimir = $(this).attr("id");
//                console.log("c" + clickImprimir)

                var fechaSalida1 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}'
                %{--var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid="+$(".item_row").attr("id") +"Wobra=${obra.id}"--}%
                var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid=" + clickImprimir + "Wobra=${obra.id}" + "WfechaSalida=" + fechaSalida1

                var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubroVolObraVae')}" + datos
                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
            }

            if (key == 'print-key4') {
                var dsps =
                ${obra.distanciaPeso}
                var dsvs =
                ${obra.distanciaVolumen}
                %{--var volqueta = ${precioVol}--}%
                %{--var chofer = ${precioChof}--}%
                var clickImprimir = $(this).attr("id");
                var fechaSalida2 = '${obra.fechaOficioSalida?.format('dd-MM-yyyy')}';
                %{--var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid="+$(".item_row").attr("id") +"Wobra=${obra.id}" + "Wdesglose=${1}"--}%
                var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid=" + clickImprimir + "Wobra=${obra.id}" + "Wdesglose=${1}" + "WfechaSalida=" + fechaSalida2
                var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubroVolObraVae')}" + datos;
//                console.log("url "  + url)
                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
            }
        },

        %{--<g:if test="${obra?.estado!='R'}">--}%
        items: {
//            "edit": {name: "Editar", icon: "edit"},
            "print": {name: "Imprimir", icon: "print",
                items: {
                    "print-key1": {"name": "Imprimir sin Desglose", icon: "print"
                    },
                    "print-key2": {"name": "Imprimir con Desglose", icon: "print"},
                    "print-key3": {"name": "Imprimir VAE sin Desglose", icon: "print"},
                    "print-key4": {"name": "Imprimir VAE con Desglose", icon: "print"}
                }
            },
            "foto": {name: "Ilustración", icon: "doc"},
            "espc": {name: "Especificaciones", icon: "doc"}
        }
    });

    $("#imprimir_sub").click(function () {
        if ($("#subPres_desc").val() != '') {
            var dsps =
            ${obra.distanciaPeso}
            var dsvs =
            ${obra.distanciaVolumen}
            var datos = "?obra=${obra.id}Wsub=" + $("#subPres_desc").val()
            var url = "${g.createLink(controller: 'reportes3',action: 'imprimirTablaSub')}" + datos
            location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
        } else {
            alert("Escoja un subpresupuesto")
        }
    });


    $("#imprimir_sub_vae").click(function () {
        if ($("#subPres_desc").val() != '') {
            var dsps =
            ${obra.distanciaPeso}
            var dsvs =
            ${obra.distanciaVolumen}
            var datos = "?obra=${obra.id}Wsub=" + $("#subPres_desc").val()
            var url = "${g.createLink(controller: 'reportes3',action: 'imprimirTablaSubVae')}" + datos
            console.log(url)
            location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
        } else {
            alert("Escoja un subpresupuesto")
        }
    });

    $("#imprimir_vae_excel").click(function () {
        var valorSub = $("#subPres_desc").val()
        if ($("#subPres_desc").val() != '') {
            $("#dlgLoad").dialog("open");
            $.ajax({
                type: 'POST',
                url: "${g.createLink(controller: 'reportes5',action: 'reporteVaeExcel')}",
                data: {
                    id: '${obra?.id}',
                    sub: valorSub
                },
                success: function (msg) {
                    location.href = "${g.createLink(controller: 'reportes5',action: 'reporteVaeExcel',id: obra?.id)}?sub=" + $("#subPres_desc").val();
                    $("#dlgLoad").dialog("close");
                }
            });
        } else {
            alert("Escoja un subpresupuesto")
        }

    });


    $("#imprimir_excel").click(function () {

        $("#dlgLoad").dialog("open");

        $.ajax({
            type: 'POST',
            url: "${g.createLink(controller: 'reportes',action: 'reporteExcelVolObra')}",
            data: {
                id: '${obra?.id}'
            },
            success: function (msg) {
                location.href = "${g.createLink(controller: 'reportes',action: 'reporteExcelVolObra',id: obra?.id)}?sub=" + $("#subPres_desc").val();
                $("#dlgLoad").dialog("close");
//                spinner.replaceWith($boton);
            }
        });
    });

    $("#subPres_desc").change(function () {
        $("#ver_todos").removeClass("active")
        $("#divTotal").html("")
        $("#calcular").removeClass("active")

        var datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + 1
        var interval = loading("detalle")
        $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'tabla')}",
            data: datos,
            success: function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    });


    var datos = "?fecha=${obra.fechaPreciosRubros?.format('dd-MM-yyyy')}Wid=" + $(".item_row").attr("id") + "Wobra=${obra.id}"


    $(".item_row").dblclick(function () {
        $("#calcular").removeClass("active")
        $(".col_delete").show()
        $(".col_precio").hide()
        $(".col_total").hide()
        $("#divTotal").html("")
        //$("#vol_id").val($(this).attr("id"))     /* gdo: id del registro a editar */
        $("#vol_id").val($(this).attr("id"))     /* gdo: id del registro a editar */
        $("#item_codigo").val($(this).find(".cdgo").html())
        $("#item_id").val($(this).attr("item"))
        $("#sbpr").val($(this).attr("sub"))

        $("#area").val($(this).attr("area"))
        console.log('area', $("#area").val(), 'ok')

        $("#item_descripcion").val($(this).attr("dscr"))

        $("#item_nombre").val($(this).find(".nombre").html())
        $("#item_cantidad").val($(this).find(".cant").html().toString().trim())
        $("#item_orden").val($(this).find(".orden").html())
        /*
         $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra', action:'cargaCombosEditar')}",
         data: "id=" + $(this).attr("sub"),
         success: function (msg) {
         $("#div_cmb_sub").html(msg)
         }
         });
         */
//        //console.log($(this).attr("id"))
    });

    $(".borrarItem").click(function () {
        if (confirm("Esta seguro de eliminar el rubro?")) {
            $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'eliminarRubro')}",
                data: "id=" + $(this).attr("iden"),
                success: function (msg) {
                    $("#detalle").html(msg)
                }
            });
        }
    });

    $("#copiar_rubros").click(function () {
        location.href = "${createLink(controller: 'volumenObra', action: 'copiarRubros', id: obra?.id)}?obra=" +
        ${obra?.id}
    });

    $("#ordenarAsc").click(function () {
        $("#divTotal").html("")
        $("#calcular").removeClass("active")
        var orden = 1;
        var datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + orden
        var interval = loading("detalle")
        $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'tabla')}",
            data: datos,
            success: function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    });

    $("#ordenarDesc").click(function () {
        $("#divTotal").html("")
        $("#calcular").removeClass("active")
        var orden = 2;
        var datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + orden
        var interval = loading("detalle")
        $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'tabla')}",
            data: datos,
            success: function (msg) {
                clearInterval(interval)
                $("#detalle").html(msg)
            }
        });
    });

    $("#borrarDialog").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 200,
        position: 'center',
        title: 'Borrar',
        buttons: {
            "Aceptar": function () {
//                   console.log("-->>" + $(this).attr("iden"));
                $.ajax({type: "POST", url: "${g.createLink(controller: 'volumenObra',action:'eliminarRubro')}",
                    data: "id=" + $(this).attr("iden"),
                    success: function (msg) {
                        clearInterval(interval)
                        $("#detalle").html(msg)
                    }
                });
                $("#borrarDialog").dialog("close");
            },

            "Cancelar" : function () {
                $("#borrarDialog").dialog("close");
            }
        }
    });

</script>