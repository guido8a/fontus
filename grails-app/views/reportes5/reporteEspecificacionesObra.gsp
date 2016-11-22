<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/11/16
  Time: 10:51
--%>

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

<%@ page import="janus.Rubro" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Obra :${obra?.descripcion}</title>

    <rep:estilos orientacion="h" pagTitle="ESPECIFICACIONES DE LA OBRA"/>

    <link href="../font/open/stylesheet.css" rel="stylesheet" type="text/css"/>
    <link href="../font/tulpen/stylesheet.css" rel="stylesheet" type="text/css"/>
    <link href="../css/custom.css" rel="stylesheet" type="text/css"/>
    <link href="../css/font-awesome.css" rel="stylesheet" type="text/css"/>
    <style type="text/css">
    @page {
        size   : 21cm 29.7cm;  /*width height */
        margin-left : 2.4cm;
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

    thead tr {
        margin : 0px
    }

    th, td {
        font-size : 10px !important;
    }

    </style>
</head>

<body>
<div class="hoja">
    <rep:headerFooter title="DIRECCIÓN NACIONAL DE COSTOS Y PLANEAMIENTO" subtitulo="ESPECIFICACIONES" estilo="right"/>

    <g:each in="${rubros}" var="rubro" >

        <table class="table table-bordered table-striped table-condensed table-hover " style="margin-top: 30px; border-top: 1px solid #000000;  border-bottom: 1px solid #000000;
        border-right: 1px solid #000000; border-left: 1px solid #000000; width: 600px">
            <tbody>
            <tr style="border-bottom: 1px solid #000000; border-right: 1px solid #000000; text-align: center">
                <td  style="border-bottom: 1px solid #000000; border-right: 1px solid #000000"><b>CÓDIGO SECOB</b></td>
                <td  style="border-bottom: 1px solid #000000; border-right: 1px solid #000000"><b>DESCRIPCIÓN</b></td>
                <td style="border-bottom: 1px solid #000000;"><b>UNIDAD</b></td>
            </tr>
            <tr style="border-top: 1px solid #000000; border-right: 1px solid #000000; text-align: center">
                <td style="border-right: 1px solid #000000">${rubro?.codigo}</td>
                <td style="border-right: 1px solid #000000"><acta:clean str="${rubro?.nombre?.toUpperCase()}"/></td>
                <td>${rubro?.unidad}</td>
            </tr>
            </tbody>
        </table>
        <div style="width: 100%;margin-top: 10px;">

            <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 20px;">
                <tbody>
                <tr>
                    <td style="width: 350px;">
                        <b>1. DESCRIPCIÓN.- </b>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: justify">
                        %{--${rubro?.descripcion}--}%
                        <acta:clean str="${rubro?.descripcion}"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>2. ESPECIFICACIONES.-</b>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: justify">
                        %{--${rubro?.especificaciones}--}%
                        <acta:clean str="${rubro?.especificaciones}"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>3. MATERIALES.-</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tbody>
                            <g:each in="${janus.Rubro.findAllByRubro(rubro)}" var="rub1" status="i">
                                <g:if test="${rub1.item.departamento.subgrupo.grupo.id == 1}">
                                    <tr>
                                        <td style="width: 80px">${rub1?.item?.codigo}</td>
                                        <td><acta:clean str="${rub1?.item?.nombre ?: ''}"/></td>
                                    </tr>
                                </g:if>
                            </g:each>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>4. EQUIPO.-</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tbody>
                            <g:each in="${janus.Rubro.findAllByRubro(rubro)}" var="rub3" status="i">
                                <g:if test="${rub3.item.departamento.subgrupo.grupo.id == 3}">
                                    <tr>
                                        <td style="width: 80px">${rub3?.item?.codigo}</td>
                                        <td><acta:clean str="${rub3?.item?.nombre}"/></td>
                                    </tr>
                                </g:if>
                            </g:each>

                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>5. MANO DE OBRA.-</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tbody>
                            <g:each in="${janus.Rubro.findAllByRubro(rubro)}" var="rub" status="i">
                                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">
                                    <tr>
                                        <td style="width: 80px">${rub?.item?.codigo}</td>
                                        <td><acta:clean str="${rub?.item?.nombre}"/></td>
                                    </tr>
                                </g:if>
                            </g:each>
                            </tbody>
                        </table>
                    </td>
                </tr>

                <tr>
                    <td>
                        <b>6. MEDICIÓN Y PAGO.-</b>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: justify">
                        <acta:clean str="${rubro?.pago}"/>
                    </td>
                </tr>
                </tbody>
            </table>

        </div>
    </g:each>




</div>
</body>
</html>