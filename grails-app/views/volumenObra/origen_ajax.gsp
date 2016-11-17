<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/11/16
  Time: 12:31
--%>



    <g:select name="subpresupuestoOrg" from="${origen}" optionKey="id" optionValue="descripcion"
              style="width: 300px;font-size: 10px;" id="subPresOrigen" noSelection="['-1' : 'Seleccione un subpresupuesto...']" value=""></g:select>


<script type="text/javascript">

    $("#subPresOrigen").change(function(){
        cargarTabla();
    });

</script>
