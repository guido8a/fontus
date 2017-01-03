<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 29/12/16
  Time: 15:32
--%>
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/12/16
  Time: 14:46
--%>

<table class="table table-bordered table-striped table-condensed table-hover">
    <tbody id="tabla_material">
    <g:each in="${obras}" var="obra">
        <td style="width: 60px" >${obra?.obra?.codigo}</td>
        <td style="width: 330px" >${obra?.obra?.nombre}</td>
        <td style="width: 80px; text-align: right"><g:formatNumber number="${obra?.valor}" format="##,##0"
                                                                   minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
        <td style="width: 120px" title="${"Parroquia: " + obra?.obra?.parroquia?.nombre + " - Cantón: " +
                obra?.obra?.parroquia?.canton?.nombre}">${obra?.obra?.parroquia?.canton?.provincia?.nombre}</td>
        <g:if test="${contrato}">
            <td  style="width: 110px">
                <a href="#" class="btn btn-success btn-small planillaObra" iden="${obra?.id}" title="Planilla">
                    <i class="icon-calendar"></i>
                </a>
                <a href="#" class="btn btn-success btn-small avanceObra" iden="${obra?.id}" title="Informe de Avance">
                    <i class="icon-chevron-sign-right"></i>
                </a>
                <a href="#" class="btn btn-success btn-small imprimirRubros" iden="${obra?.obra?.id}" title="Imprimir rubros">
                    <i class="icon-print"></i>
                </a>
            </td>
        </g:if>
        </tr>
    </g:each>
    </tbody>
</table>


