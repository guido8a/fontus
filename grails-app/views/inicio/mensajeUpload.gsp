<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 8/29/13
  Time: 3:19 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Carga de archivo</title>
    </head>

    <body>
        <div class="well">
            <g:link class="btn btn-primary" controller="inicio" action="formArchivo" id="${obra}">Regresar a cargar archivos</g:link>
            ${flash.message}
            <g:link class="btn btn-primary" controller="inicio" action="parametros" id="${obra}">Regresar a parámetros</g:link>
        </div>
    </body>
</html>