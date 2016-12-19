<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/12/16
  Time: 15:22
--%>



<table class="table table-bordered table-striped table-condensed table-hover">
    <tbody id="tabla_material">

    <g:each in="${valores}" var="val" status="j">
        <tr>
            <td style="width: 20px" class="orden">${val?.volumenOrden}</td>
            <td style="width: 200px" class="sub">${val?.subPresupuesto?.descripcion}</td>
            <td class="cdgo">${val?.item?.codigo}</td>
            <td class="nombre">${val?.item?.nombre}</td>
            <td style="width: 60px !important;text-align: center" class="col_unidad">${val?.item?.unidad?.codigo}</td>
            <td style="text-align: right" class="cant">
                <g:formatNumber number="${val.volumenCantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2"
                                locale="ec"/>
            </td>
            <td class="col_precio" style="text-align: right" id="i_${val.id}"><g:formatNumber
                    number="${val.volumenPrecio}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td class="col_total total" style="display: none;text-align: right">
                <g:formatNumber number="${val.volumenSubtotal}" format="##,##0" minFractionDigits="2"  maxFractionDigits="2"  locale="ec"/>
            </td>
            <td style="width: 30px">
                <a href="#" class="btn btn-danger btn-small item_borrar" title="Borrar rubro" iden="${val?.id}">
                    <i class="icon-trash"></i>
                </a>

            </td>
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

    $(".item_borrar").click(function () {
           var vocr = $(this).attr("iden");
        if (confirm("Esta seguro de eliminar este rubro del contrato?")) {
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'volumenObra', action: 'borrarRubroContrato_ajax')}',
                data:{
                    id: vocr
                },
                success: function (msg){
                    if(msg == 'ok'){
                        log("Rubro borrado correctamente!", false);
                        cargarTabla($("#subPresContrato").val());
                    }else{
                        log("Error al borrar el rubro!", true);
                    }
                }

            })
        }
    });


</script>