<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 25/11/16
  Time: 12:09
--%>

<g:select name="area" from="${areas}" optionKey="id"
          optionValue="descripcion" style="width: 300px; font-size: 12px;" id="areaCopiar" noSelection="['-1' : 'Seleccione un área...']"/>


<script type="text/javascript">

    $("#areaCopiar").change(function(){
        cargarTabla();
    });

</script>