<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/12/16
  Time: 10:36
--%>

<g:select name="subpresupuesto" from="${subPres}" optionKey="id" optionValue="descripcion"
          style="width: 300px;font-size: 12px; margin-right: 10px" id="subPresContrato"
          noSelection="['-1': 'Seleccione']"/>

<script type="text/javascript">

//    if($("#subPresContrato").val() == '-1'){
//        cargarTabla($("#subPresContrato").val(), 'no')
//    }

    $("#subPresContrato").change(function () {
        var sb = $(this).val();
        if(sb == '-1'){
            $("#divArea").html('');
            $("#detalle").html('');
//            cargarTabla(sb, 'no')
        }else{
            $("#detalle").html('')
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'volumenObra', action: 'area_ajax')}',
                data:{
                    sub: sb,
                    obra: '${obra?.id}'
                },
                success: function (msg) {
                    $("#divArea").html(msg)
                }
            })
        }
    });

</script>