<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 20/10/16
  Time: 10:35
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 11/22/12
  Time: 12:59 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Rubro :${rubro.codigo}</title>

    <rep:estilos orientacion="h" pagTitle="ESPECIFICACIONES"/>

    <link href="../font/open/stylesheet.css" rel="stylesheet" type="text/css"/>
    <link href="../font/tulpen/stylesheet.css" rel="stylesheet" type="text/css"/>
    <link href="../css/custom.css" rel="stylesheet" type="text/css"/>
    <link href="../css/font-awesome.css" rel="stylesheet" type="text/css"/>
    <style type="text/css">
    @page {
        size   : 21cm 29.7cm;  /*width height */
        margin-left : 2cm;
        margin-top: 1cm;
    }

    body {
        background : none !important;
    }

    .hoja {
        /*background  : #e6e6fa;*/
        height      : 20.7cm !important; /*29.7-(1.5*2)*/
        font-family : serif;
        font-size   : 10px;
        width       : 16cm;
    }

    .tituloPdf {
        height        : 100px;
        font-size     : 11px;
        text-align    : center;
        margin-bottom : 5px;
        width         : 95%;
    }

    .grande{

        font-size: 18px;
    }

    .totales {
        font-weight : bold;
    }

    .num {
        text-align : right;
    }

    .header {
        background : #333333 !important;
        color      : #AAAAAA;
    }

    .total {
        background : #000000 !important;
        color      : #FFFFFF !important;
    }
    thead tr {
        margin : 0px
    }

    th, td {
        font-size : 10px !important;
    }

    .theader {
        border-bottom: 1px solid #000000;
    }

    .theaderup {
        border-top: 1px solid #000000;
    }

    .marginTop{
        margin-top:20px !important;
    }

    .tituloHeader{
        font-size: 14px !important;
    }

    .padTopBot{
        padding-top: 7px !important;
        padding-bottom: 7px !important;
    }

    .row-fluid {
        width  : 100%;
        height : 20px;
    }

    .span3 {
        width  : 29%;
        float  : left;
        height : 100%;
    }

    .span8 {
        width  : 79%;
        float  : left;
        height : 100%;
    }

    .span7 {
        width  : 69%;
        float  : left;
        height : 100%;
    }


    </style>
</head>

<body>
<div class="hoja">
    <rep:headerFooter title="DIRECCIÓN NACIONAL DE COSTOS Y PLANEAMIENTO" subtitulo="ESPECIFICACIONES" estilo="right"/>


    %{--<div style="margin-top: 20px">--}%
        %{--<div class="row-fluid">--}%
            %{--<div class="span3" style="margin-right: 195px !important;">--}%
                %{--<g:if test="${fechaPala}">--}%
                    %{--<b>Fecha:</b> ${fechaPala.format("dd-MM-yyyy")}--}%
                %{--</g:if>--}%
                %{--<g:else>--}%
                    %{--<b>Fecha:</b>--}%
                %{--</g:else>--}%
            %{--</div>--}%

            %{--<div class="span4">--}%
                %{--<g:if test="${fechaPrecios}">--}%
                    %{--<b>Fecha Act. P.U:</b> ${fechaPrecios.format("dd-MM-yyyy")}--}%
                %{--</g:if>--}%
                %{--<g:else>--}%
                    %{--<b>Fecha Act. P.U:</b>--}%
                %{--</g:else>--}%
            %{--</div>--}%



        %{--</div>--}%

        %{--<div class="row-fluid">--}%
            %{--<div class="span3" style="margin-right: 195px !important;">--}%
                %{--<b>Código de rubro:</b> ${rubro?.codigo}--}%
            %{--</div>--}%

            %{--<div class="span3">--}%
                %{--<b>Unidad:</b> ${rubro?.unidad?.codigo}--}%
            %{--</div>--}%
        %{--</div>--}%

        %{--<div class="row-fluid">--}%
            %{--<div class="span12">--}%
                %{--<b>Código de especificación:</b> ${rubro?.codigoEspecificacion}--}%
            %{--</div>--}%
        %{--</div>--}%

        %{--<div class="row-fluid">--}%
            %{--<div class="span12">--}%
                %{--<b>Descripción:</b> ${rubro.nombre}--}%
            %{--</div>--}%
        %{--</div>--}%
    %{--</div>--}%

    <div style="width: 100%;margin-top: 10px;">



        <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 40px;width: 50%;float: right; border-top: 1px solid #000000;  border-bottom: 1px solid #000000">
            <tbody>
            <tr style="">
                <td style="width: 350px;">
                    <b>1. DESCRIPCIÓN</b>
                </td>
                <td style="text-align: right">
                    ${rubro?.descripcion}
                </td>
            </tr>
            <tr>
                <td>
                    <b>2. ESPECIFICACIONES</b>
                </td>
                <td style="text-align: right">
                    ${rubro?.especificaciones}
                </td>
            </tr>
            <tr>
                <td>
                    <b>6. MEDICIÓN Y PAGO</b>
                </td>
                <td style="text-align: right">
                    ${rubro?.pago}
                </td>
            </tr>
            </tbody>
        </table>

    </div>
</div>
</body>
</html>