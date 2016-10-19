<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 19/10/16
  Time: 10:10
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Especificaciones</title>
</head>

<body>

<script src="${resource(dir: 'js/jquery/plugins/ckeditor', file: 'ckeditor.js')}"></script>

<div class="span12 hide" style="margin-bottom: 10px;" id="divError">
    <div class="alert alert-error" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanError"></span>
    </div>
</div>

<div class="span12 hide" style="margin-bottom: 10px;" id="divOk">
    <div class="alert alert-success" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanOk"></span>
    </div>
</div>


<fieldset class="" style="position: relative; padding: 10px;border-bottom: 1px solid black;">
    <div class="span12" style="margin-top: 10px; margin-bottom: 5px;">
        <div class="span1 formato label">Código:</div>
        <div class="span3"><g:textField name="codigo" class="" value="${rubro?.codigo}" readonly="true"/></div>

        <div class="span1 formato label">Rubro:</div>
        <div class="span5"><g:textField name="memo" class="" value="${rubro?.nombre}" readonly="true" style="width: 500px"/></div>
    </div>
</fieldset>

<fieldset class="span-10" style="position: relative; padding: 10px;border-bottom: 1px solid black;">
    <p class="css-vertical-text">Descripción</p>
    <div class="linea" style="height: 85%;"></div>
    <div class="span10">
        <textarea name="editorR" id="editorR" rows="30" cols="80">${rubro?.descripcion}</textarea>
    </div>
</fieldset>

<fieldset class="span-10" style="position: relative; padding: 10px;border-bottom: 1px solid black;">
    <p class="css-vertical-text">Especificación</p>
    <div class="linea" style="height: 85%;"></div>
    <div class="span10">
        <textarea name="editorE" id="editorE" rows="30" cols="80">${rubro?.especificaciones}</textarea>
    </div>
</fieldset>

<fieldset class="span-10" style="position: relative; padding: 10px;border-bottom: 1px solid black;">
    <p class="css-vertical-text">Pago</p>
    <div class="linea" style="height: 85%;"></div>
    <div class="span10">
        <textarea name="editorP" id="editorP" rows="30" cols="80">${rubro?.pago}</textarea>
    </div>
</fieldset>


<script>
    CKEDITOR.replace( 'editorR', {
        height: "150px"
    });
    CKEDITOR.replace( 'editorE', {
        height: "150px"
    });
    CKEDITOR.replace( 'editorP', {
        height: "150px"
    });
</script>

<div class="row span12" style="text-align: center; margin-top: 30px">
    <a href="#" class="btn btn-ajax btn-new btn-primary" id="btnRegresar" title="Retornar a rubros">
        <i class="icon-arrow-left"></i>
        Regresar
    </a>
    <a href="#" class="btn btn-ajax btn-new btn-success" id="btnGuardarDescripcion" title="Guardar descripción">
        <i class="icon-save"></i>
        Guardar Texto
    </a>
</div>


<script>
    $("#btnGuardarDescripcion").click(function () {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'rubro', action: 'guardarDescripcion_ajax')}",
            data: {
                descripcion: CKEDITOR.instances.editorR.getData(),
                especificacion: CKEDITOR.instances.editorE.getData(),
                pago: CKEDITOR.instances.editorP.getData(),
                id: '${rubro?.id}'
            },
            success: function (msg) {
                if(msg == 'ok'){
                    $("#spanOk").html("Texto guardado correctamente");
                    $("#divOk").show()
                    setTimeout(function () {
                        $("#divOk").hide()
                    }, 1500);
                }else{
                    $("#spanError").html("Error al guardar el texto");
                    $("#divError").show()
                }

            }
        })
    });

    $("#btnRegresar").click(function () {
       location.href="${createLink(controller: 'rubro', action: 'rubroPrincipal')}?idRubro=" + '${rubro?.id}'
    });
</script>



</body>
</html>