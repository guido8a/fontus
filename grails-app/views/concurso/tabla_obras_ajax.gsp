<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/12/16
  Time: 12:20
--%>

<table class="table table-bordered table-striped table-condensed table-hover">
    <tbody id="tabla_obras">
    <g:each in="${obras}" var="obra">
        <tr class="item_row" id="${obra?.id}">
            <td style="width: 20px">${obra?.obra?.codigo}</td>
            <td style="width: 180px">${obra?.obra?.nombre}</td>
            <td style="width: 80px; text-align: right"><g:formatNumber number="${obra?.valor}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/></td>
            <td style="width: 45px; text-align: center">
                <a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Quitar obra"
                   iden="${obra?.id}">
                    <i class="icon-trash"></i></a>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $(".borrarItem").click(function () {
        if (confirm("Esta seguro de quitar la obra del concurso?")) {
            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: 'concurso',action:'eliminarObra_ajax')}",
                data: {
                    obra: $(this).attr("iden"),
                    concurso: '${concurso?.id}'
                },
                success: function (msg) {
                    var part = msg.split("_");
                    if(part[0] == 'ok'){
                        cargarTablaObras();
                        log(part[1], false);
                    }else{
                        cargarTablaObras();
                        log(part[1], true);
                    }
                }
            });
        }
    });


</script>