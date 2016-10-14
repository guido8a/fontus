<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Carga de archivo</title>
    </head>

    <body>
        <div class="well">
            <g:link class="btn btn-primary" controller="inicio" action="formArchivo" id="${obra}">Regresar a cargar archivos</g:link>
            <g:link class="btn btn-primary" controller="inicio" action="parametros" id="${obra}">Regresar a parámetros</g:link>
            ${flash.message}
            <g:link class="btn btn-primary" controller="inicio" action="formArchivo" id="${obra}">Regresar a cargar archivos</g:link>
            <g:link class="btn btn-primary" controller="inicio" action="parametros" id="${obra}">Regresar a parámetros</g:link>
        </div>
    </body>
</html>