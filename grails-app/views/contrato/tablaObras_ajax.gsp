<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/12/16
  Time: 14:46
--%>

<table class="table table-bordered table-striped table-condensed table-hover">
    <tbody id="tabla_material">
    <g:each in="${obras}" var="obra">
        <tr>
            <td style="width: 15px" >${obra?.obra?.codigo}</td>
            <td style="width: 270px" >${obra?.obra?.nombre}</td>
            <td style="width: 10px; text-align: right"><g:formatNumber number="${obra?.valor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td style="width: 10px" title="${"Parroquia: " + obra?.obra?.parroquia?.nombre + " - Cantón: " + obra?.obra?.parroquia?.canton?.nombre}">${obra?.obra?.parroquia?.canton?.provincia?.nombre}</td>
            <td  style="width: 10px"><a href="#" class="btn btn-success btn-small copiarRubros" iden="${obra?.obra?.id}"><i class="icon-copy"></i></a></td>
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

    $(".copiarRubros").click(function () {
        var obraC = $(this).attr("iden")
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'contrato', action: 'revisarRubros_ajax')}',
            data:{
                obra: $(this).attr("iden"),
                oferta: '${oferta?.id}'
            },
            success: function (msg1){
                if(msg1 == 'no'){
                    if (confirm("Esta seguro de copiar los rubros de esta obra hacia el contrato?")) {
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(controller: 'contrato',action:'copiarRubros_ajax')}",
                            data: {
                                obra: obraC,
                                oferta: '${oferta?.id}'
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
                }else{
                    log("Los rubros de esta obra ya se encuentran copiados al contrato!", true);
                }
            }
        })
    });

</script>