<div class="modal hide fade" id="modal-imprimir_excel" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modal_tittle_impresion_excel">
        </h3>
    </div>

    <div class="modal-body" id="modal_body_excel">
        <div id="msg_impr_excel">

            <span>Rango de rubros a exportar:  </span>
            <g:select name="seccion_matriz_excel" from="${rangoExcel}" optionKey="key" optionValue="value"
                      style="margin-left: 10px; width: 240px" id="seleccionadoImpresionExcel"/>

            <div style="float: right; margin-top: 20px;">
                <a href="#" class="btn btn-success" id="imprimirSeleccionadoExcel"><i class="icon-print"></i> Generar Excel</a>
                <a href="#" class="btn btn-primary" id="cancelarImpresionExcel">Cancelar</a>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">


    $(".imprimirRubros").click(function () {

        var idObra = $(this).attr('iden');

        var url = "${createLink(controller:'reportes', action:'imprimirRubros')}?obra=" + idObra + "Wdesglose=";
        var urlVae = "${createLink(controller:'reportes3', action:'reporteRubrosVaeReg')}?obra=" + idObra + "Wdesglose=";

                $.box({
                    imageClass: "box_info",
                    text: "Imprimir los análisis de precios unitarios de los rubros usados en la obra<br><span style='margin-left: 42px;'>Ilustraciones y Especificaciones</span>",
                    title: "Imprimir Rubros de la Obra",
                    iconClose: true,
                    dialog: {
                        resizable: false,
                        draggable: false,
                        width: 600,
                        height: ${session.perfil.codigo == 'CSTO'? 240 : 170},
                        buttons: {
                            <g:if test="${session.perfil.codigo == 'CSTO'}">
                            "Con desglose de Trans.": function () {
                                url += "1";
                                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
                            },
                            "Sin desglose de Trans.": function () {
                                url += "0";
                                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
                            },
                            "Exportar Rubros a Excel": function () {
                                $("#modal_tittle_impresion_excel").html("Imprimir Rubros a Excel");
                                $("#msg_impr_excel").show();
                                $("#modal-imprimir_excel").modal("show")
                            },
                            "VAE con desglose de Trans.": function () {
                                urlVae += "1";
                                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + urlVae
                            },
                            "VAE sin desglose de Trans.": function () {
                                urlVae += "0";
                                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + urlVae
                            },
                            "Exportar VAE a Excel": function () {
                                var urlVaeEx = "${createLink(controller:'reportes3', action:'imprimirRubrosVaeExcel')}?obra=" + idObra + "&transporte=";
                                urlVaeEx += "1";
                                location.href = urlVaeEx;
                            },
                            </g:if>
                            "Imprimir las Especificaciones de los Rubros utilizados en la Obra": function () {
                                var url = "${g.createLink(controller: 'reportes5',action: 'reporteEspecificacionesObra')}?id=" + idObra;
                                location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url
                            },

                            "Cancelar": function () {
                            }
                        }
                    }
                });
        return false;
    });


    %{--$.jGrowl.defaults.closerTemplate = '<div>[ cerrar todo ]</div>';--}%

    %{--function log(msg, error) {--}%
        %{--var sticky = false;--}%
        %{--var theme = "success";--}%
        %{--if (error) {--}%
            %{--sticky = true;--}%
            %{--theme = "error";--}%
        %{--}--}%
        %{--$.jGrowl(msg, {--}%
            %{--speed: 'slow',--}%
            %{--sticky: sticky,--}%
            %{--theme: theme,--}%
            %{--themeState: ''--}%
        %{--});--}%
    %{--}--}%

    %{--$(".cronograma").click(function () {--}%
        %{--var obraC = $(this).attr("iden");--}%
        %{--location.href="${createLink(controller: 'cronogramaContratoN', action: 'cronogramaContrato')}/" + obraC--}%
    %{--});--}%


    %{--$(".copiarRubros").click(function () {--}%
        %{--var obraC = $(this).attr("iden");--}%
        %{--$.ajax({--}%
            %{--type: 'POST',--}%
            %{--url: '${createLink(controller: 'contrato', action: 'revisarRubros_ajax')}',--}%
            %{--data:{--}%
                %{--obra: $(this).attr("iden"),--}%
                %{--oferta: '${oferta?.id}'--}%
            %{--},--}%
            %{--async: false,--}%
            %{--success: function (msg1){--}%
                %{--console.log('retorna:', msg1)--}%
                %{--if(msg1 == 'no'){--}%
                    %{--if (confirm("Esta seguro de copiar los rubros de esta obra hacia el contrato?")) {--}%
                        %{--$.ajax({--}%
                            %{--type: "POST",--}%
                            %{--url: "${g.createLink(controller: 'contrato', action:'copiarRubros_ajax')}",--}%
                            %{--data: {--}%
                                %{--obra: obraC,--}%
                                %{--oferta: '${oferta?.id}',--}%
                                %{--contrato: ${contrato?:0}--}%
                            %{--},--}%
                            %{--success: function (msg) {--}%
                                %{--if(msg == 'ok'){--}%
                                    %{--log("Rubros copiados correctamente!", false);--}%
                                %{--}else{--}%
                                    %{--log("Error al copiar los rubros al contrato!", true);--}%
                                %{--}--}%
                            %{--}--}%
                        %{--});--}%
                    %{--}--}%
                %{--}--}%
            %{--}--}%
        %{--})--}%
        %{--var url = "${g.createLink(controller: 'volumenObra', action:'volObraContrato')}" + "/" + obraC--}%
        %{--location.href = url;--}%
    %{--});--}%

    %{--$(".actualizarObra").click(function () {--}%
        %{--var obra = $(this).attr("iden");--}%
        %{--$.ajax({--}%
            %{--type:'POST',--}%
            %{--url: "${createLink(controller: 'contrato', action: 'actualizarValorObra_ajax')}",--}%
            %{--data:{--}%
                %{--obra: obra--}%
            %{--},--}%
            %{--success: function (msg){--}%
                %{--var parts = msg.split("_")--}%
                %{--if(parts[0] == 'ok'){--}%
                    %{--log("Valor de la obra actualizado correctamente!", false);--}%
                    %{--cargarTablaObras(parts[1])--}%
                %{--}else{--}%
                    %{--log("Error al actualizar el valor de la obra", true)--}%
                %{--}--}%
            %{--}--}%
        %{--})--}%
    %{--});--}%

</script>