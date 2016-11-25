<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/11/16
  Time: 12:31
--%>



<g:select name="subpresupuestoOrg" from="${origen}" optionKey="id" optionValue="descripcion"
              style="width: 350px;font-size: 10px;" id="subPresOrigen" noSelection="['-1' : 'Seleccione un subpresupuesto...']" value=""/>


<script type="text/javascript">


    cargarAreaOrigen('${obra?.id}', $("#subPresOrigen").val());

    function cargarAreaOrigen (obra, subpre) {
        $.ajax({
            type:'POST',
            url: "${createLink(controller: 'volumenObra', action: 'cargarAreaOrigen_ajax')}",
            data:{
                obra: obra,
                sbpr: subpre
            },
            success: function (msg) {
                $("#divAreaOrigen").html(msg)
            }
        })
    }

    $("#subPresOrigen").change(function(){
          $("#detalle").html('')
        var subpOrigen =  $("#subPresOrigen").val()
        var obraOrigen = ${obra?.id}
        cargarAreaOrigen(obraOrigen, subpOrigen)
    });

</script>
