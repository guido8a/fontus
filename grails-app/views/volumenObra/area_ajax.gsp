<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/12/16
  Time: 11:27
--%>
<b>Área:</b>
<g:select name="areaC" id="areasContrato" from="${areas}" optionKey="id" optionValue="descripcion"
          style="font-size: 12px; width: 240px" noSelection="['-1': 'Seleccione...']"/>

<script type="text/javascript">

    $("#areasContrato").change(function () {
        var area = $(this).val();
        if(area != '-1'){
            cargarTabla('${sub?.id}', area)
        }else{
           $("#detalle").html('')
        }

    });

</script>