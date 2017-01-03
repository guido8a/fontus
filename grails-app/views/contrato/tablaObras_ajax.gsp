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
                    <a href="#" class="btn btn-success btn-small copiarRubros" iden="${obra?.id}" title="Rubros contratados">
                        <i class="icon-copy"></i>
                    </a>
                    <a href="#" class="btn btn-success btn-small cronograma" iden="${obra?.id}" title="Cronograma de la obra">
                        <i class="icon-calendar"></i>
                    </a>
                    <g:if test="${janus.Contrato.get(contrato).estado != 'R'}">
                        <a href="#" class="btn btn-success btn-small actualizarObra" iden="${obra?.id}" title="Actualizar valor de la Obra">
                            <i class="icon-pencil"></i>
                        </a>
                    </g:if>
                 </td>
               </g:if>
            </tr>
        </g:each>
    </tbody>
</table>


<script type="text/javascript">


    $.jGrowl.defaults.closerTemplate = '<div>[ cerrar todo ]</div>';

    function log(msg, error) {
        var sticky = false;
        var theme = "success";
        if (error) {
            sticky = true;
            theme = "error";
        }
        $.jGrowl(msg, {
            speed: 'slow',
            sticky: sticky,
            theme: theme,
            themeState: ''
        });
    }

    $(".cronograma").click(function () {
        var obraC = $(this).attr("iden");
        location.href="${createLink(controller: 'cronogramaContratoN', action: 'cronogramaContrato')}/" + obraC
    });


    $(".copiarRubros").click(function () {
        var obraC = $(this).attr("iden");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'contrato', action: 'revisarRubros_ajax')}',
            data:{
                obra: $(this).attr("iden"),
                oferta: '${oferta?.id}'
            },
            async: false,
            success: function (msg1){
                console.log('retorna:', msg1)
                if(msg1 == 'no'){
                    if (confirm("Esta seguro de copiar los rubros de esta obra hacia el contrato?")) {
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(controller: 'contrato', action:'copiarRubros_ajax')}",
                            data: {
                                obra: obraC,
                                oferta: '${oferta?.id}',
                                contrato: ${contrato?:0}
                            },
                            success: function (msg) {
                                if(msg == 'ok'){
                                    log("Rubros copiados correctamente!", false);
                                }else{
                                    log("Error al copiar los rubros al contrato!", true);
                                }
                            }
                        });
                    }
                }
            }
        })
        var url = "${g.createLink(controller: 'volumenObra', action:'volObraContrato')}" + "/" + obraC
        location.href = url;
    });

    $(".actualizarObra").click(function () {
        var obra = $(this).attr("iden");
       $.ajax({
           type:'POST',
           url: "${createLink(controller: 'contrato', action: 'actualizarValorObra_ajax')}",
           data:{
                obra: obra
           },
           success: function (msg){
               var parts = msg.split("_")
                if(parts[0] == 'ok'){
                    log("Valor de la obra actualizado correctamente!", false);
                    cargarTablaObras(parts[1])
                }else{
                    log("Error al actualizar el valor de la obra", true)
                }
           }
       })
    });

</script>