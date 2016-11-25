<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 25/11/16
  Time: 13:10
--%>



<g:select name="subpresupuestoDes" from="${destino}" optionKey="id" optionValue="descripcion" style="width: 350px;font-size: 10px;" id="subPres_destino"
          noSelection="['-1' : 'Seleccione un subpresupuesto...']" title="${"Obra: " + obra?.descripcion}"/>


<script type="text/javascript">


    cargarAreaDestino('${obra?.id}', $("#subPres_destino").val());

    function cargarAreaDestino(obra, subpre) {
        $.ajax({
            type:'POST',
            url: "${createLink(controller: 'volumenObra', action: 'cargarAreaDestino_ajax')}",
            data:{
                obra: obra,
                sbpr: subpre
            },
            success: function (msg) {
                $("#divAreaDestino").html(msg)
            }
        })
    }

    $("#subPres_destino").change(function(){
        var subpDestino = $("#subPres_destino").val()
        var obraDestino = ${obra?.id}
        cargarAreaDestino(obraDestino, subpDestino)
    });

</script>
